local telescope = require('telescope')
local actions = require('telescope.actions')
local builtins = require('telescope.builtin')
local trouble = require('trouble.sources.telescope')
local themes = require('telescope.themes')
local wk = require('which-key')

local M = {}

function M.edit_neovim()
  builtins.find_files({
    prompt_title = '~ dotfiles ~',
    shorten_path = false,
    find_command = { 'fd', '--extension', 'lua' },
    cwd = '~/.config/nvim',

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
        ['<C-l>'] = trouble.open,
        ['<M-k>'] = actions.preview_scrolling_up,
        ['<M-j>'] = actions.preview_scrolling_down,
      },
      n = {
        ['<C-p>'] = actions.cycle_history_prev,
        ['<C-n>'] = actions.cycle_history_next,
      },
    },
  },
  extensions = {
    -- ['ui-select'] = {
    --   themes.get_cursor(),
    -- },
    ['emoji'] = {
      action = function(emoji)
        vim.fn.setreg('*', emoji.value)
        vim.api.nvim_put({ emoji.value }, 'c', false, true)
      end,
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
        { 'colorscheme', ":lua require('telescope.builtin').colorscheme()", 1 },
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
  local dotfiles_repo = vim.fn.glob('$HOME/.config/nvim')
  local cwd = vim.fn.getcwd()
  local in_dotfiles_repo = cwd == dotfiles_repo
  local in_dotfiles_subdir = vim.tbl_contains(vim.fn.globpath(dotfiles_repo, '*', false, true), cwd)
  local in_git_repo = vim.fn.systemlist('git rev-parse --is-inside-work-tree')[1] == 'true'
  if in_git_repo then
    builtins.git_files({ show_untracked = true })
  elseif in_dotfiles_repo or in_dotfiles_subdir then
    M.edit_neovim()
  else
    builtins.find_files()
  end
end

telescope.load_extension('fzf')
-- telescope.load_extension('ui-select')
telescope.load_extension('file_browser')
telescope.load_extension('notify')
telescope.load_extension('gh')
telescope.load_extension('command_palette')
telescope.load_extension('lsp_handlers')
telescope.load_extension('emoji')
wk.add({
  { '<C-b>', '<C-o>:Telescope emoji<CR>', desc = 'Open emoji picker', mode = 'i' },
})
wk.add({
  { '&', ':Telescope grep_string<CR>', desc = 'Grep for string under cursor' },
  { '<C-p>', get_files, desc = 'Open file picker' },
  { '<leader>G', builtins.live_grep, desc = 'Open LiveGrep' },
  { '<leader>p', ':Telescope command_palette<CR>', desc = 'Show Command Palette' },
  { '<leader>?', builtins.help_tags, desc = 'Search vim-help' },
  { '<leader><leader>.', builtins.reloader, desc = 'Reload Lua Modules' },
})

return M
