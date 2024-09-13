local null = require('null-ls')
local customSources = require('pat.plugins/none-ls.custom')
local sevs = vim.diagnostic.severity

-- local gotest = require('go.null_ls').gotest()
-- local gotest_codeaction = require('go.null_ls').gotest_action()

null.setup({
  debug = false,
  log_level = 'debug',
  sources = {

    -- Misc
    null.builtins.diagnostics.trail_space,
    null.builtins.diagnostics.editorconfig_checker.with({
      diagnostics_postprocess = function(d)
        d.severity = sevs.HINT
        return d
      end,
    }),
    null.builtins.code_actions.refactoring,
    -- null.builtins.code_actions.ts_node_action,
    null.builtins.code_actions.gitrebase,
    null.builtins.code_actions.gitsigns,

    -- Shell
    null.builtins.formatting.shellharden,
    null.builtins.formatting.shfmt,

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
        -- Set [Style Issues](https://staticcheck.io/docs/checks/#ST1) sev to HINT
        if string.match(d.code, 'ST1%d+') then
          d.severity = sevs.HINT
        end

        if d.end_row < d.row then
          d.end_row = d.row
        end
        if d.end_lnum < d.lnum then
          d.end_lnum = d.lnum
        end
        if d.end_col < d.col then
          local line = vim.fn.getline(d.row)
          local _, _, word_end = unpack(vim.fn.matchstrpos(line, [[\k*\%]] .. d.col + 1 .. [[c\k*]]))
          d.end_col = word_end
        end

        return d
      end,
    }),
    null.builtins.formatting.gofmt,
    null.builtins.formatting.goimports,
    null.builtins.formatting.goimports_reviser,
    null.builtins.code_actions.gomodifytags,
    null.builtins.code_actions.impl,
    -- customSources.code_actions.gotests,
    customSources.code_actions.gotests_TS,

    -- gotest,
    -- gotest_codeaction,

    -- SQL
    null.builtins.diagnostics.sqlfluff.with({
      extra_args = { '--dialect', 'clickhouse' },
    }),
    null.builtins.formatting.sqlfmt,

    -- jq
    null.builtins.formatting.jq,

    -- Lua
    null.builtins.formatting.stylua,

    -- Nix
    null.builtins.formatting.alejandra,
    null.builtins.code_actions.statix,
    null.builtins.diagnostics.deadnix,
    null.builtins.diagnostics.statix,

    -- OpenAPI
    -- Try using yaml.openapi filetype - 04/02/2024
    null.builtins.diagnostics.vacuum, -- OpenAPI linter
    null.builtins.diagnostics.yamllint.with({
      extra_args = {
        '-d',
        '{extends: relaxed, rules: {line-length: {max: 120}, document-start: disable}}',
      },
    }),
    null.builtins.formatting.yamlfmt,

    -- customSources.spectral.with({
    --   prefer_local = 'node_modules/.bin',
    --   filter = function(d)
    --     return d.code ~= 'unrecognized-format'
    --   end,
    -- }),

    -- JS/TS
    require('none-ls.code_actions.eslint_d'),
    require('none-ls.diagnostics.eslint_d').with({
      filter = function(diagnostic)
        local shouldSkip = {
          (diagnostic.code == 'prettier/prettier'),
          (diagnostic.message:find('No ESLint config') ~= nil),
          (diagnostic.message:find('File ignored') ~= nil),
        }
        -- If any `shouldSkip` rule is true, return false for `filter`
        return not vim.iter(shouldSkip):any(function(r)
          return r
        end)
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
