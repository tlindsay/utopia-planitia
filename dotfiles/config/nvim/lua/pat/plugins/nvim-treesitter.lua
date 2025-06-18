-----------------------------------------------------------
-- Treesitter configuration file
----------------------------------------------------------

-- Plugin: nvim-treesitter
-- url: https://github.com/nvim-treesitter/nvim-treesitter

local ts = require('nvim-treesitter.configs')
local ts_utils = require('nvim-treesitter.ts_utils')
local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
local ctx = require('treesitter-context')
local wk = require('which-key')

parser_config.nu = {
  install_info = {
    url = 'https://github.com/nushell/tree-sitter-nu',
    files = { 'src/parser.c' },
    branch = 'main',
  },
  filetype = 'nu',
}

parser_config.vcl = {
  install_info = {
    url = 'https://github.com/isudzumi/tree-sitter-vcl',
    files = { 'src/parser.c' },
    branch = 'main',
  },
  filetype = 'vcl',
}

local function run_treesitter_query()
  -- Get the current buffer and its tree
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(bufnr, 'go')
  local tree = parser:parse()[1] -- Get the first tree

  -- Get the string under the cursor
  local cursor_word = vim.fn.expand('<cword>')

  -- Define your Tree-sitter query
  local query_string = [[
      (method_declaration
        receiver: (parameter_list
          (parameter_declaration
            name: (identifier) @receiver_name
          )
        )
        name: (identifier) @method_name
      )
    ]]

  -- Create a query object
  local query = vim.treesitter.query.parse('go', query_string)

  -- Get the root node of the tree
  local root = tree:root()

  -- Iterate through matches
  for id, node, metadata in query:iter_matches(root, bufnr) do
    local receiver_name = ts_utils.get_node_text(node:field('receiver_name')[1], bufnr)

    -- Check if the receiver name matches the cursor word
    if receiver_name == cursor_word then
      local method_name = ts_utils.get_node_text(node:field('method_name')[1], bufnr)
      print('Method: ' .. method_name .. ' (Receiver: ' .. receiver_name .. ')')
    end
  end
end

wk.register({
  ['<leader>H'] = { ':TSHighlightCapturesUnderCursor<CR>', 'Display TS Highlight' },
  ['<leader>Tq'] = { run_treesitter_query, 'Run Treesitter Query' },
})

require('treesj').setup({
  check_syntax_error = false,
  max_join_length = 1000,
})

vim.g.skip_ts_context_commentstring_module = true
require('ts_context_commentstring').setup({
  enable = true,
  enable_autocmd = false, -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring#commentnvim
  config = {
    handlebars = { __default = '{{! %s }}', __multiline = '{{!-- %s --}}' },
    glimmer = { __default = '{{! %s }}', __multiline = '{{!-- %s --}}' },
  },
})

ts.setup({
  auto_install = true,
  ignore_install = { 'norg', 'tlaplus' },
  autopairs = { enable = true },
  autotag = { enable = true },
  endwise = {
    enable = true,
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-Space>',
      node_incremental = '<C-Space>',
      scope_incremental = false,
      node_decremental = '<bs>',
    },
  },
  playground = {
    enable = true,
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
  textobjects = {
    move = {
      enable = true,
      set_jumps = true,
    },
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ['<leader>gF'] = '@function.outer',
        ['<leader>gC'] = '@class.outer',
      },
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['a='] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
        ['i='] = { query = '@assignment.inner', desc = 'Select inner part of an assignment' },
        ['l='] = { query = '@assignment.lhs', desc = 'Select left hand side of an assignment' },
        ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of an assignment' },

        ['af'] = { query = '@function.outer', desc = 'Select outer part of a function/method definition' },
        ['if'] = { query = '@function.inner', desc = 'Select outer part of a function/method definition' },

        ['ab'] = { query = '@block.outer', desc = 'Select outer part of a block' },
        ['ib'] = { query = '@block.inner', desc = 'Select outer part of a block' },

        ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
        ['ii'] = { query = '@conditional.inner', desc = 'Select outer part of a conditional' },

        ['ac'] = { query = '@call.outer', desc = 'Select outer part of a function call' },
        ['ic'] = { query = '@call.inner', desc = 'Select outer part of a function call' },

        ['ax'] = { query = '@statement.outer', desc = 'Select outer part of a statement' },
        ['ix'] = { query = '@statement.inner', desc = 'Select outer part of a statement' },
      },
      include_surrounding_whitespace = false,
    },
  },
})

local colors = require('pat.core/colors')

ctx.setup({
  enable = true,
  max_lines = 0,
})
vim.api.nvim_set_hl(
  0,
  'TreesitterContext',
  { italic = true, fg = colors.tokyonight.magenta, bg = colors.tokyonight.bg_highlight, blend = 50 }
)
vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { fg = colors.tokyonight.magenta })

require('rainbow-delimiters.setup').setup({
  enable = true,
  blacklist = { 'help' },
  query = {
    [''] = 'rainbow-delimiters',
    lua = 'rainbow-blocks',
    html = 'rainbow-tags',
    javascript = 'rainbow-delimiters-react',
    typescript = 'rainbow-delimiters-react',
    jsx = 'rainbow-delimiters-react',
    tsx = 'rainbow-delimiters-react',
  },
  strategy = {
    [''] = require('rainbow-delimiters').strategy['global'],
  },
  max_file_lines = 3000,
  extended_mode = true,
  highlight = {
    'RainbowDelimiterCyan',
    'RainbowDelimiterViolet',
    'RainbowDelimiterGreen',
    'RainbowDelimiterOrange',
    'RainbowDelimiterBlue',
    'RainbowDelimiterYellow',
    'RainbowDelimiterRed',
  },
})
