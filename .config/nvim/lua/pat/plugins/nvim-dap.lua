local wk = require('which-key')
local dap = require('dap')
local dapui = require('dapui')
dapui.setup()
local dapgo = require('dap-go')
dapgo.setup()

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
        dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end,
      'Set conditional breakpoint',
    },
    c = { dap.continue, 'DAP Continue' },
    i = { dap.step_into, 'DAP Step into' },
    o = { dap.step_over, 'DAP Step over' },
    O = { dap.step_out, 'DAP Step out' },
    t = { dapgo.debug_test, 'DAP-Go Debug Test' },
  },
})
