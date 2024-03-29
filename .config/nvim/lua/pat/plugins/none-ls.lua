local null = require('null-ls')

null.setup({
  debug = true,
  sources = {
    -- null.builtins.diagnostics.editorconfig_checker,

    null.builtins.diagnostics.vacuum, -- OpenAPI linter

    -- Golang
    -- extra_args doesn't work with staticcheck
    -- default args: `{ "-f", "json", "./..." }`
    -- extra checks: https://staticcheck.io/docs/checks/
    null.builtins.diagnostics.staticcheck.with({
      args = {
        '-f',
        'json',
        '-checks=inherit,ST1003,ST1016',
        './...',
      },
      diagnostics_postprocess = function(d)
        d.severity = d.code == 'ST1003' and vim.diagnostic.severity.HINT
      end,
    }),
    null.builtins.formatting.gofmt,
    null.builtins.formatting.goimports,
    -- 3/21/24: Quit working for some reason? Not detecting missing pkgs even when manually invoked from shell
    -- null.builtins.formatting.goimports_reviser,
    null.builtins.code_actions.gomodifytags,
    null.builtins.code_actions.impl,

    -- Nix
    null.builtins.formatting.alejandra,
    null.builtins.code_actions.statix,
    null.builtins.diagnostics.statix,

    -- Lua
    null.builtins.formatting.stylua,

    -- JS/TS
    require('none-ls.code_actions.eslint_d'),
    require('none-ls.diagnostics.eslint_d').with({
      filter = function(diagnostic)
        -- ignore prettier warnings from eslint-plugin-prettier
        local isPrettier = diagnostic.code == 'prettier/prettier'
        if isPrettier then
          return false
        end

        -- Supress "No ESLint Config" errors
        local hasEslintConfig = (diagnostic.message):find('No ESLint config') == nil
        local isIgnored = (diagnostic.message):find('File ignored') ~= nil
        if not hasEslintConfig or isIgnored then
          return false
        end

        return true
      end,
    }),
    null.builtins.formatting.prettierd.with({
      condition = function(utils)
        return utils.root_has_file('node_modules/.bin/prettier')
      end,
    }),
  },
})

require('mason-null-ls').setup({
  ensure_installed = nil,
  automatic_installation = true,
})
