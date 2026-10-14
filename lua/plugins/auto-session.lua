-- Plugin to automatically reopen the files and windows as I had last time leaving.
-- https://github.com/rmagatti/auto-session

return {
  pack = {
    { src = 'https://github.com/rmagatti/auto-session' },
  },

  config = function()
    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    require('auto-session').setup {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      -- log_level = 'debug',
      cwd_change_handling = false,
    }
  end,
}
