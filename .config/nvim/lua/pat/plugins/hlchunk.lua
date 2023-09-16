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
  markdown = true,
  text = true,
  terminal = true,
  lspinfo = true,
  packer = true,
}

require('hlchunk').setup({
  chunk = {
    exclude_filetypes = excluded_filetypes,
    style = { { fg = colors.pink } },
  },
  indent = {
    exclude_filetypes = excluded_filetypes,
    style = {
      { fg = colors.fg_gutter },
    },
  },
  line_num = {
    style = colors.comment,
  },
  blank = { enable = false },
})
