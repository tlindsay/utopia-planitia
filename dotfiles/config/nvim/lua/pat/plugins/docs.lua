local wk = require('which-key')
local devdocs = require('nvim-devdocs')
local godoc = require('godoc')

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
    'lua-5.1',
    'go',
    'nix',
    'rust',
  },
  after_open = function(bufnr)
    wk.add({
      { '<Esc>', ':close<CR>', desc = 'Close DevDocs floating window', buffer = bufnr },
      { 'q',     ':close<CR>', desc = 'Close DevDocs floating window', buffer = bufnr },
    })
  end,
})

godoc.setup({
  window = { type = "vsplit" },
  picker = { type = "telescope" },
})

wk.add({
  {
    '<leader><leader>?',
    function()
      local bufnr = vim.api.nvim_get_current_buf()
      local ft = vim.api.nvim_get_option_value('ft', { buf = vim.api.nvim_get_current_buf() })
      if ft == 'go' then
        vim.api.nvim_command('GoDoc')
      else
        vim.api.nvim_command('DevdocsOpenFloat')
      end
    end,
    desc = function()
      local bufnr = vim.api.nvim_get_current_buf()
      local ft = vim.api.nvim_get_option_value('ft', { buf = vim.api.nvim_get_current_buf() })
      if ft == 'go' then
        return 'Open Go docs'
      else
        return 'Open DevDocs'
      end
    end,
  },
})
