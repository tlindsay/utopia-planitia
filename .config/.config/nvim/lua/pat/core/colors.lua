-----------------------------------------------------------
-- Color schemes configuration file
-----------------------------------------------------------

local tokyonight = require('tokyonight')
local local_hl = require('local-highlight')

local M = {}

-- Theme: TokyoNight
--- See: https://github.com/folke/tokyonight.nvim/blob/main/lua/tokyonight/colors.lua

local theme = 'moon'
tokyonight.setup({
  style = theme,
  dim_inactive = true,

  styles = {
    sidebars = 'dark',
  },

  on_colors = function(colors)
    colors.pink = colors.purple
    M.tokyonight = colors
  end,

  on_highlights = function(highlights, colors)
    -- if theme == 'day' then
    --   highlights.Cursor = { bg = colors.fg_dark }
    -- end

    highlights.NormalSB = { bg = colors.bg_inactive }

    highlights['RainbowDelimiterGreen'] = {
      fg = colors.blue6, --[[ , bg = 'None' ]]
    }

    highlights.WinSeparator = {
      fg = colors.purple, --[[ , bg = 'None' ]]
      bold = true,
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

local_hl.setup({ hlgroup = 'CursorLine' })

return M
