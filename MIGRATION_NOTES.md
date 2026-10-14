# Migration notes: lazy.nvim → vim.pack, Neovim 0.11 → 0.12

This is a full migration of your config from lazy.nvim to Neovim 0.12's built-in `vim.pack`
plugin manager, with the other 0.12-related fixes that migration required. Read this once before
you drop it in `~/.config/nvim`.

## Requirements

- **Neovim 0.12.0 or newer.** `vim.pack` doesn't exist on 0.11.
- **Git.** `vim.pack` shells out to `git clone`/`git checkout` itself (no `curl`/`wget` fallback).

## How to try it safely

Your existing config is untouched. Test this one in parallel first:

```sh
git clone <this-migrated-repo> ~/.config/nvim-pack
NVIM_APPNAME=nvim-pack nvim
```

First launch will clone every plugin (`git clone`), which takes a bit and needs a network
connection. Subsequent launches are instant, like before.

## What changed, and why

### 1. Plugin manager: lazy.nvim → vim.pack

- `lua/config/lazy.lua` (the bootstrap that cloned lazy.nvim itself) is deleted -- nothing to
  bootstrap, `vim.pack` ships with Nvim 0.12.
- New `lua/config/pack.lua` replaces it in `init.lua`. It collects a `pack` spec (or list of
  specs) from every `lua/plugins/*.lua` file and installs them all in one `vim.pack.add()` call,
  then runs each file's `config()` function.
- Every file in `lua/plugins/` changed shape. Before:
  ```lua
  return { "author/plugin", opts = {...}, dependencies = {...} }
  ```
  Now:
  ```lua
  return {
    pack = { { src = "https://github.com/author/plugin" } },
    config = function() require("plugin").setup({...}) end,
  }
  ```
  `vim.pack` only installs plugins -- it doesn't know about `opts`/`config`/`dependencies` the
  way lazy.nvim did, so those are now plain code in each file's `config()`.
- **Lockfile**: lazy-lock.json is gone; `vim.pack` keeps `nvim-pack-lock.json` next to
  `init.lua`. I updated `.gitignore`, which was ignoring `lazy-lock.json` -- both the old and
  new lockfiles are meant to be *committed*, not ignored, for reproducible installs across
  machines.
- **Build steps** (`build = "make"`, `build = "cp ...")`) aren't a spec field anymore. They now
  run from a `PackChanged` autocmd at the top of `pack.lua` (covers
  `telescope-fzf-native.nvim` and `vim-kitty-navigator`).
- **No more `ft=`/`keys=`/`event=` lazy-loading.** `vim.pack` doesn't have it. Everything now
  loads at startup (equivalent to lazy.nvim's `lazy = false`), which is fine for small plugins
  but is a real behavior change worth knowing about. `lua/plugins/lsp.lua` includes lazydev.nvim
  as a worked example of doing manual deferred loading with `vim.pack.add(..., { load = false })`
  + a `FileType` autocmd + `:packadd` if you want to reproduce it elsewhere.
- I passed `{ load = true }` to the main `vim.pack.add()` call in `pack.lua`. Without it,
  `vim.pack` only adds plugins to the runtime path during `init.lua` sourcing but does **not**
  auto-source their `plugin/`/`ftdetect/` scripts -- which would have silently broken
  gitsigns, vim-oscyank, vim-kitty-navigator's commands, and quarto-nvim's `*.qmd` filetype
  detection. `load = true` restores the old always-on behavior.
- `version = "*"` (lazy.nvim: "latest tagged release") became
  `version = vim.version.range('*')` (mini.* modules, nvim-tree, obsidian.nvim,
  multiple-cursors.nvim, neovim-tips). `version = "1.*"` (blink.cmp) became
  `vim.version.range('1.0')`. `tag = "0.1.8"` (telescope.nvim) became `version = "0.1.8"`.

### 2. nvim-treesitter: migrated to its `main` branch

This is the one plugin that needed an actual rewrite, not just a mechanical translation.
`main` is a ground-up rewrite of nvim-treesitter that Nvim 0.12 users are expected to use;
the old `master` branch's `require('nvim-treesitter.configs').setup({...})` API is gone from it.
See the big comment at the top of `lua/plugins/treesitter.lua` for the details. Short version:

- `ensure_installed`/`auto_install` config keys → explicit `require('nvim-treesitter').install(...)`
  calls (still present, both the "install this fixed list up front" and "auto-install on demand"
  behaviors are reproduced).
- `highlight.enable`/`indent.enable` → `vim.treesitter.start()` + `indentexpr`, set from a
  `FileType` autocmd.
- **Dropped: `incremental_selection`** (your `<CR>`/`<S-Tab>` expand-selection keymaps). That
  module doesn't exist on `main` and nothing built-in replaces it exactly -- Nvim 0.12's native
  `an`/`in` treesitter text objects are a different interaction model (select-with-an-operator,
  not repeatedly-press-`<CR>`-to-grow). I didn't fake a replacement.
- The `autotage = { enable = true }` line in your old config wasn't a real config key even on
  the old branch (typo for `autotag`, and there was no such plugin installed) -- it never did
  anything, so it's simply gone now.

### 3. Small Neovim 0.12 API cleanups (not plugin-manager related)

None of these were breaking on 0.12 (they're deprecated-but-still-working), but since I was
already in these files:

- `lua/config/window_focus.lua`: `nvim_get_hl_by_name()` → `nvim_get_hl()` (note the field
  names also changed: `.background`/`.foreground` → `.bg`/`.fg`), and the two
  `nvim_buf_set_option(bufnr, 'winhighlight', ...)` calls → `vim.bo[bufnr].winhighlight = ...`.
- `lua/custom/plugins/utils.lua`, `templater.lua`, `bibtex_finder.lua`: same
  `nvim_buf_set_option()` → `vim.bo[bufnr][...]` swap.
- `lua/plugins/lsp.lua`: dropped the `nvim-0.10`-compatibility branch of `client_supports_method`
  since this config only targets 0.12+ now; it always calls `client:supports_method(...)`.

Confirmed **not** an issue on 0.12: your `vim.diagnostic.config({ signs = {...} })` usage in
`lsp.lua` was already the current API -- 0.12 removed `:sign-define`-based diagnostic signs
entirely, but you weren't using that.

## Pre-existing issues I found but did *not* fix (flagging, not touching, your call)

These were already dead/buggy in the lazy.nvim version -- I preserved the exact same behavior
rather than silently changing what the config does:

- `lua/plugins/quarto_marldown.lua`: `render-markdown.nvim`'s spec had **two** `dependencies =`
  keys (a plain Lua table literal, so the second silently overwrote the first) and a
  `heading = { border = true }` field sitting as a sibling of `opts = {}` instead of inside it
  -- lazy.nvim doesn't recognize `heading` as a spec key, so that setting never reached the
  plugin. It's commented in the new file if you want to actually enable it.
- `lua/plugins/multi_cursor.lua`: three keymaps (`<S-m`, `<S-d`, `<S-l`) are missing their
  closing `>`, so they're bound to a literal 5-character string, not Shift+m/d/l. Preserved
  as-is.
- `lua/plugins/onliner.lua`: `gitsigns.nvim` was installed but never had `.setup()` called on
  it either before or now.
