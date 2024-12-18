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
  'clangd',
  'cssls',
  'gopls',
  'html',
  'lua_ls',
  'rust_analyzer',
  'ts_ls',
  'vacuum',
  'yamlls',
}

-- Define border chars for hover window
-- ╭─╮
-- │ │
-- ╰─╯
local border = 'rounded'
local utils = require('pat.utils')
local nvim_lsp = require('lspconfig')
local lsp_links = require('lsplinks')
local inlay_hints = require('inlay-hints')
local corn = require('corn')
local navic = require('nvim-navic')
local navbuddy = require('nvim-navbuddy')
local wk = require('which-key')
require('mason').setup({
  ui = {
    border = border,
  },
})
require('mason-lspconfig').setup({ ensure_installed = servers })
require('lspconfig.ui.windows').default_options.border = border
require('fidget').setup({ text = { spinner = 'dots' } })
require('neoconf').setup({})

lsp_links.setup()
inlay_hints.setup({
  -- possible options are dynamic, eol, virtline and custom
  renderer = 'inlay-hints/render/eol',
  only_current_line = true,
})

navbuddy.setup({
  window = {
    border = border,
    sections = {
      -- left = { size = '0%' },
      mid = { size = '40%' },
      right = { preview = 'always' },
    },
  },
  source_buffer = {
    follow_node = false,
  },
})

corn.setup({
  border_style = border,
  icons = {
    error = utils:get_diagnostic_icon('error'),
    warn = utils:get_diagnostic_icon('warn'),
    hint = utils:get_diagnostic_icon('hint'),
    info = utils:get_diagnostic_icon('info'),
  },
  item_preprocess_func = function(item)
    local max_width = vim.api.nvim_win_get_width(0) / 3
    if #item.message > max_width then
      item.message = utils.wrap(item.message, max_width)
    end
    return item
  end,
})

vim.diagnostic.config({
  virtual_text = false,
  -- underline = function(...)
  --   P('UNDERLINE?')
  --   P(...)
  --   return false
  -- end,
})

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

capabilities.textDocument.completion.completionItem =
    vim.tbl_extend('force', capabilities.textDocument.completion.completionItem, {
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
      -- 3/11/24 - Trying these out. Stolen from ray-x/go.nvim readme
      contextSupport = true,
      dynamicRegistration = true,
    })

