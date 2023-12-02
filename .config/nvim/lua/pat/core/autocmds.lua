local cmd = vim.cmd
local Job = require('plenary.job')
local Popup = require('nui.popup')
local event = require('nui.utils.autocmd').event

-----------------------------------------------------------
-- Autocommands
-----------------------------------------------------------

-- Remove whitespace on save
cmd([[au BufWritePre * :%s/\s\+$//e]])

local fugitiveCommitMsgPopupLayoutProps = {
  relative = 'win',
  anchor = 'NE',
  position = {
    row = '3%',
    col = '100%',
  },
  size = {
    width = 40,
    height = 8,
  },
}

local fugitiveCommitMsgPopup = Popup(vim.tbl_extend('keep', fugitiveCommitMsgPopupLayoutProps, {
  enter = false,
  focusable = false,
  border = { style = 'rounded', text = {} },
  win_options = {
    winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
  },
}))
local function updateFugitiveCommitMsgPopup()
  local fugitiveLine = vim.api.nvim_get_current_line()
  local hiGroup = vim.inspect_pos().syntax[2].hl_group
  local commitHash = string.match(fugitiveLine, '[%x]+')
  if commitHash ~= '' then
    Job
        :new({
          command = 'git',
          args = { 'log', '-1', '--pretty=format:%H%n%an %ar%n%n%B', commitHash },
          cwd = vim.fn.getcwd(),
          on_exit = function(j, return_val)
            if return_val == 0 then
              vim.schedule(function()
                fugitiveCommitMsgPopup.border:set_text('bottom', '[Commit ' .. commitHash .. ']', 'center')
                fugitiveCommitMsgPopup.border:set_highlight(hiGroup or 'FloatBorder')
                vim.api.nvim_buf_set_lines(fugitiveCommitMsgPopup.bufnr, 0, -1, false, j:result())
              end)
            end
          end,
        })
        :sync()
  end
end
local fugitiveCommitMsg = vim.api.nvim_create_augroup('PAT_FugitiveCommitMsg', { clear = true })
vim.api.nvim_create_autocmd('BufAdd', {
  group = fugitiveCommitMsg,
  pattern = '*.fugitiveblame',
  callback = function()
    fugitiveCommitMsgPopup:mount()
  end,
})
vim.api.nvim_create_autocmd('BufEnter', {
  group = fugitiveCommitMsg,
  pattern = '*.fugitiveblame',
  callback = function()
    fugitiveCommitMsgPopup:show()
    updateFugitiveCommitMsgPopup()
  end,
})
vim.api.nvim_create_autocmd('BufLeave', {
  group = fugitiveCommitMsg,
  pattern = '*.fugitiveblame',
  callback = function()
    fugitiveCommitMsgPopup:hide()
  end,
})
vim.api.nvim_create_autocmd('BufDelete', {
  group = fugitiveCommitMsg,
  pattern = '*.fugitiveblame',
  callback = function()
    fugitiveCommitMsgPopup:unmount()
  end,
})
vim.api.nvim_create_autocmd('CursorMoved', {
  group = fugitiveCommitMsg,
  pattern = '*.fugitiveblame',
  callback = updateFugitiveCommitMsgPopup,
})

local autoFormatGroup = vim.api.nvim_create_augroup('ToggleFormatOnSaveGroup', { clear = false })
vim.api.nvim_create_autocmd('User', {
  pattern = 'ToggleFormatOnSave',
  command = 'let g:PAT_format_on_save=!g:PAT_format_on_save',
  group = autoFormatGroup,
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
  desc = 'Set :nohlsearch when done searching',
  command = 'nohlsearch',
  group = searchGroup,
}
-- vim.api.nvim_create_autocmd('CursorMoved', searchCmd)
vim.api.nvim_create_autocmd('InsertEnter', searchCmd)

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

--[[ vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Toggle TS Rainbow to prevent colorscheme breakages',
  pattern = { '*.json', '*.js', '*.jsx', '*.ts', '*.tsx' },
  command = 'TSDisable rainbow | TSEnable rainbow',
})
vim.api.nvim_create_autocmd('BufWritePost', {
  desc = 'Toggle TS Rainbow to prevent colorscheme breakages',
  pattern = { '*.json', '*.js', '*.jsx', '*.ts', '*.tsx' },
  command = 'TSDisable rainbow | TSEnable rainbow',
}) ]]

-- Fix "<leader>xx" shortcut for closing Trouble
local troubleGroup = vim.api.nvim_create_augroup('TroubleWindow', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'Trouble',
  command = 'nmap <silent> <leader>xx :TroubleToggle<CR>',
  group = troubleGroup,
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
  pattern = 'help,list,fugitiveblame,tsplayground,option-window',
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
