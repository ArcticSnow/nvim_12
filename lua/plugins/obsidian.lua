return {
  pack = {
    { src = 'https://github.com/obsidian-nvim/obsidian.nvim', version = vim.version.range '*' },
  },

  config = function()
    ---@module 'obsidian'
    ---@type obsidian.config
    require('obsidian').setup {
      legacy_commands = false, -- this will be removed in the next major release
      workspaces = {
        {
          name = 'work',
          path = '/home/filhols/Documents/MF_vault/',
        },
      },
    }
  end,
}
