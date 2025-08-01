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
local conform = require('conform')
local corn = require('corn')
local lsp_lines = require('lsp_lines')
local navic = require('nvim-navic')
local navbuddy = require('nvim-navbuddy')
local wk = require('which-key')
require('mason').setup({
  ui = {
    border = border,
  },
})
require('mason-lspconfig').setup({ automatic_installation = false, ensure_installed = servers })
require('lspconfig.ui.windows').default_options.border = border
require('fidget').setup({})
require('neoconf').setup({})

local toggleAutoformat = function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
end
conform.setup({
  formatters_by_ft = {
    go = { 'goimports', 'goimports-reviser', 'gofmt' },
    lua = { 'stylua' },
    sql = { 'sqruff' },
    nix = { 'alejandra' },
    yaml = { 'yamlfmt' },
    javascript = { 'prettierd' },
  },
  format_after_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { async = true, lsp_format = 'fallback' }
  end,
})

lsp_lines.setup()
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
  scope = 'line',
  on_toggle = function(is_visible)
    if not is_visible then
      vim.diagnostic.config({ virtual_lines = { highlight_whole_line = false, only_current_line = true } })
    else
      vim.diagnostic.config({ virtual_lines = false })
    end
  end,
})

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = false,
  float = false,
})

-- Add additional capabilities supported by blink-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())

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

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local function on_attach(client, bufnr)
  local function buf_set_option(name, value)
    vim.api.nvim_set_option_value(name, value, { buf = bufnr })
  end

  if client.server_capabilities.codeLensProvider then
    local lenses = vim.lsp.codelens.get(bufnr)
    vim.lsp.codelens.display(lenses, bufnr, client.id)
    wk.add({
      { '<leader><leader>a', vim.lsp.codelens.run, { group = 'LSP', desc = 'Run codelens for current line' } },
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

  wk.add({
    mode = { 'n', 'v' },
    group = 'LSP',
    {
      '<space>',
      vim.lsp.buf.hover,
      desc = 'Show Inline Documentation',
    },
    {
      '<leader><leader>v',
      navbuddy.open,
      desc = 'Open symbol outline',
    },
    {
      '<leader>a',
      function()
        vim.diagnostic.jump({ count = 1, float = { border = border } })
      end,
      desc = 'Go to next issue',
    },
    {
      '<leader>A',
      function()
        vim.diagnostic.jump({ count = -1, float = { border = border } })
      end,
      desc = 'Go to previous issue',
    },
    {
      '<leader>D',
      vim.lsp.buf.type_definition,
      desc = 'Show Type Definition',
    },
    {
      '<leader>rn',
      vim.lsp.buf.rename,
      desc = 'Rename Symbol',
    },
    {
      '<leader>k',
      vim.lsp.buf.signature_help,
      desc = 'Show Signature Help',
    },
    {
      '<leader>f',
      vim.lsp.buf.code_action,
      desc = 'Fix Diagnostic',
    },
    {
      '<leader>F',
      function()
        conform.format({ async = true, lsp_format = 'fallback' })
      end,
      desc = 'Autoformat',
    },
    {
      '<leader><leader>f',
      toggleAutoformat,
      desc = 'Toggle format-on-save',
    },
    {
      '<leader>l',
      corn.toggle,
      desc = 'Toggle line/floating diagnostics',
    },
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Toggle Trouble',
    },
    {
      '<leader>xw',
      '<cmd>Trouble diagnostics open<cr>',
      desc = 'Workspace Diagnostics',
    },
    {
      '<leader>xd',
      '<cmd>Trouble diagnostics open filter.buf=0<cr>',
      desc = 'Document Diagnostics',
    },
    {
      '<leader>xq',
      '<cmd>Trouble quickfix<cr>',
      desc = 'Quickfix',
    },
    {
      '<leader>xl',
      '<cmd>Trouble loclist<cr>',
      desc = 'Loclist',
    },
    {
      '<leader>s',
      '<cmd>Trouble symbols toggle<cr>',
      desc = 'Symbol list',
    },
    {
      'g<space>',
      '<cmd>Trouble inspect toggle pinned=true focus=true<cr>',
      desc = 'Open symbol inspector',
    },
    {
      'gd',
      '<cmd>Trouble lsp_definitions<cr>',
      desc = 'Go to Definition',
    },
    {
      'gld',
      '<cmd>Trouble lsp_definitions open auto_jump=false<cr>',
      desc = 'List Definitions in Trouble',
    },
    {
      'gD',
      '<cmd>Trouble lsp_definitions open auto_jump=false<cr>',
      desc = 'List Definitions in Trouble',
    },
    {
      'gi',
      '<cmd>Trouble lsp_implementations<cr>',
      desc = 'Go to Implementation',
    },
    {
      'gli',
      '<cmd>Trouble lsp_implementations open auto_jump=false<cr>',
      desc = 'List Implementations in Trouble',
    },
    {
      'gI',
      '<cmd>Trouble lsp_implementations open auto_jump=false<cr>',
      desc = 'List Implementations in Trouble',
    },
    {
      'gr',
      '<cmd>Trouble lsp_references<cr>',
      desc = 'List References in Trouble',
    },
    {
      'glr',
      '<cmd>Trouble lsp_references open auto_jump=false<cr>',
      desc = 'List References in Trouble',
    },
    {
      'gR',
      '<cmd>Trouble lsp_references open auto_jump=false<cr>',
      desc = 'List References in Trouble',
    },
    {
      'glI',
      '<cmd>Trouble lsp_incoming_calls open auto_jump=false<cr>',
      desc = 'List call sites of the symbol under the cursor',
    },
    {
      'gCi',
      '<cmd>Trouble lsp_incoming_calls open auto_jump=true<cr>',
      desc = 'Go to call site of the symbol under the cursor',
    },
    {
      'glO',
      '<cmd>Trouble lsp_outgoing_calls<cr>',
      desc = 'List the items that are called by the symbol under the cursor',
    },
    {
      'gCo',
      '<cmd>Trouble lsp_outgoing_calls<cr>',
      desc = 'List the items that are called by the symbol under the cursor',
    },
    {
      'gx',
      lsp_links.gx,
      desc = 'Open file or documentLink',
    },
  }, opts)
end

local handlers = {
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
  ['textDocument/typeDefinition'] = vim.lsp.with(function(_, result, ctx, config)
    local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
    local items = vim.lsp.util.locations_to_items(result, client.offset_encoding)

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
            modernize = true,
            useany = true,
            unusedfunc = true,
            unusedwrite = true,
            unusedvariable = true,
            -- fieldalignment = true,
            shadow = true,
          },
          codelenses = {
            generate = true,
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

          semanticTokenTypes = { string = false }, -- disable semantic string tokens so we can use treesitter highlight injections
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
      settings = {
        ['rust-analyzer'] = {
          diagnostics = {
            enable = true,
            styleLints = { enable = true },
            disabled = {
              'unlinked-file',
            },
          },
          checkOnSave = true,
          check = {
            overrideCommand = {
              'cargo',
              'clippy',
              '--workspace',
              '--message-format=json',
              '--all-targets',
              '--all-features',
            },
          },
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
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if
            path ~= vim.fn.stdpath('config')
            and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc'))
          then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              -- Depending on the usage, you might want to add additional paths here.
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            },
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
            -- library = vim.api.nvim_get_runtime_file("", true)
          },
        })
      end,
      settings = {
        Lua = {
          completion = { callSnippet = 'Replace' },
          hint = { enable = true },
        },
      },
    })
  end,
})
