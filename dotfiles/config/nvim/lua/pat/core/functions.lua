local utils = require('pat.utils')
local M = {}

function M.scrollbindPanes()
  local isBound = utils.getVarWithDefault('tabpage', 0, 'is_scroll_bound', false)
  vim.api.nvim_tabpage_set_var(0, 'is_scroll_bound', not isBound)

  local winIds = vim.api.nvim_tabpage_list_wins(0)
  vim.tbl_map(function(winId)
    vim.api.nvim_win_set_option(winId, 'scrollbind', not isBound)
    vim.api.nvim_win_set_option(winId, 'cursorbind', not isBound)
  end, winIds)
end

return M
