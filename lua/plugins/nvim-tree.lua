return {
  pack = {
    { src = 'https://github.com/nvim-tree/nvim-tree.lua', version = vim.version.range '*' },
    -- nvim-web-devicons is already installed by lua/plugins/colors.lua (lualine's dependency),
    -- which runs before this module -- no need to list it again here.
  },

  config = function()
    require('nvim-tree').setup {}
    vim.keymap.set('n', '<leader>e', ':NvimTreeFindFileToggle<cr>')
  end,
}
