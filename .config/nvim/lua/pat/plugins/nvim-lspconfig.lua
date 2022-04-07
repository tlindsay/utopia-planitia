-----------------------------------------------------------
-- Neovim LSP configuration file
-----------------------------------------------------------

-- Plugin: nvim-lspconfig
-- url: https://github.com/neovim/nvim-lspconfig

local nvim_lsp = require('lspconfig')
local wk = require('which-key')

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Highlighting references
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { buffer = bufnr, noremap = true, silent = true }

  wk.register({
    ['<space>'] = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'Show Inline Documentation' },
    ['<leader>'] = {
      a = { '<cmd>lua vim.diagnostic.goto_next()<CR>', 'Go to next issue' },
      z = { '<cmd>lua vim.diagnostic.goto_prev()<CR>', 'Go to previous issue' },
      D = { '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Show Type Definition' },
      rn = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename Symbol' },
      f = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Fix Diagnostic' },
      F = { '<cmd>lua vim.lsp.buf.formatting()<CR>', 'Autoformat' },
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
      D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Go to Declaration' },
      d = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'Go to Definition' },
      i = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Go to Implementation' },
      I = { '<cmd>vsp | lua vim.lsp.buf.implementation()<CR>', 'Split to Implementation' },
      r = { '<cmd>lua vim.lsp.buf.references()<CR>', 'List References' },
      R = { '<cmd>TroubleToggle lsp_references<cr>', 'List References in Trouble' },
    },
  }, opts)
  -- local troubleGroup = vim.api.nvim_create_augroup("TroubleWindow", { clear = true })
  -- api.nvim_create_autocmd("BindTroubleToggle", {
  --   command = "nmap <leader>xx :TroubleToggle<CR>",
  --   group = troubleGroup
  -- })
  vim.cmd([[
    augroup TroubleWindow
      au!
      autocmd FileType Trouble map <buffer><silent> <leader>xx :TroubleToggle<CR>
    augroup END
  ]])

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  -- buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- -- buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  -- buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  -- buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  -- -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  -- -- buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

--[[

Language servers setup:

For language servers list see:
https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

Bash --> bashls
https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#bashls

Python --> pyright
https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright

C-C++ -->  clangd
https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#clangd

HTML/CSS/JSON --> vscode-html-languageserver
https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#html

JavaScript/TypeScript --> tsserver
https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tsserver

--]]

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches.
-- Add your language server below:
local servers = { 'bashls', 'pyright', 'clangd', 'html', 'eslint', 'gopls' }

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
  -- ["textDocument/implementation"] = vim.lsp.with(
  --   vim.lsp.handlers.location, {
  --     location_callback = function(location)
  --       vim.cmd [[vsplit]]
  --       vim.lsp.util.jump_to_location(location)
  --     end
  --   }
  -- )
}

-- Call setup
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup({
    handlers = handlers,
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  })
end

local ts_utils = require('nvim-lsp-ts-utils')
require('lspconfig').tsserver.setup({
  handlers = handlers,
  init_options = ts_utils.init_options,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)

    -- Use null-ls for formatting instead of builtin
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

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
        -- I = {'<cmd>TSLspImportAll<CR>', 'Add missing imports'}
      },
    })
  end,
})
require('lspconfig').ember.setup({
  handlers = handlers,
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  root_dir = require('lspconfig.util').root_pattern('.ember-cli'),
})
