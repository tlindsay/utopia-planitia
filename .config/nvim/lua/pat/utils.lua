-- require('debuglog').setup({ log_to_file = true, log_to_console = true })
-- local dlog = require('debuglog')
-- Vlog = dlog('nvim')

local M = {}

-- Moses = require('moses')
_G.P = function(...)
  print(vim.inspect(...))
  return ...
end

-- Adapted from https://stackoverflow.com/a/41943392/1915058
_G.table_to_lines = function(tbl, indent)
  if not indent then
    indent = 0
  end
  local toprint = { string.rep(' ', indent) .. '{' }
  indent = indent + 2

  for k, v in pairs(tbl) do
    local line = string.rep(' ', indent)
    if type(k) == 'number' then
      line = line .. '[' .. k .. '] = '
    elseif type(k) == 'string' then
      line = line .. (k == '' and '""' or k) .. ' = '
    else
      line = line .. '"' .. tostring(k) .. '" = '
    end

    if type(v) == 'number' then
      table.insert(toprint, line .. v .. ',')
      next(tbl, k)
    elseif type(v) == 'string' then
      table.insert(toprint, line .. '"' .. v .. '",')
      next(tbl, k)
    elseif type(v) == 'table' then
      table.insert(toprint, line .. '{')
      vim.list_extend(toprint, vim.tbl_values(table_to_lines(v, indent + 2)))
      table.insert(toprint, string.rep(' ', indent) .. '},')
      next(tbl, k)
    else
      table.insert(toprint, line .. '"' .. tostring(v) .. '",')
      next(tbl, k)
    end
  end

  table.insert(toprint, string.rep(' ', indent - 2) .. '}')
  return toprint
end

_G.dump_to_buf = function(...)
  local buf_id = 0
  local tbl = select(1, ...) or {}
  local should_append = select(2, ...) == nil and true or select(2, ...)

  vim.api.nvim_buf_set_lines(buf_id, 0, should_append and 0 or -1, false, table_to_lines(tbl))
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

M.getVarWithDefault = function(scope, ...)
  local arg = { ... }
  if scope == nil or #arg < 2 then
    error('insufficient arguments passed to getVarWithDefault')
    return
  end

  local defaultVal = arg[#arg]
  local fn
  if scope == 'global' or scope == 'g' then
    local varName = select(1, ...)
    fn = function()
      return vim.api.nvim_get_var(varName)
    end
  elseif scope == 'tabpage' or scope == 't' then
    local tabpageId, varName = select(1, ...)
    fn = function()
      return vim.api.nvim_tabpage_get_var(tabpageId, varName)
    end
  elseif scope == 'win' or scope == 'w' then
    local winId, varName = select(1, ...)
    fn = function()
      return vim.api.nvim_win_get_var(winId, varName)
    end
  elseif scope == 'buf' or scope == 'b' then
    local bufId, varName = select(1, ...)
    fn = function()
      return vim.api.nvim_buf_get_var(bufId, varName)
    end
  else
    error('invalid scope passed to getVarWithDefault')
  end

  local wasSet, retVal = pcall(fn)
  if wasSet then
    return retVal
  else
    return defaultVal
  end
end
-- Stolen from https://stackoverflow.com/questions/32031473/lua-line-wrapping-excluding-certain-characters
M.wrap = function(str, limit, indent, indent1)
  indent = indent or ''
  indent1 = indent1 or indent
  limit = limit or 79
  local here = 1 - #indent1
  return indent1
      .. str:gsub('(%s+)()(%S+)()', function(sp, st, word, fi)
        if fi - here > limit then
          here = st - #indent
          return '\n' .. indent .. word
        end
      end)
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

function M:get_global_theme()
  local ryaml = require('lua-ryaml')
  local theme_file = io.open(os.getenv('HOME') .. '.config/theme.yml', 'r')
  local theme = ryaml.decode(theme_file)
  print(theme)
end

function M:get_diagnostic_icon(level)
  local sign = vim.fn.sign_getdefined('DiagnosticSign' .. level:lower():gsub('^%l', string.upper))
  return sign[1].text
end

return M
