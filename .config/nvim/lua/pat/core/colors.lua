-----------------------------------------------------------
-- Color schemes configuration file
-----------------------------------------------------------

local tokyonight = require('tokyonight')
local hl = R('local-highlight')

local M = {}

-- Theme: TokyoNight
--- See: https://github.com/folke/tokyonight.nvim/blob/main/lua/tokyonight/colors.lua

local theme = 'moon'
tokyonight.setup({
  style = theme,
  dim_inactive = true,

  on_colors = function(colors)
    colors.pink = colors.purple
    M.tokyonight = colors
  end,

  on_highlights = function(highlights, colors)
    highlights.WinSeparator = {
      fg = colors.purple, --[[ , bg = 'None' ]]
    }
    highlights.DiagnosticWarn = { fg = colors.yellow, underline = false }
    highlights['AlphaHeader'] = {
      fg = colors.blue, --[[ , bg = 'None' ]]
    }
    highlights['AlphaFooter'] = {
      fg = colors.yellow, --[[ , bg = 'None' ]]
    }
  end,
})

-- Load nvim color scheme:
vim.cmd([[colorscheme tokyonight]])

hl.setup({ hlgroup = 'CursorLine' })

return M