-- Autoformat on save
require('format-on-save').setup({
  error_notifier = require('format-on-save.error-notifiers.vim-notify'),
  experiments = { disable_restore_cursors = true, partial_update = 'diff' },
  fallback_formatter = { require('format-on-save.formatters').lsp },
})
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local function on_attach(client, bufnr)
  local function buf_set_option(name, value)
    vim.api.nvim_set_option_value(name, value, { buf = bufnr })
  end

  if client.server_capabilities.codeLensProvider then
    local lenses = vim.lsp.codelens.get(bufnr)
    vim.lsp.codelens.display(lenses, bufnr, client.id)
    wk.register({
      ['<leader><leader>a'] = { vim.lsp.codelens.run, 'Run codelens for current line' },
    })

    local lens_group = vim.api.nvim_create_augroup('lsp_document_codelens', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
      callback = function()
        vim.lsp.codelens.refresh({ bufnr = bufnr })
      end,
      buffer = bufnr,
      group = lens_group,
    })
  end

  if vim.tbl_contains({ 'null-ls', 'gopls', 'ts_ls', 'lua_ls' }, client.name) then
    -- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    inlay_hints.on_attach(client, bufnr)
  end

  -- Attach Navic for breadcrumbs
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
    navbuddy.attach(client, bufnr)
  end

  -- Highlighting references
  if client.server_capabilities.document_highlight then
    local hi_group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
    -- local buffer = vim.api.nvim_get_current_buf()
    local buffer = bufnr
    vim.api.nvim_create_autocmd(
      'CursorHold',
      { callback = vim.lsp.buf.document_highlight, buffer = buffer, group = hi_group }
    )
    vim.api.nvim_create_autocmd(
      'CursorMoved',
      { callback = vim.lsp.buf.clear_references, buffer = buffer, group = hi_group }
    )
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { buffer = bufnr, noremap = true, silent = true, mode = { 'n', 'v' } }

  wk.register({
    ['<space>'] = { vim.lsp.buf.hover, 'Show Inline Documentation' },
    ['<leader>'] = {
      ['<leader>v'] = { navbuddy.open, 'Open symbol outline' },
      a = {
        function()
          vim.diagnostic.goto_next({ float = { border = border } })
        end,
        'Go to next issue',
      },
      A = {
        function()
          vim.diagnostic.goto_prev({ float = { border = border } })
        end,
        'Go to previous issue',
      },
      D = { vim.lsp.buf.type_definition, 'Show Type Definition' },
      rn = { vim.lsp.buf.rename, 'Rename Symbol' },
      k = { vim.lsp.buf.signature_help, 'Show Signature Help' },
      f = { vim.lsp.buf.code_action, 'Fix Diagnostic' },
      F = {
        function()
          vim.lsp.buf.format({ async = true })
        end,
        'Autoformat',
      },
      -- F = {
      --   require('format-on-save').format,
      --   'Autoformat',
      -- },
      l = { corn.scope_cycle, 'Toggle line/file diagnostics' },
      x = {
        x = { '<cmd>Trouble diagnostics toggle<cr>', 'Toggle Trouble' },
        w = { '<cmd>Trouble diagnostics open<cr>', 'Workspace Diagnostics' },
        d = { '<cmd>Trouble diagnostics open filter.buf=0<cr>', 'Document Diagnostics' },
        q = { '<cmd>Trouble quickfix<cr>', 'Quickfix' },
        l = { '<cmd>Trouble loclist<cr>', 'Loclist' },
      },
      s = {
        '<cmd>Trouble symbols toggle<cr>',
        'Symbol list',
      },
    },
    g = {
      ['<space>'] = { '<cmd>Trouble inspect toggle pinned=true focus=true<cr>', 'Open symbol inspector' },
      d = { '<cmd>Trouble lsp_definitions<cr>', 'Go to Definition' },
      D = { '<cmd>Trouble lsp_definitions open auto_jump=false<cr>', 'List Definitions in Trouble' },
      i = { '<cmd>Trouble lsp_implementations<cr>', 'Go to Implementation' },
      I = { '<cmd>Trouble lsp_implementations open auto_jump=false<cr>', 'List Implementations in Trouble' },
      r = { '<cmd>Trouble lsp_references<cr>', 'List References in Trouble' },
      R = { '<cmd>Trouble lsp_references open auto_jump=false<cr>', 'List References in Trouble' },
      C = {
        i = { '<cmd>Trouble lsp_incoming_calls<cr>', 'List call sites of the symbol under the cursor' },
        o = {
          '<cmd>Trouble lsp_outgoing_calls<cr>',
          'List the items that are called by the symbol under the cursor',
        },
      },
      x = { lsp_links.gx, 'Open file or documentLink' },
    },
  }, opts)
  -- wk.register(
  --   {
  --     ['<leader>f'] = { function() vim.lsp.buf.code_action({ range = "" }) end, "Fix Diagnostic" },
  --     ['<leader>F'] = { function() vim.lsp.buf.format({ range = "" }) end, "Fix Diagnostic" },
  --   },
  --   { mode = 'v' }
  -- )
end

local handlers = {
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
  ['textDocument/typeDefinition'] = vim.lsp.with(function(_, result, ctx, config)
    local client = assert(vim.lsp.get_client_by_id(ctx.client_id))

    -- if not vim.islist(result) then
    --   result = { result }
    -- end

    local items = vim.lsp.util.locations_to_items(result, client.offset_encoding)
    P('type def: ', result[1])

    if #result == 1 then
      vim.lsp.util.preview_location(result[1], { border = border })
    else
      vim.ui.select(items, {}, P)
    end
  end, {}),
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
  ['gopls'] = function()
    require('lspconfig').gopls.setup({
      handlers = handlers,
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        gopls = {
          experimentalPostfixCompletions = true,
          analyses = {
            useany = true,
            unusedwrite = true,
            unusedvariable = true,
            -- fieldalignment = true,
            shadow = true,
          },
          codelenses = {
            generate = true,
            gc_details = false,
            regenerate_cgo = true,
            tidy = true,
            test = true,
            upgrade_depdendency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          -- linksInHover = true,
          linksInHover = 'gopls',
          hoverKind = 'FullDocumentation',

          semanticTokens = true,
          noSemanticString = true, -- disable semantic string tokens so we can use treesitter highlight injections
        },
      },
    })
  end,
  ['nil_ls'] = function()
    require('lspconfig').nil_ls.setup({
      handlers = handlers,
      on_attach = on_attach,
      capabilities = capabilities,
      flags = { debounce_text_changes = 150 },
      settings = {
        ['nil'] = {
          nix = { flake = { autoArchive = true } },
        },
      },
    })
  end,
  ['rust_analyzer'] = function()
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
      checkOnSave = {
        allFeatures = true,
        overrideCommand = {
          'cargo',
          'clippy',
          '--workspace',
          '--message-format=json',
          '--all-targets',
          '--all-features',
        },
      },
    })
  end,
  ['lua_ls'] = function()
    -- https://github.com/neovim/nvim-lspconfig/issues/2791
    require('lspconfig').lua_ls.setup({
      handlers = handlers,
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          completion = { callSnippet = 'Replace' },
          hint = { enable = true },
        },
      },
    })
  end,
})
