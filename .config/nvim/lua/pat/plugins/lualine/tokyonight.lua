local colors = require('pat.core/colors').tokyonight
local theme = {
  black = colors.black,
  white = colors.white,
  red = colors.red1,
  green = colors.green,
  blue = colors.blue5,
  yellow = colors.yellow,
  gray = colors.bg,
  darkgray = colors.bg_dark,
  lightgray = colors.dark3,
  inactivegray = colors.dark5,
  pink = colors.purple,
  purple = colors.magenta,
}
local moon = {
  normal = {
    a = { bg = theme.blue, fg = theme.black },
    b = { bg = theme.lightgray, fg = theme.white },
    c = { bg = colors.black, fg = theme.white },
    z = { bg = theme.purple, fg = theme.black },
  },
  insert = {
    a = { bg = theme.green, fg = theme.black },
    b = { bg = theme.lightgray, fg = theme.white },
    c = { bg = colors.black, fg = theme.white },
  },
  visual = {
    a = { bg = theme.yellow, fg = theme.black },
    b = { bg = theme.lightgray, fg = theme.white },
    c = { bg = colors.black, fg = theme.white },
  },
  replace = {
    a = { bg = theme.red, fg = theme.black },
    b = { bg = theme.lightgray, fg = theme.white },
    c = { bg = colors.bg, fg = theme.white },
  },
  command = {
    a = { bg = theme.green, fg = theme.black },
    b = { bg = theme.lightgray, fg = theme.white },
    c = { bg = colors.bg, fg = theme.black },
  },
  inactive = {
    a = { bg = colors.comment, fg = theme.gray },
    b = { bg = colors.comment, fg = theme.gray },
    c = { bg = colors.comment, fg = theme.gray },
  },
}

return moon
