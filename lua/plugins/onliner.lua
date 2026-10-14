return {
  pack = {
    -- SSH yank
    { src = 'https://github.com/ojroques/vim-oscyank' },
    -- show keybinding help window
    { src = 'https://github.com/folke/which-key.nvim' },
    -- friendly-snippets is already installed by lua/plugins/blink.lua
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
    -- NOTE: gitsigns had no `opts`/`config` under the old lazy spec either, so it's still
    -- just installed here, not explicitly set up. Add a `require('gitsigns').setup {}` call
    -- below if you actually want it configured/active.
  },

  config = function()
    require('which-key').setup {}
    -- this was already required once from init.lua by the time this runs, so it's a harmless
    -- no-op re-require (Lua caches loaded modules) -- kept only to mirror the original config.
    require 'config.keybinds'
  end,
}
