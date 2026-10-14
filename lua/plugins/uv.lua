return {
  pack = {
    { src = 'https://github.com/benomahony/uv.nvim' },
    -- Optional dependency, but recommended:
    -- { src = 'https://github.com/folke/snacks.nvim' },
    -- or telescope.nvim, already installed by lua/plugins/telescope.lua
  },

  config = function()
    require('uv').setup {
      picker_integration = true,
    }
  end,
}
