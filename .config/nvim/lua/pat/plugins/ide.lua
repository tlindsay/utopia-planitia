require('ide').setup({
  mappings = {
    ['<F5>'] = function(project)
      if project:is_busy() and not project:has_state('debug') then
        return
      end

      project:debug()
    end,

    ['<F7>'] = function(project)
      if project:has_state('debug') then
        project:debug({ type = 'stepinto' })
      else
        vim.api.nvim_command(':NeoTreeShowToggle')
      end
    end,

    ['<F8>'] = function(project)
      if project:has_state('debug') then
        project:debug({ type = 'stepover' })
      else
        project:build()
      end
    end,

    ['<C-F5>'] = function(project)
      if not project:has_state('run') then
        project:run()
      end
    end,

    ['<C-F8>'] = function(project)
      project:settings()
    end,

    ['<A-F5>'] = function(project)
      if project:has_state('debug') then
        project:debug({ type = 'stop' })
      end
    end,

    ['<A-BS>'] = function(project)
      if project:is_busy() and not project:has_state('debug') then
        project:stop()
      end
    end,
  },

  integrations = {
    dap = {
      enable = true,
      adapters = {
        rust = {
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
        },
      },
    },
    dapui = {
      enable = true,
    },
  },
})
