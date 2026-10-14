-- The `cp ./*.py ~/.config/kitty/` build step (was `build = "..."` under lazy.nvim) now runs
-- from the PackChanged autocmd in lua/config/pack.lua, since vim.pack specs have no `build` field.

return {
  pack = {
    { src = 'https://github.com/knubie/vim-kitty-navigator' },
  },

  -- no config() needed: this is a Vimscript plugin, its commands/mappings come from its own
  -- plugin/ script, which vim.pack sources automatically because we pass load = true.
}
