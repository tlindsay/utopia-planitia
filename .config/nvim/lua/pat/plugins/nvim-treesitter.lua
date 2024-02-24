-----------------------------------------------------------
-- Treesitter configuration file
----------------------------------------------------------

-- Plugin: nvim-treesitter
-- url: https://github.com/nvim-treesitter/nvim-treesitter

local ts = require('nvim-treesitter.configs')
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

wk.register({
  ['<leader>H'] = { ':TSHighlightCapturesUnderCursor<CR>', 'Display TS Highlight' },
})

require('treesj').setup()

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
    lsp_interop = {
      enable = true,
      border = 'double',
      peek_definition_code = {
        ['<leader>gF'] = '@function.outer',
        ['<leader>gC'] = '@class.outer',
      },
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ab'] = '@block.outer',
        ['ib'] = '@block.inner',
        ['ax'] = '@call.outer',
        ['ix'] = '@call.inner',
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
