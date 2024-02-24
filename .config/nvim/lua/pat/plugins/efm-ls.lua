local alejandra = require('efmls-configs.formatters.alejandra')
local statix = require('efmls-configs.linters.statix')
local eslint = require('efmls-configs.linters.eslint_d')
local eslint_formatter = require('efmls-configs.formatters.eslint_d')
local prettier = require('efmls-configs.formatters.prettier_d')
local stylua = require('efmls-configs.formatters.stylua')
local golangci_lint = require('efmls-configs.linters.golangci_lint')
local gofmt = require('efmls-configs.formatters.gofmt')
local goimports = require('efmls-configs.formatters.goimports')

local es_tools = {
  eslint,
  eslint_formatter,
  prettier,
}

local languages = {
  typescript = es_tools,
  typescriptreact = es_tools,
  javascript = es_tools,
  javascriptreact = es_tools,
  go = {
    -- golangci_lint,
    gofmt,
    goimports,
  },
  lua = { stylua },
  nix = { alejandra, statix },
}

return {
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { '.git/' },
    languages = languages,
  },
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
}
