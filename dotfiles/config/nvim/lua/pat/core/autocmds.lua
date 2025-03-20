-----------------------------------------------------------
-- Autocommands
-- Event Type overview: https://gist.github.com/dtr2300/2f867c2b6c051e946ef23f92bd9d1180
-----------------------------------------------------------

local focusGroup = vim.api.nvim_create_augroup('PatFocusEvents', { clear = true })
vim.api.nvim_create_autocmd('FocusLost', {
  command = 'set norelativenumber',
  group = focusGroup,
})
vim.api.nvim_create_autocmd('FocusGained', {
  command = 'set relativenumber',
  group = focusGroup,
})

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
-- vim.cmd [[
--   autocmd FileType xml,html,xhtml,css,scss,json,javascript,javascriptreact,typescript,typescriptreact,lua,yaml setlocal shiftwidth=2 tabstop=2
-- ]]
-- -- 8 spaces for golang
-- vim.cmd [[
--   autocmd FileType go setlocal shiftwidth=8 tabstop=8
-- ]]

-- easy exits
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Easy exits',
  callback = function(evt)
    local filetypes = { 'godoc', 'list', 'fugitiveblame', 'tsplayground', 'option-window' }
    local buftypes = { 'help' }
    local bt = vim.api.nvim_get_option_value('buftype', { buf = evt.buf })
    local ft = vim.api.nvim_get_option_value('filetype', { buf = evt.buf })

    if vim.list_contains(filetypes, ft) or vim.list_contains(buftypes, bt) then
      vim.cmd([[ nmap <buffer> q :q<CR> ]])
    end
  end,
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
    vim.cmd('setlocal listchars = nonumber norelativenumber nocursorline')
    if not vim.api.nvim_get_option_value('modifiable', { buf = cmd_args.buf }) then
      return
    end
    startinsert()

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
