local wk = require 'which-key'
-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(target_mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(target_mode, lhs, rhs, options)
  -- wk.register({[lhs] = rhs}, opts)
end

-- Change leader to a comma
vim.g.mapleader = ','

wk.register({['?']={':WhichKey ', 'Show WhichKey'}}, { noremap = false, silent = false })
wk.register({
  ['<leader>'] = {
    ['.'] = {':set relativenumber!<CR>', 'Toggle Relative Line Numbers'},
    X = {':tabclose<CR>', 'Close window'},
  }
})

-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------

-- Clear search highlighting with <leader> and c
map('n', '<leader>h', ':nohl<CR>')

-- Don't use arrow keys
map('', '<up>', '<nop>')
map('', '<down>', '<nop>')
map('', '<left>', '<nop>')
map('', '<right>', '<nop>')

-- Sane navigation
map('', 'k', 'gk')
map('', 'j', 'gj')

-- Fast saving with <leader> and s
map('n', '<leader>w', ':w<CR>')
map('n', '<leader>W', ':wall<CR>')
map('n', '<leader>e', ':e %<CR>')
map('n', '<leader>E', ':e! %<CR>')

-- Move around splits using Ctrl + {h,j,k,l}
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

map('n', 'K', ':m .-2<CR>')
map('n', 'J', ':m .+1<CR>')
map('v', 'K', ':m <-2<CR>gv=gv')
map('v', 'J', ':m >+1<CR>gv=gv')

-- Pane management
map('n', '<A-h>', ':SmartResizeLeft<CR>')
map('n', '<A-j>', ':SmartResizeDown<CR>')
map('n', '<A-k>', ':SmartResizeUp<CR>')
map('n', '<A-l>', ':SmartResizeRight<CR>')
map('n', '<C-w>-', ':new<CR>')
map('n', '<C-w>\\', ':vnew<CR>')

-- Close all windows and exit from Neovim with <leader> and q
map('n', '<leader>q', ':q<CR>')
map('n', '<leader>Q', ':qall!<CR>')

-----------------------------------------------------------
-- Applications and Plugins shortcuts
-----------------------------------------------------------

-- Telescope
map('n', '<C-p>', ':Telescope find_files<CR>')
map('n', '&', ':Telescope grep_string<CR>')

-- Terminal mappings
map('n', '<C-t>', ':Term<CR>', { noremap = true })  -- open
map('t', '<Esc>', '<C-\\><C-n>')                    -- exit

-- NvimTree
map('n', '<C-n>', ':NvimTreeToggle<CR>')            -- open/close
map('n', '<leader>r', ':NvimTreeRefresh<CR>')       -- refresh
map('n', '<leader>n', ':NvimTreeFindFile<CR>')      -- search file

-- Vista tag-viewer
map('n', '<leader><leader>v', ':Vista!!<CR>') -- open/close
