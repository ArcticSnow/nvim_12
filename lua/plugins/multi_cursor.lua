-- ===================================================
--  Title: Plugin to get multiple cursor like in Sublime
--  URL: https://github.com/brenton-leighton/multiple-cursors.nvim
--
-- NOTE: the old lazy.nvim spec used `keys = {...}` to lazy-load this plugin the first time
-- one of these mappings was pressed. vim.pack has no such trigger, so it now just loads at
-- startup like everything else (it's a tiny plugin, the cost is negligible) and the keymaps
-- below are set directly instead of being generated from a `keys` table.
-- ===================================================

return {
  pack = {
    { src = 'https://github.com/brenton-leighton/multiple-cursors.nvim', version = vim.version.range '*' },
  },

  config = function()
    require('multiple-cursors').setup {}

    local map = vim.keymap.set
    map({ 'n', 'x' }, '<S-j>', '<Cmd>MultipleCursorsAddDown<CR>', { desc = 'Add cursor and move down' })
    map({ 'n', 'x' }, '<S-k>', '<Cmd>MultipleCursorsAddUp<CR>', { desc = 'Add cursor and move up' })

    map({ 'n', 'i', 'x' }, '<S-Up>', '<Cmd>MultipleCursorsAddUp<CR>', { desc = 'Add cursor and move up' })
    map({ 'n', 'i', 'x' }, '<S-Down>', '<Cmd>MultipleCursorsAddDown<CR>', { desc = 'Add cursor and move down' })

    map({ 'n', 'i' }, '<S-LeftMouse>', '<Cmd>MultipleCursorsMouseAddDelete<CR>', { desc = 'Add or remove cursor' })

    map({ 'x' }, '<S-m', '<Cmd>MultipleCursorsAddVisualArea<CR>', { desc = 'Add cursors to the lines of the visual area' })

    -- map({ 'n', 'x' }, '<Leader>a', '<Cmd>MultipleCursorsAddMatches<CR>', { desc = 'Add cursors to cword' })
    -- map({ 'n', 'x' }, '<Leader>A', '<Cmd>MultipleCursorsAddMatchesV<CR>', { desc = 'Add cursors to cword in previous area' })

    map({ 'n', 'x' }, '<S-d', '<Cmd>MultipleCursorsAddJumpNextMatch<CR>', { desc = 'Add cursor and jump to next cword' })
    map({ 'n', 'x' }, '<S-D', '<Cmd>MultipleCursorsJumpNextMatch<CR>', { desc = 'Jump to next cword' })

    map({ 'n', 'x' }, '<S-l', '<Cmd>MultipleCursorsLock<CR>', { desc = 'Lock virtual cursors' })
  end,
}
