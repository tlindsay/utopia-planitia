local tokyo = require('pat.core/colors').tokyonight
local colors = {
  black        = tokyo.black,
  white        = tokyo.white,
  red          = tokyo.red1,
  green        = tokyo.green,
  blue         = tokyo.blue5,
  yellow       = tokyo.yellow,
  gray         = tokyo.bg,
  darkgray     = tokyo.bg_dark,
  lightgray    = tokyo.dark3,
  inactivegray = tokyo.dark5,
  pink	       = tokyo.purple,
  purple       = tokyo.magenta,
}
local moon = {
  normal = {
    a = {bg = colors.blue, fg = colors.black},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = tokyo.black, fg = colors.white},
    z = {bg = colors.purple, fg = colors.black}
  },
  insert = {
    a = {bg = colors.green, fg = colors.black},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = tokyo.black, fg = colors.white}
  },
  visual = {
    a = {bg = colors.yellow, fg = colors.black},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = tokyo.black, fg = colors.white}
  },
  replace = {
    a = {bg = colors.red, fg = colors.black},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = tokyo.bg, fg = colors.white}
  },
  command = {
    a = {bg = colors.green, fg = colors.black},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = tokyo.bg, fg = colors.black}
  },
  inactive = {
    a = {bg = tokyo.comment, fg = colors.gray},
    b = {bg = tokyo.comment, fg = colors.gray},
    c = {bg = tokyo.comment, fg = colors.gray}
  }
}

return moon
