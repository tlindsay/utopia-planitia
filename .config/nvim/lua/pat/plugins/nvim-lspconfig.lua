-----------------------------------------------------------
-- Neovim LSP configuration file
-----------------------------------------------------------

-- Plugin: nvim-lspconfig
-- url: https://github.com/neovim/nvim-lspconfig

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches.
-- Add your language server below:
local servers = {
  'bashls',
  'pyright',
  'clangd',
  'cssls',
  'html',
  'eslint_d',
  'gopls',
  'rust_analyzer',
}

-- require('nvim-lsp-installer').setup({
--   ensure_installed = {
--     Moses.append(servers, { 'tsserver', 'ember', 'sumneko_lua' }),
--   },
-- })

local nvim_lsp = require('lspconfig')
local lines = require('lsp_lines')
local wk = require('which-key')
require('mason').setup()
require('mason-lspconfig').setup({ ensure_installed = servers })
require('fidget').setup({ text = { spinner = 'dots' } })

lines.setup()
vim.diagnostic.config({ virtual_text = false })
vim.diagnostic.config({ virtual_lines = { only_current_line = true } })

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem = vim.tbl_extend(
  'force',
  capabilities.textDocument.completion.completionItem,
  {
    documentationFormat = { 'markdown', 'plaintext' },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      },
    },
  }
)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Highlighting references
  if client.server_capabilities.document_highlight then
    local hi_group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
    local buffer = vim.api.nvim_get_current_buf()
    vim.api.nvim_create_autocmd(
      'CursorHold',
      { callback = vim.lsp.buf.document_highlight, buffer = buffer, group = hi_group }
    )
    vim.api.nvim_create_autocmd(
      'CursorMoved',
      { callback = vim.lsp.buf.clear_references, buffer = buffer, group = hi_group }
    )
  end

  -- Autoformat on save
  if client.server_capabilities.document_formatting then
    local group = vim.api.nvim_create_augroup('LspFormatting', { clear = true })
    local buffer = vim.api.nvim_get_current_buf()
    vim.api.nvim_create_autocmd('BufWritePre', {
      callback = function()
        if vim.api.nvim_get_var('PAT_format_on_save') then
          -- vim.lsp.buf.formatting_sync({}, 5000)
          vim.lsp.buf.format({ timeout_ms = 5000 })
        end
      end,
      group = group,
      buffer = buffer,
    })
  end
  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { buffer = bufnr, noremap = true, silent = true }

  wk.register({
    ['<space>'] = { vim.lsp.buf.hover, 'Show Inline Documentation' },
    ['<leader>'] = {
      a = { vim.diagnostic.goto_next, 'Go to next issue' },
      A = { vim.diagnostic.goto_prev, 'Go to previous issue' },
      D = { vim.lsp.buf.type_definition, 'Show Type Definition' },
      rn = { vim.lsp.buf.rename, 'Rename Symbol' },
      k = { vim.lsp.buf.signature_help, 'Show Signature Help' },
      f = { vim.lsp.buf.code_action, 'Fix Diagnostic' },
      F = { vim.lsp.buf.format, 'Autoformat' },
      l = {
        function()
          local vtext = vim.diagnostic.config().virtual_text
          local vline = vim.diagnostic.config().virtual_lines
          vim.diagnostic.config({ virtual_text = not vtext })
          if vline then
            vim.diagnostic.config({ virtual_lines = false })
          else
            vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
          end
        end,
        'Toggle LSP Lines',
      },
      s = { '<cmd>Telescope lsp_document_symbols<CR>', 'Open symbol selector' },
      x = {
        name = 'Trouble',
        x = { '<cmd>TroubleToggle<cr>', 'Toggle Trouble' },
        w = { '<cmd>TroubleToggle workspace_diagnostics<cr>', 'Workspace Diagnostics' },
        d = { '<cmd>TroubleToggle document_diagnostics<cr>', 'Document Diagnostics' },
        q = { '<cmd>TroubleToggle quickfix<cr>', 'Quickfix' },
        l = { '<cmd>TroubleToggle loclist<cr>', 'Loclist' },
      },
    },
    g = {
      D = { vim.lsp.buf.type_definition, 'Go to Type Definition' },
      d = { vim.lsp.buf.definition, 'Go to Definition' },
      i = { vim.lsp.buf.implementation, 'Go to Implementation' },
      I = { '<cmd>vsp | lua vim.lsp.buf.definition()<CR>', 'Split to Implementation' },
      r = { vim.lsp.buf.references, 'List References' },
      R = { '<cmd>TroubleToggle lsp_references<cr>', 'List References in Trouble' },
    },
  }, opts)
end

