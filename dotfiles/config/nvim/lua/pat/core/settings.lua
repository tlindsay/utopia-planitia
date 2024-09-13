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
local g = vim.g -- Global variables
local opt = vim.opt -- Set options (global/buffer/windows-scoped)

-----------------------------------------------------------
-- Custom
-----------------------------------------------------------
g.tmux_navigator_no_mappings = 1
g.tmux_navigator_no_wrap = 1
g.sleuth_go_tabstop = 2
g.sleuth_go_shiftwidth = 2

-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.mouse = 'a' -- Enable mouse support
opt.clipboard = 'unnamedplus' -- Copy/paste to system clipboard
opt.swapfile = false -- Don't use swapfile
opt.completeopt = 'menuone,noselect' -- Autocomplete options
g.sessionoptions = 'curdir,options,skiprtp,tabpages,winsize'

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true -- Show line number
opt.relativenumber = true -- Default to relative line numbers
opt.showmatch = true -- Highlight matching parenthesis
-- opt.foldmethod = 'marker' -- Enable folding (default 'foldmarker')
opt.colorcolumn = '80' -- Line length marker at 80 columns
opt.splitright = true -- Vertical split to the right
opt.splitbelow = true -- Orizontal split to the bottom
opt.ignorecase = true -- Ignore case letters when search
opt.smartcase = true -- Ignore lowercase for the whole pattern
opt.linebreak = true -- Wrap on word boundary
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.laststatus = 3 -- Single global statusline instead of per-buffer (will land in 0.7)
opt.cmdheight = 0 -- No dedicated cmd line
opt.cursorline = true
opt.termguicolors = true
opt.scrolloff = 5 -- Keep 5 lines of padding when scrolling

-- Treesitter overrides
opt.syntax = 'off'
opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
-- opt.expandtab = true                  -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Shift 4 spaces when tab
opt.tabstop = 2 -- 1 tab == 4 spaces
opt.smartindent = true -- Autoindent new lines

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true -- Enable background buffers
opt.history = 100 -- Remember N lines in history
opt.lazyredraw = false -- Faster scrolling
opt.synmaxcol = 240 -- Max column for syntax highlight
opt.updatetime = 400 -- ms to wait for trigger 'document_highlight'

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------

-- Disable nvim intro
opt.shortmess:append('sI')
-- opt.shortmess = 'fiTsoOIltFxnw'
-- fiTsoOIltFxn

-- Disable builtins plugins
local disabled_built_ins = {
  -- 'netrw',
  -- 'netrwPlugin',
  -- 'netrwSettings',
  -- 'netrwFileHandlers',
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
opt.signcolumn = 'auto:1-3'
-- cmd([[
--   sign define DiagnosticSignError text=┃ texthl=DiagnosticSignError linehl= numhl=
--   sign define DiagnosticSignWarn  text=┃ texthl=DiagnosticSignWarn linehl= numhl=
--   sign define DiagnosticSignInfo  text=┃ texthl=DiagnosticSignInfo linehl= numhl=
--   sign define DiagnosticSignHint  text=┃ texthl=DiagnosticSignHint linehl= numhl=
-- ]])
-- local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
cmd([[
  sign define DiagnosticSignError text=󰅙  texthl=DiagnosticSignError linehl= numhl=
  sign define DiagnosticSignWarn  text=󰀨  texthl=DiagnosticSignWarn  linehl= numhl=
  sign define DiagnosticSignInfo  text=󰋼  texthl=DiagnosticSignInfo  linehl= numhl=
  sign define DiagnosticSignHint  text=󰌵 texthl=DiagnosticSignHint  linehl= numhl=
]])
