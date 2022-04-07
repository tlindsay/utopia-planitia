local actions = require('telescope.actions')
local builtins = require('telescope.builtin')
local wk = require('which-key')

require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<Esc>'] = actions.close,
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-p>'] = actions.cycle_history_prev,
        ['<C-n>'] = actions.cycle_history_next,
        ['<C-u>'] = false, -- Enable C-u to clear
      },
      n = {
        ['<C-p>'] = actions.cycle_history_prev,
        ['<C-n>'] = actions.cycle_history_next,
      },
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_cursor(),
    },
  },
})

local function get_files()
  if not pcall(builtins.git_files) then
    pcall(builtins.find_files)
  end
end

wk.register({
  ['<C-p>'] = { get_files, 'Open file picker' },
  ['<leader>'] = {
    ['?'] = { builtins.help_tags, 'Search vim-help' },
  },
})

require('telescope').load_extension('fzf')
require('telescope').load_extension('ui-select')
