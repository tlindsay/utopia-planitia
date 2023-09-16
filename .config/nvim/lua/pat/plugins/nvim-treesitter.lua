-----------------------------------------------------------
-- Treesitter configuration file
----------------------------------------------------------

-- Plugin: nvim-treesitter
-- url: https://github.com/nvim-treesitter/nvim-treesitter

local ts = require('nvim-treesitter.configs')
local ctx = require('treesitter-context')
local wk = require('which-key')

-- Apply "Various TextObjects"
require('various-textobjs').setup({ useDefaultKeymaps = true })

-- Fix compiler issue on MacOS
-- (Prerequisite is $ brew install gcc)
require('nvim-treesitter.install').compilers = { 'gcc-12' }

wk.register({
  ['<leader>H'] = { ':TSHighlightCapturesUnderCursor<CR>', 'Display TS Highlight' },
})

require('treesj').setup()

ts.setup({
  auto_install = true,
  autopairs = { enable = true },
  autotag = { enable = true },
  context_commentstring = {
    enable = true,
    enable_autocmd = false, -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring#commentnvim
    config = {
      handlebars = { __default = '{{! %s }}', __multiline = '{{!-- %s --}}' },
      glimmer = { __default = '{{! %s }}', __multiline = '{{!-- %s --}}' },
    },
  },
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
  },
  rainbow = {
    enable = true,
    query = {
      'rainbow-parens',
      html = 'rainbow-tags',
      javascript = 'rainbow-parens',
      typescript = 'rainbow-parens',
      jsx = 'rainbow-parens',
      tsx = 'rainbow-parens-react',
    },
    strategy = require('ts-rainbow.strategy.local'),
    max_file_lines = 3000,
    extended_mode = true,
    hlgroups = {
      'TSRainbowCyan',
      'TSRainbowViolet',
      'TSRainbowGreen',
      'TSRainbowOrange',
      'TSRainbowBlue',
      'TSRainbowYellow',
      'TSRainbowRed',
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

ctx.setup({
  enable = true,
  max_lines = 0,
})
local colors = require('pat.core/colors')
vim.api.nvim_set_hl(
  0,
  'TreesitterContext',
  { italic = true, fg = colors.tokyonight.magenta, bg = colors.tokyonight.bg_highlight, blend = 50 }
)
vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { fg = colors.tokyonight.magenta })
vim.api.nvim_set_hl(0, 'TSRainbowGreen', { fg = colors.tokyonight.blue6 })
