-- ================================================================================================
-- TITLE : plugin manager (native vim.pack, Neovim 0.12+)
-- ABOUT : Replaces the old lazy.nvim bootstrap. No third-party plugin manager is installed;
--         Nvim 0.12 ships vim.pack itself (see :h vim.pack).
--
-- How this file works:
--   1. Every file in lua/plugins/*.lua now returns a table shaped like:
--        { pack = <vim.pack.Spec or list of specs>, config = <function|nil> }
--      `pack` describes what to install, `config` is what used to live in lazy's `opts`/`config`.
--   2. We collect every `pack` entry from every module and install them ALL in a single
--      vim.pack.add() call (this is the pattern the official docs recommend).
--   3. We then run every module's `config()` function, in the same order the files are listed
--      below. Order matters where one plugin's config depends on another already being set up
--      (e.g. blink.cmp before nvim-lspconfig, mason before mason-lspconfig).
--
-- Notes vs. the old lazy.nvim setup:
--   - vim.pack has no built-in `ft=`/`keys=`/`event=` lazy-loading. Everything below loads at
--     startup, like `lazy = false` did before (see the `load = true` note below). Plugins that
--     used `ft`/`keys` under lazy.nvim (lazydev.nvim, quarto-nvim, neovim-tips, multiple-cursors)
--     now just load eagerly too -- they're small, so the startup cost is negligible. lazydev.nvim
--     is the one exception: it's set up with genuine deferred loading in lua/plugins/lsp.lua, as
--     a worked example of the `load = false` + FileType autocmd + :packadd pattern, since Nvim
--     already knows the "lua" filetype natively (no chicken-and-egg ftdetect problem there).
--     quarto-nvim can't safely use the same trick: *.qmd is only recognized as filetype "quarto"
--     because quarto-nvim's own ftdetect script defines it, so deferring it on `FileType quarto`
--     would mean it never gets a chance to load in the first place.
--   - Build steps (telescope-fzf-native's `make`, vim-kitty-navigator's `cp`) are no longer a
--     `build = "..."` field on the spec. They're run from a PackChanged autocmd instead.
--   - Plugins are managed under stdpath("data") .. "/site/pack/core/opt" and tracked in
--     nvim-pack-lock.json (next to init.lua). Commit that lockfile like you did lazy-lock.json.
-- ================================================================================================

-- ---------------------------------------------------------------------------
-- Build/post-install hooks (must be registered BEFORE vim.pack.add(), so the
-- very first install is caught too)
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then
      return
    end
    if name == 'telescope-fzf-native.nvim' then
      vim.system({ 'make' }, { cwd = ev.data.path })
    elseif name == 'vim-kitty-navigator' then
      vim.system({ 'sh', '-c', 'cp ./*.py ~/.config/kitty/' }, { cwd = ev.data.path })
    end
  end,
})

-- ---------------------------------------------------------------------------
-- Collect specs from every lua/plugins/*.lua module and install them all at once
-- ---------------------------------------------------------------------------
local plugin_modules = {
  'colors',
  'blink',
  'lsp',
  'treesitter',
  'telescope',
  'mini',
  'oil',
  'nvim-tree',
  'obsidian',
  'auto-session',
  'multi_cursor',
  'neovim_tips',
  'onliner',
  'quarto_marldown',
  'uv',
  'vim-kitty_navigator',
}

local all_specs = {}
local loaded = {}

for _, name in ipairs(plugin_modules) do
  local mod = require('plugins.' .. name)
  loaded[name] = mod
  local pack = mod.pack
  if pack then
    -- allow either a single spec ({ src = ... }) or a list of specs ({ {src=...}, {src=...} })
    if pack.src or type(pack) == 'string' then
      table.insert(all_specs, pack)
    else
      vim.list_extend(all_specs, pack)
    end
  end
end

-- IMPORTANT: vim.pack.add()'s `load` option defaults to FALSE while init.lua is being
-- sourced (it only auto-sources plugin/ and ftdetect/ scripts once startup is over). That
-- silently breaks anything that depends on its plugin/ script running eagerly -- gitsigns,
-- vim-oscyank, vim-kitty-navigator's commands, quarto-nvim's *.qmd filetype detection, etc.
-- Passing `load = true` here reproduces lazy.nvim's old default of `lazy = false`.
vim.pack.add(all_specs, { load = true })

-- ---------------------------------------------------------------------------
-- Run each module's setup/config, in the same order as plugin_modules above
-- ---------------------------------------------------------------------------
for _, name in ipairs(plugin_modules) do
  local mod = loaded[name]
  if mod.config then
    mod.config()
  end
end
