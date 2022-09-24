-- require('debuglog').setup({ log_to_file = true, log_to_console = true })
-- local dlog = require('debuglog')
-- Vlog = dlog('nvim')

local M = {}

-- Moses = require('moses')
P = function(v)
  print(vim.inspect(v))
  return v
end

-- Plog = function(v)
--   Vlog(vim.inspect(v))
--   return v
-- end

if pcall(require, 'plenary') then
  RELOAD = require('plenary.reload').reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end

function _G.reload_config()
  local reload = require('plenary.reload').reload_module
  reload('pat', false)
  dofile(vim.env.MYVIMRC)
end

M['unload_lua_namespace'] = function(prefix)
  local prefix_with_dot = prefix .. '.'
  for key in pairs(package.loaded) do
    if key == prefix or key:sub(1, #prefix_with_dot) == prefix_with_dot then
      package.loaded[key] = nil
    end
  end
end

function M:init()
  require('core.autocmds').load_augroups()
  require('plugins.nvim-lspconfig')
end

function M:load() end

function M:reload()
  M.unload_lua_namespace('pat.core')
  M.unload_lua_namespace('pat.plugins')
  dofile(vim.fn.stdpath('config') .. '/init.lua')
  print('Reloaded vimrc!')
  vim.notify('Config updated!', 'success')
end

return M
