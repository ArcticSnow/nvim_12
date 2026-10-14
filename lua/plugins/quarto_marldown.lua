-- NOTE on quarto-nvim's loading: see the big comment at the top of lua/config/pack.lua for why
-- this isn't deferred to `FileType quarto` the way it was lazy-loaded (`ft = 'quarto'`) before --
-- *.qmd is only recognized as filetype "quarto" because this plugin's own ftdetect defines it,
-- so deferring on that event would mean it never gets a chance to load.

return {
  pack = {
    -- requires plugins in lua/plugins/treesitter.lua and lua/plugins/lsp.lua
    -- for complete functionality (language features)
    { src = 'https://github.com/quarto-dev/quarto-nvim' },
    -- for language features in code cells
    -- configured in lua/plugins/lsp.lua and
    -- added as a nvim-cmp source in lua/plugins/completion.lua
    { src = 'https://github.com/jmbuhr/otter.nvim' },

    -- highlight markdown headings and code blocks etc.
    -- (kept commented out, same as the original config)
    -- { src = 'https://github.com/lukas-reineke/headlines.nvim' },

    -- also installed by lua/plugins/neovim_tips.lua
    { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
  },

  config = function()
    require('quarto').setup {}

    -- headlines.nvim config kept for reference, same as the original (disabled):
    -- require('headlines').setup {
    --   quarto = {
    --     query = vim.treesitter.query.parse(
    --       'markdown',
    --       [[
    --           (fenced_code_block) @codeblock
    --           ]]
    --     ),
    --     codeblock_highlight = 'CodeBlock',
    --     treesitter_language = 'markdown',
    --   },
    --   markdown = {
    --     query = vim.treesitter.query.parse(
    --       'markdown',
    --       [[
    --           (fenced_code_block) @codeblock
    --           ]]
    --     ),
    --     codeblock_highlight = 'CodeBlock',
    --   },
    -- }

    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    -- NOTE: the original spec had `heading = { border = true }` as a sibling of `opts = {}`
    -- rather than inside it -- lazy.nvim doesn't recognize `heading` as a spec field, so it was
    -- silently ignored and never actually reached render-markdown.nvim. Put it inside setup()
    -- below (uncommented) if you actually want that heading-border behavior.
    require('render-markdown').setup {
      -- heading = { border = true },
    }
  end,
}
