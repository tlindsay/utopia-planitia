-- tmux-socket.lua: Auto-start nvim server and register socket with tmux

local M = {}

-- Function to start nvim server and register with tmux
local function start_server_and_register()
  -- Only run if we're in a tmux session
  if not vim.env.TMUX then
    return
  end

  -- Check if there's already a server running
  local server_list = vim.fn.serverlist()
  local socket_path
  
  if #server_list > 0 then
    -- Use the first existing server
    socket_path = server_list[1]
  else
    -- Generate unique socket path and start new server
    socket_path = vim.fn.tempname() .. ".nvim"
    vim.fn.serverstart(socket_path)
  end
  
  -- Register the socket with tmux using our helper script
  local cmd = string.format("tmux-nvim-socket register '%s'", socket_path)
  vim.fn.system(cmd)
  
  -- Store socket path for cleanup
  vim.g.tmux_nvim_socket = socket_path
end

-- Function to clean up on exit
local function cleanup_socket()
  if vim.g.tmux_nvim_socket then
    vim.fn.system("tmux-nvim-socket clean")
  end
end

-- Set up autocommands
local augroup = vim.api.nvim_create_augroup("TmuxNvimSocket", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,
  callback = start_server_and_register,
  desc = "Start nvim server and register socket with tmux",
})

vim.api.nvim_create_autocmd("VimLeave", {
  group = augroup,
  callback = cleanup_socket,
  desc = "Clean up tmux socket registration",
})

return M