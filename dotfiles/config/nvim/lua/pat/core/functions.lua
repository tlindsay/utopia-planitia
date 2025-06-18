local utils = require('pat.utils')
local M = {}

function M.scrollbindPanes()
  local isBound = utils.getVarWithDefault('tabpage', 0, 'is_scroll_bound', false)
  vim.api.nvim_tabpage_set_var(0, 'is_scroll_bound', not isBound)

  local winIds = vim.api.nvim_tabpage_list_wins(0)
  vim.tbl_map(function(winId)
    vim.api.nvim_set_option_value('scrollbind', not isBound, { win = winId })
    vim.api.nvim_set_option_value('cursorbind', not isBound, { win = winId })
  end, winIds)
end

return M
