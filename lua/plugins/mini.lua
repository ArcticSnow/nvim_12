-- ================================================================================================
-- TITLE : mini.nvim
-- LINKS :
--   > github : https://github.com/echasnovski/mini.nvim
-- ABOUT : Library of 40+ independent Lua modules.
-- ================================================================================================

-- lazy.nvim had `version = "*"` on each of these (latest tagged release, not the dev branch).
-- vim.version.range('*') is the vim.pack equivalent: install the greatest available semver tag.
local latest = vim.version.range '*'

return {
  pack = {
    { src = 'https://github.com/echasnovski/mini.ai', version = latest },
    { src = 'https://github.com/echasnovski/mini.comment', version = latest },
    { src = 'https://github.com/echasnovski/mini.move', version = latest },
    { src = 'https://github.com/echasnovski/mini.surround', version = latest },
    { src = 'https://github.com/echasnovski/mini.cursorword', version = latest },
    { src = 'https://github.com/echasnovski/mini.indentscope', version = latest },
    { src = 'https://github.com/echasnovski/mini.pairs', version = latest },
    { src = 'https://github.com/echasnovski/mini.trailspace', version = latest },
    { src = 'https://github.com/echasnovski/mini.bufremove', version = latest },
    { src = 'https://github.com/echasnovski/mini.notify', version = latest },
    { src = 'https://github.com/echasnovski/mini.icons', version = latest },
    { src = 'https://github.com/echasnovski/mini.bracketed', version = latest },
    { src = 'https://github.com/echasnovski/mini.snippets', version = latest },
  },

  config = function()
    require('mini.ai').setup {
      custom_textobjects = {
        -- Quarto code cell object
        x = { '```%S+%s()[^`]+()```' },
      },
    }
    require('mini.comment').setup {}
    require('mini.move').setup {}
    require('mini.surround').setup {}
    require('mini.cursorword').setup {}
    require('mini.indentscope').setup {}
    require('mini.pairs').setup {}
    require('mini.trailspace').setup {}
    require('mini.bufremove').setup {}
    require('mini.notify').setup {}
    require('mini.icons').setup {}
    require('mini.bracketed').setup {}
    require('mini.snippets').setup {}
  end,
}
