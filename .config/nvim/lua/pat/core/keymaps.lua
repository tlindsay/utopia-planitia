local wk = require('which-key')
local fns = require('pat.core/functions')
-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(target_mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(target_mode, lhs, rhs, options)
  -- wk.register({[lhs] = rhs}, opts)
end

-- Change leader to a comma
vim.g.mapleader = ','

wk.register({
  ['?'] = { ':WhichKey ', 'Show WhichKey' },
  ['<leader><leader>h'] = {
    function()
      fns.getHlGroup()
    end,
    'Get Highlight group under cursor',
  },
}, { noremap = false, silent = false })
wk.register({
  ['<leader>'] = {
    ['.'] = { ':set relativenumber!<CR>', 'Toggle Relative Line Numbers' },
    ['rv'] = { _G.reload_config, 'Reload Vim config' },
    ['<space>'] = { ':set wrap!<CR>', 'Toggle line wrapping' },
    ['<Del>'] = { ':bufdo bwipeout! | Alpha<CR>', 'Close all buffers' },
    x = { ':tabclose<CR>', 'Close window' },
    S = { ':mksession!<CR>', 'Save session' },
    ['<leader>'] = {
      ['.'] = { ':tabdo windo set relativenumber!<CR>', 'Toggle Relative Line Numbers (all buffers)' },
      f = {
        function()
          local curr = vim.api.nvim_get_var('PAT_format_on_save')
          vim.api.nvim_set_var('PAT_format_on_save', not curr)
        end,
        'Toggle format-on-save',
      },
    },
  },
})

-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------

-- Prevent segfaults
map('', '<C-c>', '<Esc>')

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
-- map('n', '<C-h>', ':TmuxNavigateLeft<CR>')
-- map('n', '<C-j>', ':TmuxNavigateDown<CR>')
-- map('n', '<C-k>', ':TmuxNavigateUp<CR>')
-- map('n', '<C-l>', ':TmuxNavigateRight<CR>')

-- map('n', '<C-h>', '<C-w>h')
-- map('n', '<C-j>', '<C-w>j')
-- map('n', '<C-k>', '<C-w>k')
-- map('n', '<C-l>', '<C-w>l')

map('n', 'K', ':m .-2<CR>')
map('v', 'K', ':m -2<cr>gv=gv')
map('v', 'J', ":m '>+<cr>gv=gv")
map('n', 'J', ':m .+1<CR>')

-- Pane management
-- map('n', '<A-h>', ':SmartResizeLeft<CR>')
-- map('n', '<A-j>', ':SmartResizeDown<CR>')
-- map('n', '<A-k>', ':SmartResizeUp<CR>')
-- map('n', '<A-l>', ':SmartResizeRight<CR>')
map('n', '<C-w>-', ':new<CR>')
map('n', '<C-w>\\', ':vnew<CR>')
map('n', '<C-w>,', function()
  local input = vim.fn.input('Tab name? ')

  vim.api.nvim_tabpage_set_var(0, 'custom_tab_name', input)
end)

-- Close all windows and exit from Neovim with <leader> and q
map('n', '<leader>q', ':q<CR>')
map('n', '<leader>Q', ':q!<CR>')

-----------------------------------------------------------
-- Applications and Plugins shortcuts
-----------------------------------------------------------

-- Telescope
map('n', '&', ':Telescope grep_string<CR>')

-- Terminal mappings
map('n', '<C-t>', ':Term<CR>', { noremap = true }) -- open
map('t', '<Esc>', '<C-\\><C-n>') -- exit
