local telescope = require('telescope')
local actions = require('telescope.actions')
local builtins = require('telescope.builtin')
local trouble = require('trouble.providers.telescope')
local themes = require('telescope.themes')
local wk = require('which-key')

local M = {}

function M.edit_neovim()
  builtins.find_files({
    prompt_title = '~ dotfiles ~',
    shorten_path = false,
    find_command = { 'yadm', 'list' },
    cwd = '~/',

    layout_strategy = 'horizontal',
    layout_config = {
      preview_width = 0.65,
    },
  })
end

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
        ['<C-l>'] = trouble.open_with_trouble,
      },
      n = {
        ['<C-p>'] = actions.cycle_history_prev,
        ['<C-n>'] = actions.cycle_history_next,
      },
    },
  },
  extensions = {
    ['ui-select'] = {
      themes.get_cursor(),
    },
    ['file_browser'] = {
      theme = 'ivy',
    },
    ['lsp_handlers'] = {
      location = {
        telescope = themes.get_ivy({}),
      },
      code_action = {
        telescope = themes.get_dropdown({}),
      },
    },
    ['command_palette'] = {
      {
        'Help',
        { 'tips', ':help tips' },
        { 'cheatsheet', ':help index' },
        { 'tutorial', ':help tutor' },
        { 'summary', ':help summary' },
        { 'quick reference', ':help quickref' },
        { 'search help(F1)', ":lua require('telescope.builtin').help_tags()", 1 },
      },
      {
        'Vim',
        { 'reload vimrc', ':source $MYVIMRC' },
        { 'check health', ':checkhealth' },
        { 'jumps (Alt-j)', ":lua require('telescope.builtin').jumplist()" },
        { 'commands', ":lua require('telescope.builtin').commands()" },
        { 'command history', ":lua require('telescope.builtin').command_history()" },
        { 'registers (A-e)', ":lua require('telescope.builtin').registers()" },
        { 'colorshceme', ":lua require('telescope.builtin').colorscheme()", 1 },
        { 'vim options', ":lua require('telescope.builtin').vim_options()" },
        { 'keymaps', ":lua require('telescope.builtin').keymaps()" },
        { 'buffers', ':Telescope buffers' },
        { 'search history (C-h)', ":lua require('telescope.builtin').search_history()" },
        { 'paste mode', ':set paste!' },
        { 'cursor line', ':set cursorline!' },
        { 'cursor column', ':set cursorcolumn!' },
        { 'spell checker', ':set spell!' },
        { 'relative number', ':set relativenumber!' },
        { 'search highlighting (F12)', ':set hlsearch!' },
      },
    },
  },
})

local function get_files()
  local in_git_repo = vim.fn.systemlist('git rev-parse --is-inside-work-tree')[1] == 'true'
  if in_git_repo then
    builtins.git_files({ show_untracked = true })
  else
    builtins.find_files()
  end
end

telescope.load_extension('fzf')
telescope.load_extension('ui-select')
telescope.load_extension('file_browser')
telescope.load_extension('node_modules')
telescope.load_extension('notify')
-- telescope.load_extension('noice')
telescope.load_extension('gh')
telescope.load_extension('command_palette')
telescope.load_extension('lsp_handlers')
telescope.load_extension('emoji')
wk.register({
  ['<C-p>'] = { get_files, 'Open file picker' },
  -- ['<C-n>'] = {
  --   ':Telescope file_browser<CR>',
  --   'Open file browser',
  -- },
  ['<leader>'] = {
    g = { builtins.live_grep, 'Open LiveGrep' },
    n = { telescope.extensions.node_modules.list, 'List Node Modules' },
    N = { telescope.extensions.neorg.find_norg_files, 'List Neorg Entries' },
    p = { ':Telescope command_palette<CR>', 'Show Command Palette' },
    ['?'] = { builtins.help_tags, 'Search vim-help' },
    ['<leader>'] = {
      ['.'] = { M.edit_neovim, 'Dotfiles' },
      ['j'] = { ':Telescope neorg find_linkable<CR>', 'Neorg' },
    },
  },
})

return M
