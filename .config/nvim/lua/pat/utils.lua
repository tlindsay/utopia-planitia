-- require('debuglog').setup({ log_to_file = true, log_to_console = true })
-- local dlog = require('debuglog')
-- Vlog = dlog('nvim')

local M = {}

-- Moses = require('moses')
_G.P = function(...)
  print(vim.inspect(...))
  return ...
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

function M.rust_playground(opts)
  ---@diagnostic disable-next-line: redefined-local
  local opts = opts or {}
  local copy = opts.copy or false
  local open = opts.open or false
  local char_to_hex = function(c)
    return string.format('%%%02X', string.byte(c))
  end

  local function urlencode(url)
    if url == nil then
      return
    end
    url = url:gsub('\n', '\r\n')
    url = url:gsub('([^%w ])', char_to_hex)
    url = url:gsub(' ', '+')
    return url
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local text = table.concat(lines, '\n')
  local encoded = urlencode(text)

  local root_url = 'https://play.rust-lang.org/'
  local opts = {
    'version=stable',
    'mode=debug',
    'edition=2021',
    'code=' .. encoded,
  }

  local final_url = root_url .. '?' .. table.concat(opts, '&')
  if open then
    vim.fn.system({ 'open', final_url })
  end
  if copy then
    vim.cmd("let @*=trim('" .. final_url .. "')")
  end

  if not open and not copy then
    print(final_url)
  end

  return final_url
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
