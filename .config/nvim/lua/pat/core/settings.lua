-----------------------------------------------------------
-- General Neovim settings and configuration
-----------------------------------------------------------

-- Default options are not included
--- See: https://neovim.io/doc/user/vim_diff.html
--- [2] Defaults - *nvim-defaults*

-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local cmd = vim.cmd -- Execute Vim commands
local exec = vim.api.nvim_exec -- Execute Vimscript
local g = vim.g -- Global variables
local opt = vim.opt -- Set options (global/buffer/windows-scoped)
--local fn = vim.fn       				    -- Call Vim functions

-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.mouse = 'a' -- Enable mouse support
opt.clipboard = 'unnamedplus' -- Copy/paste to system clipboard
opt.swapfile = false -- Don't use swapfile
opt.completeopt = 'menuone,noselect' -- Autocomplete options

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true -- Show line number
opt.relativenumber = true -- Default to relative line numbers
opt.showmatch = true -- Highlight matching parenthesis
opt.foldmethod = 'marker' -- Enable folding (default 'foldmarker')
opt.colorcolumn = '80' -- Line lenght marker at 80 columns
opt.splitright = true -- Vertical split to the right
opt.splitbelow = true -- Orizontal split to the bottom
opt.ignorecase = true -- Ignore case letters when search
opt.smartcase = true -- Ignore lowercase for the whole pattern
opt.linebreak = true -- Wrap on word boundary
opt.termguicolors = true -- Enable 24-bit RGB colors
-- opt.laststatus = 3                    -- Single global statusline instead of per-buffer (will land in 0.7)

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
-- opt.expandtab = true                  -- Use spaces instead of tabs
-- opt.shiftwidth = 4                    -- Shift 4 spaces when tab
-- opt.tabstop = 4                       -- 1 tab == 4 spaces
-- opt.smartindent = true                -- Autoindent new lines

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true -- Enable background buffers
opt.history = 100 -- Remember N lines in history
opt.lazyredraw = true -- Faster scrolling
opt.synmaxcol = 240 -- Max column for syntax highlight
opt.updatetime = 400 -- ms to wait for trigger 'document_highlight'

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------

-- Disable nvim intro
opt.shortmess:append('sI')

-- Disable builtins plugins
local disabled_built_ins = {
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'gzip',
  'zip',
  'zipPlugin',
  'tar',
  'tarPlugin',
  'getscript',
  'getscriptPlugin',
  'vimball',
  'vimballPlugin',
  '2html_plugin',
  'logipat',
  'rrhelper',
  'spellfile_plugin',
  'matchit',
}

for _, plugin in pairs(disabled_built_ins) do
  g['loaded_' .. plugin] = 1
end

-----------------------------------------------------------
-- Diagnostic Styles
-----------------------------------------------------------
cmd([[
  sign define DiagnosticSignError text=│ texthl=DiagnosticSignError linehl= numhl=
  sign define DiagnosticSignWarn  text=│ texthl=DiagnosticSignWarn linehl= numhl=
  sign define DiagnosticSignInfo  text=│ texthl=DiagnosticSignInfo linehl= numhl=
  sign define DiagnosticSignHint  text=│ texthl=DiagnosticSignHint linehl= numhl=
]])

-----------------------------------------------------------
-- Autocommands
-----------------------------------------------------------

-- Remove whitespace on save
cmd([[au BufWritePre * :%s/\s\+$//e]])

-- Highlight on yank
exec(
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=800}
  augroup end
]],
  false
)

-- Don't auto commenting new lines
cmd([[au BufEnter * set fo-=c fo-=r fo-=o]])

-- Remove line lenght marker for selected filetypes
cmd([[autocmd FileType text,markdown,html,xhtml,javascript setlocal cc=0]])

-- -- 2 spaces for selected filetypes
-- cmd [[
--   autocmd FileType xml,html,xhtml,css,scss,json,javascript,javascriptreact,typescript,typescriptreact,lua,yaml setlocal shiftwidth=2 tabstop=2
-- ]]
-- -- 8 spaces for golang
-- cmd [[
--   autocmd FileType go setlocal shiftwidth=8 tabstop=8
-- ]]

-- easy exits
cmd([[
  autocmd FileType help nmap <buffer> q :q<CR>
  autocmd FileType list nmap <buffer> q :q<CR>
]])

-----------------------------------------------------------
-- Terminal
-----------------------------------------------------------

-- Open a terminal pane on the right using :Term
cmd([[command Term :botright vsplit term://$SHELL]])

-- Terminal visual tweaks:
--- enter insert mode when switching to terminal
--- close terminal buffer on process exit
cmd([[
    autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
    autocmd TermOpen * startinsert
    autocmd BufLeave term://* stopinsert
]])
