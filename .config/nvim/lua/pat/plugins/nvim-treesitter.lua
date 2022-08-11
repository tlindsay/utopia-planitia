-----------------------------------------------------------
-- Treesitter configuration file
----------------------------------------------------------

-- Plugin: nvim-treesitter
-- url: https://github.com/nvim-treesitter/nvim-treesitter

local ts = require('nvim-treesitter.configs')
local ctx = require('treesitter-context')

ts.setup({
  autopairs = { enable = true },
  context_commentstring = {
    enable = true,
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
    enable = true,
  },
  playground = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
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
    },
  },
})

ctx.setup({
  enable = true,
  max_lines = 0,
})
local colors = require('pat.core.colors')
vim.api.nvim_set_hl(
  0,
  'TreesitterContext',
  { italic = true, fg = colors.tokyonight.magenta, bg = colors.tokyonight.bg_highlight, blend = 50 }
)
vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { fg = colors.tokyonight.magenta })
