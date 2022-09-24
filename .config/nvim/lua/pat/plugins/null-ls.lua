local null = require('null-ls')
-- local prettierPath = vim.cmd([[echo exepath]])
null.setup({
  debug = true,
  sources = {
    null.builtins.code_actions.eslint_d,

    -- DIAGNOSTICS
    null.builtins.diagnostics.commitlint,
    null.builtins.diagnostics.luacheck,
    null.builtins.diagnostics.tsc,
    null.builtins.diagnostics.zsh,
    null.builtins.diagnostics.eslint_d.with({
      filter = function(diagnostic)
        -- ignore prettier warnings from eslint-plugin-prettier
        local isPrettier = diagnostic.code == 'prettier/prettier'
        if isPrettier then
          return false
        end

        -- Supress "No ESLint Config" errors
        local hasEslintConfig = (diagnostic.message):find('No ESLint config') == nil
        if not hasEslintConfig then
          return false
        end

        return true
      end,
    }),

    -- FORMATTERS
    null.builtins.formatting.gofmt,
    null.builtins.formatting.stylua,
    null.builtins.formatting.eslint_d,
    null.builtins.formatting.prettierd.with({
      condition = function(utils)
        return utils.root_has_file('node_modules/.bin/prettier')
      end,
    }),
  },
  -- format on save
  on_attach = function(client, bufnr)
    -- if client.server_capabilities.document_formatting then
    if client.server_capabilities.documentFormattingProvider then
      local group = vim.api.nvim_create_augroup('LspFormatting', { clear = true })
      -- local buffer = vim.api.nvim_get_current_buf()
      vim.api.nvim_create_autocmd('BufWritePre', {
        callback = function()
          if vim.api.nvim_get_var('PAT_format_on_save') then
            -- vim.lsp.buf.formatting_sync({}, 5000)
            vim.api.nvim_echo({ { 'Trying to format' } }, true, {})
            vim.lsp.buf.format({
              bufnr = bufnr,
              -- timeout_ms = 5000,
              -- filter = function(c) -- Only use null-ls for formatting
              --   return c.name == 'null-ls'
              -- end,
            })
          end
        end,
        group = group,
        buffer = bufnr,
      })
    end
  end,
})
