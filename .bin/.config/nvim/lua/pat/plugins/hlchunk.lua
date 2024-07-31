-----------------------------------------------------------
-- HLChunk configuration file
-----------------------------------------------------------

-- Plugin: HLChunk
-- url: https://github.com/shellRaining/hlchunk.nvim

local colors = require('pat.core/colors').tokyonight
local excluded_filetypes = {
  alpha = true,
  dashboard = true,
  help = true,
  glow = true,
  git = true,
  guihua = true,
  lazy = true,
  markdown = true,
  outline = true,
  text = true,
  terminal = true,
  lspinfo = true,
  packer = true,
}

require('hlchunk').setup({
  chunk = {
    enable = true,
    exclude_filetypes = excluded_filetypes,
    textobject = 'iC',

    style = {
      { fg = colors.pink },
    },
    delay = 150,
    duration = 100,
  },
  indent = {
    enable = true,
    exclude_filetypes = excluded_filetypes,
    style = {
      { fg = colors.fg_gutter },
    },
  },
  line_num = {
    enable = true,
    style = colors.comment,
  },
  blank = { enable = false },
})
