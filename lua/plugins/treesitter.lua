-- ================================================================================================
-- nvim-treesitter -- MIGRATED TO THE `main` BRANCH
--
-- This is the one plugin in this config that needed a real rewrite, not just a mechanical
-- lazy->vim.pack translation. nvim-treesitter's `main` branch is a from-scratch rewrite:
--   - `require('nvim-treesitter.configs').setup({ highlight, indent, ensure_installed, ... })`
--     no longer exists.
--   - `ensure_installed`/`auto_install` are gone as config keys -- you call
--     `require('nvim-treesitter').install()` yourself, whenever you want.
--   - Highlighting is enabled per-buffer with Nvim's own `vim.treesitter.start()`, not a config flag.
--   - Indent is enabled by pointing 'indentexpr' at the plugin's indent function.
--
-- Dropped entirely: `incremental_selection` (your old <CR>/<S-CR>/<Tab> expand-selection keymaps).
-- That module does not exist on `main` and has no direct replacement -- Nvim 0.12 ships native
-- `an`/`in` treesitter-node text objects (see `:h v_an`), but those work differently (select a
-- node as a text object with an operator, not "keep pressing <CR> to grow the selection"). If you
-- want the old grow/shrink-selection feel back, you'll need a small third-party plugin for it;
-- nothing built-in is a drop-in replacement, so I left it out rather than fake something equivalent.
--
-- The typo'd `autotage = { enable = true }` from the old config wasn't a real treesitter-configs
-- key on the old branch either (it never did anything), so it's simply gone -- if you meant
-- nvim-ts-autotag, that's a separate plugin you'd need to add explicitly.
-- ================================================================================================

local ensure_installed = { 'lua', 'python', 'markdown', 'yaml', 'julia', 'ini', 'fortran', 'bibtex', 'markdown_inline' }

return {
  pack = {
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  },

  config = function()
    -- Batch-install the parsers you always want, up front (closest equivalent to the old
    -- `ensure_installed` list). Safe to call every start: already-installed parsers are skipped.
    local already_installed = require('nvim-treesitter.config').get_installed()
    local to_install = vim
      .iter(ensure_installed)
      :filter(function(lang)
        return not vim.tbl_contains(already_installed, lang)
      end)
      :totable()
    if #to_install > 0 then
      require('nvim-treesitter').install(to_install)
    end

    -- Enable highlighting + indent per-buffer, installing the parser on demand for anything
    -- not in the list above (closest equivalent to the old `auto_install = true`).
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match) or args.match
        if not lang or lang == '' then
          return
        end

        local function enable()
          pcall(vim.treesitter.start, args.buf)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end

        if vim.treesitter.language.add(lang) then
          -- parser already available locally
          enable()
        else
          -- not installed yet: fetch it, then enable
          local ok, job = pcall(require('nvim-treesitter').install, { lang })
          if ok and job and job.await then
            job:await(enable)
          end
        end
      end,
    })
  end,
}
