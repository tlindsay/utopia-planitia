local cmd = vim.cmd
local wk = require('which-key')
local utils = require('pat.utils')

-----------------------------------------------------------
-- Autocommands
-----------------------------------------------------------

-- Remove whitespace on save
cmd([[au BufWritePre * :%s/\s\+$//e]])

local yankGroup = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 800 })
  end,
  group = yankGroup,
})

vim.api.nvim_create_autocmd('BufEnter', {
  desc = "Don't auto comment new lines",
  command = 'set fo-=c fo-=r fo-=o',
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Remove line length marker for selected filetypes',
  pattern = 'text,markdown,html,xhtml,javascript',
  command = 'setlocal cc=0',
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Use builtin syntax-highlighting for selected filetypes',
  pattern = 'help,text',
  command = 'setlocal syntax=on',
})

local rustGroup = vim.api.nvim_create_augroup('RustPlayground', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = rustGroup,
  pattern = 'rust',
  callback = function(opts)
    wk.register({
      ['<leader>rP'] = {
        function()
          utils.rust_playground({ open = true })
        end,
        'Open current file as Rust Playground',
      },
      ['<leader>rp'] = {
        function()
          utils.rust_playground({ copy = true })
          print('Rust Playground URL copied to clipboard!')
        end,
        'Copy URL to current file as Rust Playground',
      },
    }, { buffer = opts.buf })
    return true
  end,
})

-- This may be causing problems after adding nvim-ufo
--[[ -- Open folds!
local foldGroup = vim.api.nvim_create_augroup('AutoUnfold', { clear = true })
vim.api.nvim_create_autocmd(
  'BufWinEnter',
  { desc = 'Automatically unfold', pattern = '*', command = 'normal! zR', group = foldGroup }
) ]]

-- -- 2 spaces for selected filetypes
-- cmd [[
--   autocmd FileType xml,html,xhtml,css,scss,json,javascript,javascriptreact,typescript,typescriptreact,lua,yaml setlocal shiftwidth=2 tabstop=2
-- ]]
-- -- 8 spaces for golang
-- cmd [[
--   autocmd FileType go setlocal shiftwidth=8 tabstop=8
-- ]]

-- easy exits
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Easy exits',
  pattern = 'help,list,fugitiveblame,tsplayground',
  command = 'nmap <buffer> q :q<CR>',
})

-----------------------------------------------------------
-- Terminal
-----------------------------------------------------------

-- Open a terminal pane on the right using :Term
vim.api.nvim_create_user_command('Term', 'botright vsplit term://$SHELL', { force = true })

vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Terminal visual tweaks',
  command = 'setlocal listchars = nonumber norelativenumber nocursorline',
})
vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Enter insert mode when switching to terminal',
  command = 'startinsert',
})
vim.api.nvim_create_autocmd('BufLeave', {
  desc = 'Close terminal buffer on process exit',
  pattern = 'term://*',
  command = 'stopinsert',
})

-----------------------------------------------------------
-- Auto-sourcing (Currently not working)
-----------------------------------------------------------

local packerGroup = vim.api.nvim_create_augroup('packer_user_config', {})
vim.api.nvim_create_autocmd('BufRead', {
  pattern = '~/.config/nvim/**/*.lua',
  command = 'echom blah',
})
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '~/.config/nvim/**/*.lua',
  command = 'echom "YAYAYAYAYA"',
  group = packerGroup,
})
