local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds')
-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
-- local cmp = require('cmp')

-- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))

npairs.setup({ map_cr = true })

-- Fix auto-spaces
npairs.add_rules({
  Rule(' ', ' ')
    :with_pair(function(opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ '()', '{}', '[]' }, pair)
    end)
    :with_move(cond.none())
    :with_cr(cond.none())
    :with_del(function(opts)
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local context = opts.line:sub(col - 1, col + 2)
      return vim.tbl_contains({ '(  )', '{  }', '[  ]' }, context)
    end),
  Rule('', ' )')
    :with_pair(cond.none())
    :with_move(function(opts)
      return opts.char == ')'
    end)
    :with_cr(cond.none())
    :with_del(cond.none())
    :use_key(')'),
  Rule('', ' }')
    :with_pair(cond.none())
    :with_move(function(opts)
      return opts.char == '}'
    end)
    :with_cr(cond.none())
    :with_del(cond.none())
    :use_key('}'),
  Rule('', ' ]')
    :with_pair(cond.none())
    :with_move(function(opts)
      return opts.char == ']'
    end)
    :with_cr(cond.none())
    :with_del(cond.none())
    :use_key(']'),
})

-- TESTING JUMP OUT
-- https://github.com/windwp/nvim-autopairs/issues/147#issuecomment-952639522
local utils = require('nvim-autopairs.utils')

local function multiline_close_jump(char)
  return Rule(char, '')
    :with_pair(function(opts)
      local row, col = utils.get_cursor()
      local line = utils.text_get_current_line(opts.bufnr)

      if #line ~= col then --not at EOL
        return false
      end

      local nextrow = row + 1
      if nextrow < vim.api.nvim_buf_line_count(0) and vim.regex('^\\s*' .. char):match_line(0, nextrow) then
        return true
      end
      return false
    end)
    :with_move(cond.none())
    :with_cr(cond.none())
    :with_del(cond.none())
    :set_end_pair_length(0)
    :replace_endpair(function()
      return '<esc>xwa'
    end)
end

npairs.add_rules({
  multiline_close_jump(')'),
  multiline_close_jump(']'),
  multiline_close_jump('}'),
})
