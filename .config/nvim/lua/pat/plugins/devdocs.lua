local wk = require('which-key')
local devdocs = require('nvim-devdocs')

local editor_width = vim.o.columns
local win_width = 100
devdocs.setup({
  dir_path = vim.fn.stdpath('data') .. '/devdocs',
  float_win = {
    anchor = 'NW',
    row = 1,
    col = editor_width - win_width + 1,
    relative = 'editor',
    height = 30,
    width = win_width,
    border = 'rounded',
  },
  wrap = true,
  previewer_cmd = 'glow',
  cmd_args = { '-s', 'dark', '-w', '80' },
  picker_cmd = true,
  picker_cmd_args = { '-p' },
  ensure_installed = {
    'javascript',
    'typescript',
    'react',
    'react_router',
    'go',
    'rust',
  },
  after_open = function(bufnr)
    wk.register({
      ['<Esc>'] = { ':close<CR>', 'Close DevDocs floating window' },
      q = { ':close<CR>', 'Close DevDocs floating window' },
    }, { buffer = bufnr })
  end,
})

wk.register({
  ['<leader><leader>?'] = { ':DevdocsOpenFloat<CR>', 'Open DevDocs' },
})
