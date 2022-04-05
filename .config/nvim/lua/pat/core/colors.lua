-----------------------------------------------------------
-- Color schemes configuration file
-----------------------------------------------------------

local tokyoColors = require("tokyonight.colors").setup()

vim.g.tokyonight_colors = {
  ["border"] = tokyoColors.magenta,
}
-- Load nvim color scheme:
vim.g.tokyonight_style = "storm"
vim.cmd([[colorscheme tokyonight]])

-- Import color scheme for other components with:
--- require('colors').colorscheme_name

local M = {}

-- Theme: TokyoNight
--- See: https://github.com/folke/tokyonight.nvim/blob/main/lua/tokyonight/colors.lua
M.tokyonight = tokyoColors
M.tokyonight.pink = tokyoColors.magenta

-- Theme: OneDark
--- See: https://github.com/navarasu/onedark.nvim/blob/master/lua/onedark/colors.lua
M.onedark = {
  bg = "#282c34",
  fg = "#abb2bf",
  pink = "#c678dd",
  green = "#98c379",
  cyan = "#56b6c2",
  yellow = "#e5c07b",
  orange = "#d19a66",
  purple = "#8a3fa0",
  red = "#e86671",
}

-- Theme: Monokai (classic)
--- See: https://github.com/tanvirtin/monokai.nvim/blob/master/lua/monokai.lua
M.monokai = {
  bg = "#202328", --default: #272a30
  fg = "#f8f8f0",
  pink = "#f92672",
  green = "#a6e22e",
  cyan = "#66d9ef",
  yellow = "#e6db74",
  orange = "#fd971f",
  purple = "#ae81ff",
  red = "#e95678",
}

-- Theme: Rosé Pine (main)
--- See: https://github.com/rose-pine/neovim/blob/main/lua/rose-pine/palette.lua
--- color names are adapted to the format above
M.rose_pine = {
  bg = "#111019", --default: #191724
  fg = "#e0def4",
  gray = "#908caa",
  pink = "#eb6f92",
  green = "#9ccfd8",
  cyan = "#31748f",
  yellow = "#f6c177",
  orange = "#2a2837",
  purple = "#c4a7e7",
  red = "#ebbcba",
}

-- vim.api.nvim_set_hl(0, 'WinSeparator', { fg = require('tokyonight.colors').purple, bg = 'None'})

return M
