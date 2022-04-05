local M = {}
notify = require("notify")

M["unload_lua_namespace"] = function(prefix)
  local prefix_with_dot = prefix .. "."
  for key, value in pairs(package.loaded) do
    if key == prefix or key:sub(1, #prefix_with_dot) == prefix_with_dot then
      package.loaded[key] = nil
    end
  end
end

function M:init()
  require("core.autocmds").load_augroups()
  require("plugins.nvim-lspconfig")
end

function M:load() end

function M:reload()
  M.unload_lua_namespace("core")
  M.unload_lua_namespace("plugins")
  dofile(vim.fn.stdpath("config") .. "/init.lua")
  print("Reloaded vimrc!")
  notify("Config updated!", "success")
end
