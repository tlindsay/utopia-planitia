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

local pairingOptName = 'PairingModeEnabled'
local function setPairingMode(pairingEnabled)
  local hardtime = require('hardtime')
  vim.api.nvim_set_var(pairingOptName, pairingEnabled)

  vim.iter(vim.api.nvim_list_wins()):each(function(winId)
    vim.api.nvim_set_option_value('relativenumber', not pairingEnabled, { win = winId })
  end)

  if pairingEnabled then
    hardtime.disable()
  else
    hardtime.enable()
  end
end

function M.togglePairingMode()
  local isEnabled = utils.getVarWithDefault('global', pairingOptName, false)
  setPairingMode(not isEnabled)
end

vim.api.nvim_create_user_command('EnablePairingMode', function()
  setPairingMode(true)
end, { desc = 'Enable Pairing Mode' })
vim.api.nvim_create_user_command('DisablePairingMode', function()
  setPairingMode(false)
end, { desc = 'Disable Pairing Mode' })
vim.api.nvim_create_user_command('TogglePairingMode', M.togglePairingMode, { desc = 'Toggle Pairing Mode' })

return M
