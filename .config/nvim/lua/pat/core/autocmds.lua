local cmd = vim.cmd

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

local searchGroup = vim.api.nvim_create_augroup('ClearHlAfterSearch', { clear = true })
local searchCmd = {
  callback = vim.schedule_wrap(function()
    vim.cmd('nohlsearch')
  end),
  desc = 'Set :nohlsearch when done searching',
  group = searchGroup,
}
-- vim.api.nvim_create_autocmd('CmdLineEnter', searchCmd)
vim.api.nvim_create_autocmd('ModeChanged', searchCmd)
-- vim.api.nvim_create_autocmd('InsertEnter', searchCmd)

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

-- Fix "<leader>xx" shortcut for closing Trouble
local troubleGroup = vim.api.nvim_create_augroup('TroubleWindow', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'Trouble',
  command = 'nmap <silent> <leader>xx :TroubleClose<CR>',
  group = troubleGroup,
})

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
  pattern = 'help,list,fugitiveblame,tsplayground,option-window',
  command = 'nmap <buffer> q :q<CR>',
})

-----------------------------------------------------------
-- Terminal
-----------------------------------------------------------

-- Open a terminal pane on the right using :Term
vim.api.nvim_create_user_command('Term', 'botright vsplit term://$SHELL', { force = true })

-- https://blog.ezeanyinabia.com/integrating-tuis-into-neovim/
local function startinsert()
  vim.schedule(function()
    vim.cmd('startinsert')
  end)
end
vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Enter insert mode when switching to terminal',
  callback = function(cmd_args)
    startinsert()
    vim.cmd('setlocal listchars = nonumber norelativenumber nocursorline')

    -- Thereafter, any `BufEnter` events into this buffer should also trigger insert mode
    vim.api.nvim_create_autocmd('BufEnter', {
      buffer = cmd_args.buf,
      callback = function()
        startinsert()
        -- When displaying an existing terminal buffer in a different window,
        -- its contents are still drawn as if they were in the original window
        -- the buffer was created in. Redrawing fixes that
        vim.cmd('redraw')
      end,
    })
  end,
})

vim.api.nvim_create_autocmd('BufLeave', {
  desc = 'Close terminal buffer on process exit',
  pattern = 'term://*',
  command = 'stopinsert',
})
