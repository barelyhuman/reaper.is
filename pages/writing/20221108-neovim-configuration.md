---
title: NeoVIM Configuration
date: 08/11/2022
published: true
---

Yeah, no one asked for this,

Just a couple of steps to reproduce my minimal shell configuration and neovim configuration.

Also, [mvllow](https://mellow.dev) and I use the same keymaps so you might want to go through the `lil-editing` and other `lilvim` files to see if you
need to change the keymaps

1. Install Neovim and iTerm2

```sh
brew install neovim --HEAD
brew install --cask iterm2
```

2. Change the iTerm2 to have the background color as the hex `#111111`
3. Clone `https://github.com/mvllow/lilvim.git` and copy the `.config/nvim` folder from the repository to `~/.config/nvim`
4. Change the colors in `~/.config/nvim/color/un.lua` to match the following in the `dark` variant

```lua
        error = "#eb6f92",
        warn = "#f6c177",
        hint = "#9ccfd8",
        info = "#c4a7e7",
        accent = "#ffffff",
        on_accent = "#191724",
        b_low = "#111111",
        b_med = "#181819",
        b_high = "#222222",
        f_low = "#959595",
        f_med = "#aaaaaa",
        f_high = "#bebebe",
```

5. Now go to `~/.confing/nvim/lua/lil-ui` and comment out / remove the `rose-pine` `use` setup altogether
6. and in `~/.config/nvim/init.lua` add the following statement

```lua
vim.cmd("colorscheme un")
```

7. Hopefully you saved all the changes and now run `:PackerSync` , close the editor and open it up again, wait for Treesitter to install all it's
   dependencies and close the editor and open it up again.

> **Note**: You could try to use the `:%` command to reload config but it hardly ever works with `packer` so just quit and open

8. Run a final `:PackerCompile` and `:PackerSync` and you are done.
