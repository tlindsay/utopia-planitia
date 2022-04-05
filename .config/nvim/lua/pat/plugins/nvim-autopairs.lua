local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")

npairs.setup({
  check_ts = true,
})

npairs.add_rules(require("nvim-autopairs.rules.endwise-elixir"))
npairs.add_rules(require("nvim-autopairs.rules.endwise-ruby"))
npairs.add_rules(require("nvim-autopairs.rules.endwise-lua"))

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

npairs.add_rules({
  Rule(" ", " "):with_pair(function(opts)
    local pair = opts.line:sub(opts.col - 1, opts.col)
    return vim.tbl_contains({ "()", "[]", "{}" }, pair)
  end),
  Rule("( ", " )")
    :with_pair(function()
      return false
    end)
    :with_move(function(opts)
      return opts.prev_char:match(".%)") ~= nil
    end)
    :use_key(")"),
  Rule("{ ", " }")
    :with_pair(function()
      return false
    end)
    :with_move(function(opts)
      return opts.prev_char:match(".%}") ~= nil
    end)
    :use_key("}"),
  Rule("[ ", " ]")
    :with_pair(function()
      return false
    end)
    :with_move(function(opts)
      return opts.prev_char:match(".%]") ~= nil
    end)
    :use_key("]"),
})

-- local cond = require'nvim-autopairs.conds'

-- npairs.add_rules {
--   Rule(' ', ' ')
--     :with_pair(function(opts)
--       local pair = opts.line:sub(opts.col -1, opts.col)
--       return vim.tbl_contains({ '()', '{}', '[]' }, pair)
--     end)
--     :with_move(cond.none())
--     :with_cr(cond.none())
--     :with_del(function(opts)
--       local col = vim.api.nvim_win_get_cursor(0)[2]
--       local context = opts.line:sub(col - 1, col + 2)
--       return vim.tbl_contains({ '(  )', '{  }', '[  ]' }, context)
--     end),
--   Rule('', ' )')
--     :with_pair(cond.none())
--     :with_move(function(opts) return opts.char == ')' end)
--     :with_cr(cond.none())
--     :with_del(cond.none())
--     :use_key(')'),
--   Rule('', ' }')
--     :with_pair(cond.none())
--     :with_move(function(opts) return opts.char == '}' end)
--     :with_cr(cond.none())
--     :with_del(cond.none())
--     :use_key('}'),
--   Rule('', ' ]')
--     :with_pair(cond.none())
--     :with_move(function(opts) return opts.char == ']' end)
--     :with_cr(cond.none())
--     :with_del(cond.none())
--     :use_key(']'),
-- }

-- npairs.enable()
