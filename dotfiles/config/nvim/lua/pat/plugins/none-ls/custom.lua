local null_ls = require('null-ls')
local h = require('null-ls.helpers')
local utils = require('null-ls.utils')
local ts_utils = require('nvim-treesitter.ts_utils')
local Job = require('plenary.job')
local log = require('null-ls.logger')

local struct_query = vim.treesitter.query.parse(
  'go',
  [[
    (type_spec name:(type_identifier) @struct_name)
  ]]
)

vim.treesitter.query.parse(
  'go',
  [[
    ((method_declaration
      receiver: (parameter_list)@method.receiver
      name: (field_identifier)@method.name)
    )
  ]]
)

local func_query = vim.treesitter.query.parse(
  'go',
  [[
    (function_declaration name: (identifier) @function_name)
  ]]
)

local M = { code_actions = {}, diagnostics = {}, formatting = {} }
-- Function to get the current function name or struct methods using Tree-sitter
local function get_current_function_or_struct_methods_TS()
  local cursor_node = ts_utils.get_node_at_cursor()
  local tree = cursor_node:tree()

  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor_pos[1] - 1

  local node = nil

  for _, n, _, _ in struct_query:iter_captures(tree, 0, current_line, current_line + 1) do
    node = n
    break
  end

  if node == nil then
    for _, n, _, _ in func_query:iter_captures(tree, 0, current_line, current_line + 1) do
      node = n
      break
    end
  end

  if not node then
    log:debug('cursor not on node')
    return {}
  end

  local function_names = {}
  local struct_methods = {}

  log:debug(string.format('node type: %s', node:type()))

  -- Check if the node is a function declaration
  if node:type() == 'function_declaration' then
    local func_name_node = node:field('name')[1]
    if func_name_node then
      table.insert(function_names, vim.treesitter.get_node_text(func_name_node, 0))
      log:debug(string.format('inserted: %s', vim.inspect(function_names)))
    end
  elseif node:type() == 'type_spec' then
    -- Look for struct declarations and their methods
    local type_name_node = node:field('name')[1]
    if type_name_node then
      local struct_name = vim.treesitter.get_node_text(type_name_node, 0)
      -- Traverse sibling nodes to find methods
      local parent = node:parent()
      for method in parent:iter_children() do
        if method:type() == 'method_declaration' then
          local method_name_node = method:field('name')[1]
          if method_name_node then
            table.insert(struct_methods, vim.treesitter.get_node_text(method_name_node, 0))
          end
        end
      end
    end
  end

  return #function_names > 0 and function_names or struct_methods
end

-- Function to get the current function name or struct methods
local function get_current_function_or_struct_methods()
  local line = vim.api.nvim_get_current_line()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor_pos[1] - 1
  local current_col = cursor_pos[2]

  -- Check if the line contains a function declaration
  local func_pattern = 'function%s+([%w_]+)%s*%('
  local struct_pattern = 'type%s+([%w_]+)%s+struct'

  -- If the cursor is on a function declaration
  if line:find(func_pattern) then
    local func_name = line:match(func_pattern)
    return { func_name }
  end

  -- Check for struct declarations in previous lines
  for i = current_line, 0, -1 do
    local prev_line = vim.api.nvim_buf_get_lines(0, i, i + 1, false)[1]
    if prev_line and prev_line:find(struct_pattern) then
      local struct_name = prev_line:match(struct_pattern)
      -- Find all methods of the struct
      local methods = {}
      local method_pattern = struct_name .. '%s*%w+%s*%('
      for j = i + 1, vim.api.nvim_buf_line_count(0) - 1 do
        local method_line = vim.api.nvim_buf_get_lines(0, j, j + 1, false)[1]
        if method_line and method_line:find(method_pattern) then
          local method_name = method_line:match(method_pattern)
          table.insert(methods, method_name)
        elseif method_line:find('}') then
          break -- End of struct methods
        end
      end
      return methods
    end
  end

  return {}
end

-- Define a helper function to run gotests
local function run_gotests(useTS, params, done)
  log:debug(
    string.format('trying to generate gotests Job: %s', vim.inspect({ useTS = useTS, params = params, done = done }))
  )
  local function_names
  if useTS then
    function_names = get_current_function_or_struct_methods_TS()
  else
    function_names = get_current_function_or_struct_methods()
  end
  log:debug(string.format('found methods: %s', vim.inspect(function_names)))
  if #function_names == 0 then
    return nil -- No functions or methods found
  end

  local retVal = {
    command = 'gotests',
    args = {
      '-w',                              -- write the results back to the file
      '-only',
      table.concat(function_names, '|'), -- generate tests for specific functions/methods
      params.bufname,                    -- the name of the buffer
    },
    cwd = params.cwd,
    on_exit = function(...)
      vim.notify('tests finished generating...', vim.log.levels.INFO, {})
      done()
    end,
  }
  log:debug(string.format('return val: %s', vim.inspect(retVal)))
  return function()
    Job:new(retVal):start()
  end
end

M.code_actions.gotests_TS = h.make_builtin({
  name = 'gotests_TS',
  meta = {
    url = 'https://github.com/cweill/gotests',
    description = '(Treesitter) Go tool to generate tests',
    notes = { 'The gotests tool must be installed and executable.' },
  },
  method = null_ls.methods.CODE_ACTION,
  filetypes = { 'go' },
  generator = {
    fn = function(...)
      local action = run_gotests(true, ...)
      return action ~= nil
          and {
            {
              title = 'Generate tests for symbol under cursor (Regex)',
              action = run_gotests(true, ...),
            },
          }
          or {}
    end,
    async = false,
  },
})

M.code_actions.gotests = h.make_builtin({
  name = 'gotests',
  meta = {
    url = 'https://github.com/cweill/gotests',
    description = 'Go tool to generate tests',
    notes = { 'The gotests tool must be installed and executable.' },
  },
  method = null_ls.methods.CODE_ACTION,
  filetypes = { 'go' },
  can_run = function()
    return utils.is_executable('gotests')
  end,
  generator = {
    fn = function(...)
      local action = run_gotests(false, ...)
      return action ~= nil
          and {
            {
              title = 'Generate tests for symbol under cursor (Regex)',
              action = run_gotests(false, ...),
            },
          }
          or {}
    end,
    async = true,
  },
})

return M
