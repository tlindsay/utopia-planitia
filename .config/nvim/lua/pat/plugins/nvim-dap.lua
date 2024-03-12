local wk = require('which-key')
local dap = require('dap')
local dapui = require('dapui')
dapui.register_element('terminal')
dapui.setup({
  layouts = {
    {
      elements = {
        {
          id = 'scopes',
          size = 0.25,
        },
        {
          id = 'breakpoints',
          size = 0.25,
        },
        {
          id = 'stacks',
          size = 0.25,
        },
        {
          id = 'watches',
          size = 0.25,
        },
      },
      position = 'left',
      size = 40,
    },
    {
      elements = {
        {
          id = 'repl',
          size = 0.5,
          -- size = 1.0,
        },
        --[[ {
          id = 'terminal',
          size = 0.5,
        }, ]]
        {
          id = 'console',
          size = 0.5,
        },
      },
      position = 'bottom',
      size = 10,
    },
  },
})
local dapui_augroup = vim.api.nvim_create_augroup('dapui_ft_overrides', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dapui_*',
  desc = 'Suppress modified flags for DAPUI bufs',
  callback = function(ev)
    vim.api.nvim_buf_set_option(ev.buf, 'buftype', 'nofile')
  end,
  group = dapui_augroup,
})
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
-- dap.listeners.before.event_terminated.dapui_config = function()
--   dapui.close()
-- end
-- dap.listeners.before.event_exited.dapui_config = function()
--   dapui.close()
-- end

require('nvim-dap-virtual-text').setup()

local dapgo = require('dap-go')
dapgo.setup({
  -- delve = {
  --   -- args = { '--log' },
  -- },
})

dap.adapters.chrome = {
  type = 'executable',
  command = 'node',
  args = {
    os.getenv('HOME') .. '/.local/share/nvim/site/pack/packer/start/vscode-chrome-debug/out/src/chromeDebug.js',
  },
}
dap.adapters.firefox = {
  type = 'executable',
  command = 'node',
  args = {
    os.getenv('HOME') .. '/.local/share/nvim/site/pack/packer/start/vscode-chrome-debug/out/src/chromeDebug.js',
  },
}

dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = os.getenv('HOME') .. '/.local/share/nvim/mason/bin/codelldb',
    args = { '--port', '${port}' },
  },
}
dap.configurations.rust = {
  {
    name = 'Launch file',
    type = 'codelldb',
    request = 'launch',
    program = function()
      return coroutine.create(function(dapco)
        vim.ui.select(vim.fn.systemlist('fd -tx --no-ignore'), {
          prompt = 'Select an executable',
          kind = 'file',
        }, function(choice)
          coroutine.resume(dapco, choice)
        end)
      end)
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}
dap.configurations.cpp = dap.configurations.rust
dap.configurations.c = dap.configurations.cpp

dap.configurations.typescriptreact = { -- change to typescript if needed
  {
    type = 'chrome',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    url = 'http://localhost:3000',
    port = 9222,
    webRoot = '${workspaceFolder}',
  },
}
dap.configurations.javascript = { -- change to typescript if needed
  {
    type = 'chrome',
    request = 'launch',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    url = 'http://localhost:4200/tests?hidepassed',
    port = 9222,
    webRoot = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome --remote-debugging-port=9222',
  },
  -- {
  --   type = 'chrome',
  --   request = 'attach',
  --   program = '${file}',
  --   cwd = vim.fn.getcwd(),
  --   sourceMaps = true,
  --   protocol = 'inspector',
  --   port = 9222,
  --   webRoot = '${workspaceFolder}',
  -- },
}

-- dap.configurations.go = {
--   { type = 'go' },
-- }
--
wk.register({
  ['<leader>d'] = {
    d = { dapui.toggle, 'Toggle DAP UI' },
    b = { dap.toggle_breakpoint, 'Toggle breakpoint' },
    B = {
      function()
        vim.ui.select({ 'log', 'condition', 'exception' }, {
          prompt = 'Set (l)og message, (c)onditional breakpoint or e(x)ception filters?',
        }, function(choice)
          if choice == 'log' then
            vim.ui.input({ prompt = 'Log point message: ' }, function(input)
              dap.set_breakpoint(nil, nil, input)
            end)
          elseif choice == 'condition' then
            vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(input)
              dap.set_breakpoint(input)
            end)
          elseif choice == 'exception' then
            print('TODO')
          else
            vim.notify('Invalid choice', vim.log.levels.ERROR)
          end
        end)
      end,
      'Set special breakpoint',
    },
    X = { dap.clear_breakpoints, 'DAP Clear all breakpoints' },
    c = { dap.continue, 'DAP Continue' },
    C = { dap.reverse_continue, 'DAP Reverse continue' },
    i = { dap.step_into, 'DAP Step into' },
    o = { dap.step_over, 'DAP Step over' },
    O = { dap.step_out, 'DAP Step out' },
    r = { dap.restart_frame, 'DAP Restart frame' },
    R = { dap.restart, 'DAP Restart execution' },
    S = { dap.terminate, 'DAP Stop' },
    h = { require('dap.ui.widgets').hover, 'DAP Hover' },
    p = { require('dap.ui.widgets').preview, 'DAP Preview' },
    t = {
      function()
        local success = dapgo.debug_test()
        if success == false then
          success = dapgo.debug_last_test()
        end
        if success == false then
          ---@diagnostic disable-next-line: undefined-global
          vim.notify('Could not find Go test to debug', vim.log.levels.ERROR)
        end
      end,
      'DAP-Go Debug Test',
    },
  },
})
