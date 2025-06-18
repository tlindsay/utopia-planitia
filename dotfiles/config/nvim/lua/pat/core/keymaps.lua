local wk = require('which-key')
local colors = require('pat.core/colors')
local utils = require('pat.utils')
local fns = require('pat.core/functions')
-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

-- Change leader to a comma
vim.g.mapleader = ','
vim.g.maplocalleader = ' '

wk.add({
  { '?', ':WhichKey ', desc = 'Show WhichKey' },
  { '<leader><leader>h', fns.getHlGroup, desc = 'Get Highlight group under cursor' },
  { '<A-S-Left>', ':tabm -1<CR>', desc = 'Move tab left' },
  { '<A-S-Right>', ':tabm +1<CR>', desc = 'Move tab right' },
  {
    group = 'Neovim',
    icon = { icon = '', color = colors.green },
    { '<leader>=', fns.scrollbindPanes, desc = 'Sync cursor line for open panes' },
    { '<leader>h', ':nohl<CR>', desc = 'Clear search highlight' },

    { '<leader>S', ':mksession!<CR>', desc = 'Save session' },
    { '<leader>w', ':w<CR>', desc = 'Write file' },
    { '<leader>W', ':w!<CR>', desc = 'Force write file' },
    { '<leader><leader>W', ':wall!<CR>', desc = 'Force write all open files' },
    { '<leader>e', ':e %<CR>', desc = 'Reload file from disk' },
    { '<leader>E', ':e! %<CR>', desc = 'Force reload file from disk' },

    { '<leader>q', ':q<CR>', desc = 'Close file (and quit)' },
    { '<leader>Q', ':q!<CR>', desc = 'Force close file (and quit)' },
    { '<leader><leader>Q', ':qall!<CR>', desc = 'Force quit Neovim' },

    { 'K', ':m .-2<CR>', desc = 'Move current line up' },
    { 'K', ':m -2<cr>gv=gv', desc = 'Move selected lines up', mode = 'v' },
    { 'J', ':m .+1<CR>', desc = 'Move current lines down' },
    { 'J', ":m '>+<cr>gv=gv", desc = 'Move selected lines down', mode = 'v' },
    { '<leader><space>', ':set wrap!<CR>', desc = 'Toggle line wrapping' },
    {
      '<leader><leader>.',
      ':tabdo windo set relativenumber!<CR>',
      desc = 'Toggle Relative Line Numbers (all buffers)',
    },

    -- Pane management
    { '<leader>x', ':tabclose<CR>', desc = 'Close window' },
    { '<leader><Del>', ':silent %bdelete | Alpha<CR>', desc = 'Close all buffers' },
    { '<C-w>-', ':new<CR>', desc = 'Open new horizontal split' },
    { '<C-w>\\', ':vnew<CR>', desc = 'Open new vertical split' },
    {
      '<C-w>,',
      function()
        vim.ui.input({
          prompt = 'Tab name:',
          default = utils.getVarWithDefault('t', 0, 'custom_tab_name', ''),
        }, function(input)
          vim.api.nvim_tabpage_set_var(0, 'custom_tab_name', input)
        end)
      end,
      desc = 'Rename current tab',
    },

    {
      '<leader><leader>f',
      function()
        local fos = require('format-on-save')
        local enabled = require('format-on-save.config').enabled
        if enabled == true then
          vim.schedule(fos.disable)
        else
          vim.schedule(fos.enable)
        end
      end,
      desc = 'Toggle format-on-save',
    },

    {
      mode = 'nvo',
      { '<C-c>', proxy = '<Esc>', hidden = true },

      -- Don't use arrow keys
      { '<up>', '<nop>', hidden = true },
      { '<down>', '<nop>', hidden = true },
      { '<left>', '<nop>', hidden = true },
      { '<right>', '<nop>', hidden = true },

      -- Sane navigation
      { 'k', 'gk', desc = 'Up' },
      { 'j', 'gj', desc = 'Down' },
    },
  },
})
