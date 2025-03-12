local null = require('null-ls')
local customSources = require('pat.plugins/none-ls.custom')
local sevs = vim.diagnostic.severity

null.setup({
  debug = false,
  log_level = 'debug',
  sources = {

    -- Misc
    null.builtins.code_actions.refactoring,
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

        -- Prevent ST1003 from flagging a whole file just bc of pkg name
        if d.code == 'ST1003' then
          d.end_row = d.row + 1
          if d.lnum == 0 then
            d.end_lnum = 1
          else
            d.end_lnum = d.lnum
          end
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
    null.builtins.formatting.goimports_reviser.with({
      extra_args = { '-company-prefixes', 'github.com/fastly', '-set-alias', '-use-cache' },
    }),
    null.builtins.code_actions.gomodifytags,
    null.builtins.code_actions.impl,

    -- SQL
    null.builtins.diagnostics.sqruff,
    null.builtins.formatting.sqruff,

    -- Lua
    null.builtins.formatting.stylua,

    -- Nix
    null.builtins.formatting.alejandra,
    null.builtins.code_actions.statix,
    null.builtins.diagnostics.deadnix,
    null.builtins.diagnostics.statix,

    -- OpenAPI
    null.builtins.diagnostics.yamllint.with({
      extra_args = {
        '-d',
        '{extends: relaxed, rules: {line-length: {max: 120}, document-start: disable}}',
      },
    }),
    null.builtins.formatting.yamlfmt,

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
  ensure_installed = {},
  automatic_installation = true,
})
