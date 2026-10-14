
return {
  pack = {
    { src = 'https://github.com/MunifTanjim/nui.nvim' },

    { src = 'https://github.com/saxon1964/neovim-tips', version = vim.version.range '*' },
    -- OPTIONAL: Choose your preferred markdown renderer (or omit for raw markdown)
    -- also installed/configured by lua/plugins/quarto_marldown.lua
    { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
    -- OR: { src = 'https://github.com/OXY2DEV/markview.nvim' }, -- Rich rendering with advanced features
  },

  config = function()
    require('neovim-tips').setup {
      -- IMPORTANT: Daily tip needs the plugin loaded at startup, which is now always the case,
      -- so daily_tip = 1 or 2 works fine here (unlike under the old lazy = true config).
      daily_tip = 0, -- 0 = off, 1 = once per day, 2 = every startup
      -- Other optional settings...
      user_file = vim.fn.stdpath("config") .. "/neovim_tips/user_tips.md",
user_file = vim.fn.stdpath("config") .. "/neovim_tips/user_tips.md",

      bookmark_symbol = '🌟 ',
    }

    local map = vim.keymap.set
    map('n', '<leader>nto', ':NeovimTips<CR>', { desc = 'Neovim tips' })
    map('n', '<leader>ntb', ':NeovimTipsBookmarks<CR>', { desc = 'Bookmarked tips' })
    map('n', '<leader>ntr', ':NeovimTipsRandom<CR>', { desc = 'Show random tip' })
    map('n', '<leader>nte', ':NeovimTipsEdit<CR>', { desc = 'Edit your tips' })
    map('n', '<leader>nta', ':NeovimTipsAdd<CR>', { desc = 'Add your tip' })
    map('n', '<leader>ntp', ':NeovimTipsPdf<CR>', { desc = 'Open tips PDF' })
  end,
}