-- Define border chars for hover window
-- ╭─╮
-- │ │
-- ╰─╯
local border = {
  { '╭', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '╮', 'FloatBorder' },
  { '│', 'FloatBorder' },
  { '╯', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '╰', 'FloatBorder' },
  { '│', 'FloatBorder' },
}
local handlers = {
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}
--[[=========================
    == CUSTOM SERVER CONFIGS
    ========================= ]]
require('mason-lspconfig').setup_handlers({
  function(server_name)
    nvim_lsp[server_name].setup({
      handlers = handlers,
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      },
    })
  end,
  ['rust_analyzer'] = function()
    -- local tools = {
    --   autoSetHints = true,
    --   runnables = { use_telescope = true },
    --   inlay_hints = { show_parameter_hints = true },
    --   hover_actions = { border = border, auto_focus = true },
    -- }
    -- local rt = require('rust-tools')
    -- rt.setup({
    --   tools = tools,
    --   server = {
    --     on_attach = function(client, bufnr)
    --       on_attach(client, bufnr)
    --       wk.register({
    --         ['<space>'] = { rt.hover_actions.hover_actions, 'Rust Tools Hover Actions' },
    --       }, { buf = bufnr })
    --     end,
    --     capabilities = capabilities,
    --     flags = { debounce_text_changes = 150 },
    --   },
    -- })
    local rustCapabilities = vim.lsp.protocol.make_client_capabilities()

    -- snippets
    rustCapabilities.textDocument.completion.completionItem.snippetSupport = true

    -- send actions with hover request
    rustCapabilities.experimental = {
      hoverActions = true,
      hoverRange = true,
      serverStatusNotification = true,
      snippetTextEdit = true,
      codeActionGroup = true,
      ssr = true,
    }

    -- enable auto-import
    rustCapabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = { 'documentation', 'detail', 'additionalTextEdits' },
    }

    -- rust analyzer goodies
    rustCapabilities.experimental.commands = {
      commands = {
        'rust-analyzer.runSingle',
        'rust-analyzer.debugSingle',
        'rust-analyzer.showReferences',
        'rust-analyzer.gotoLocation',
        'editor.action.triggerParameterHints',
      },
    }

    rustCapabilities = vim.tbl_deep_extend('keep', rustCapabilities, capabilities or {})

    require('lspconfig').rust_analyzer.setup({
      handlers = handlers,
      capabilities = rustCapabilities,
      on_attach = on_attach,
    })
  end,
  ['tsserver'] = function()
    local ts_utils = require('nvim-lsp-ts-utils')
    require('lspconfig').tsserver.setup({
      handlers = handlers,
      init_options = ts_utils.init_options,
      on_attach = function(client, bufnr)
        -- Use null-ls for formatting instead of builtin
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false

        on_attach(client, bufnr)

        ts_utils.setup({
          enable_import_on_completion = true,
          auto_inlay_hints = false,
        })
        ts_utils.setup_client(client)
        -- Mappings.
        local opts = { buffer = bufnr, noremap = true, silent = true }
        wk.register({
          g = {
            name = 'TS Utils',
            s = { '<cmd>TSLspOrganize<CR>', 'Organize imports' },
            rn = { '<cmd>TSLspRenameFile<CR>', 'Rename file' },
            m = { '<cmd>TSLspImportAll<CR>', 'Add missing imports' },
          },
        }, opts)
      end,
    })
  end,
  ['ember'] = function()
    require('lspconfig').ember.setup({
      handlers = handlers,
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      },
      root_dir = require('lspconfig.util').root_pattern('.ember-cli'),
    })
  end,
  ['sumneko_lua'] = function()
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')
    require('lspconfig').sumneko_lua.setup({
      handlers = handlers,
      on_attach = function(client, bufnr)
        -- Use null-ls for formatting instead of builtin
        client.server_capabilities.diagnostics = false
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false

        on_attach(client, bufnr)
      end,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Setup your lua path
            path = runtime_path,
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim', 'use', 'lvim', 'use_rocks' },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file('~/.config/nvim/**/*.lua', true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    })
  end,
  ['emmet_ls'] = function()
    require('lspconfig').emmet_ls.setup({
      capabilities = capabilities,
      filetypes = {
        'html',
        'typescriptreact',
        'javascriptreact',
        'css',
        'sass',
        'scss',
        'less',
        'hbs',
      },
    })
  end,
})

-- local function setup_rust_tools()
--   local tools = {
--     autoSetHints = true,
--     runnables = { use_telescope = true },
--     inlay_hints = { show_parameter_hints = true },
--     hover_actions = { auto_focus = true },
--   }
--   require('rust-tools').setup({
--     tools = tools,
--     server = {
--       on_attach = on_attach,
--       capabilities = capabilities,
--       flags = { debounce_text_changes = 150 },
--     },
--   })
--   require('rust-tools-debug').setup()
-- end
--
-- pcall(setup_rust_tools)
