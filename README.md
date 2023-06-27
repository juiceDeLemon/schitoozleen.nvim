# schitoozleen.nvim

Schitoozleen.nvim (/shituuzleen/) is an absolutely opinionated and minimum neovim statusline written in lua.

1. [Introduction](#introduction)
2. [Features](#features)
3. ["Screenshots"](#screenshots)
4. [Installation](#installation)
5. [Credits](#credits)

## Introduction
None of other plugins satisfy me. Not opinionated, not you-can-customise-half-of-the-statusline-with-presets, and not statusline-libraries. This plugin exists because ~~I want something my cv~~ I built my own statusline, but am too lazy to set an autocommand to lazyload it and want to share it with others.

This statusline is minimal (no colours, compact texts and minimal) and has no customisability. If you want any features, build a statusline yourself. Tabline is default because it is a tabline, not a bufferline and the default is good enough. If you want to view/switch buffers, use telescope. There is also no navic or stuff like that because I feel like it is useless/is just eye-candy.

## Features
- Mode
- Git status
- Diagnostics
- Harpoon
- Dap
- File size
- Encoding (won't show up if none/utf-8)
- File type
- Ruler

## "Screenshots"
Showing: mode, git, diagnostics, harpoon, file, and stuff above

```
[ඞ n][+3~1][W3H1][harpoon]            directory/file.rs          [5.0k][rust][170/172: 1 Bot]
```

Showing: dap, file flags, venv

```
[ඞ n][Stopped at line 16]        directory/foo.py         (name-of-vev)[3.1k][python][320/492: 15 65%]
```

## Installation

lazy.nvim:
```lua
{
    "juiceDeLemon/schitoozleen.nvim",
    config = true,
    dependencies = { -- if you don't use any of these plugins then comment it out
        "lewis6991/gitsigns.nvim",
        "mfussenegger/nvim-dap",
        "ThePrimeagen/harpoon",
    },
    event = "VeryLazy",
},
```

## Credits

Most of components: The cookbook in [heirline.nvim](https://github.com/rebelot/heirline.nvim/)

The sourcecode of [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)

nvim/lua/plugins/lualine.lua of [@chrisgrieser's config](https://github.com/chrisgrieser/.config)
