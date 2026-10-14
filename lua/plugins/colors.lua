-- local function enable_transparency()
--     vim.api.nvim_set_hl(0, "Normal", {bg="none"})
-- end

return {
  pack = {
    { src = 'https://github.com/zaldih/themery.nvim' },
    { src = 'https://github.com/savq/melange-nvim', name = 'melange' },
    { src = 'https://github.com/rose-pine/neovim', name = 'rose-pine' },
    { src = 'https://github.com/neanias/everforest-nvim' },
    { src = 'https://github.com/folke/tokyonight.nvim' },
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  },

  config = function()
    require('themery').setup({
      themes = {
        {
          name = 'Everforest Dark',
          colorscheme = 'everforest',
          before = [[
            -- All this block will be executed before apply "set colorscheme"
            vim.opt.background = "dark"
          ]],
        },
        {
          name = 'Everforest Light',
          colorscheme = 'everforest',
          before = [[
            vim.opt.background = "light"
          ]],
        },
        {
          name = 'Tokyonight Moon',
          colorscheme = 'tokyonight-moon',
        },
        {
          name = 'Tokyonight Night',
          colorscheme = 'tokyonight-night',
        },
        {
          name = 'Rose Pine',
          colorscheme = 'rose-pine',
        },
        {
          name = 'Rose Pine Moon',
          colorscheme = 'rose-pine-moon',
        },
        {
          name = 'Rose Pine Dawn',
          colorscheme = 'rose-pine-dawn',
        },
        {
          name = 'Melange light',
          colorscheme = 'melange',
          before = [[
            vim.opt.background = "light"
          ]],
        },
        {
          name = 'Melange dark',
          colorscheme = 'melange',
          before = [[
            vim.opt.background = "dark"
          ]],
        },
      },
      -- add the config here
    })

    -- rose-pine (was set as this plugin's own `config` under lazy)
    vim.cmd('colorscheme rose-pine-dawn')

    -- everforest (was `lazy = false, priority = 100` under lazy, i.e. load before others;
    -- vim.pack has no priority field, so we just call setup() here like the rest)
    require('everforest').setup({
      -- Your config here
    })

    -- tokyonight (loaded after rose-pine above, so it wins as the active colorscheme,
    -- same order-dependent behavior as the original lazy.nvim config)
    vim.cmd.colorscheme 'tokyonight'
    -- enable_transparency()

    -- lualine
    local CurrentColorScheme = vim.g.colors_name or 'default'
    require('lualine').setup({
      options = {
        -- theme = CurrentColorScheme,
        icons_enabled = true,
        section_separators = { left = '', right = '' },
        component_separators = '|',
      },
    })
  end,
}
