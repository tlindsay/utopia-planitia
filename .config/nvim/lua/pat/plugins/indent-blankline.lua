-----------------------------------------------------------
-- Indent line configuration file
-----------------------------------------------------------

-- Plugin: indent-blankline
-- url: https://github.com/lukas-reineke/indent-blankline.nvim

require('indent_blankline').setup({
  char = '▏',
  show_current_context = true,
  show_first_indent_level = false,
  use_treesitter = true,
  filetype_exclude = {
    'dashboard',
    'glow',
    'git',
    'help',
    'markdown',
    'text',
    'terminal',
    'lspinfo',
    'packer',
  },
  buftype_exclude = {
    'terminal',
    'nofile',
  },
})
