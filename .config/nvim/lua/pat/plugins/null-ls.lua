local null = require("null-ls")
null.setup({
	sources = {
		null.builtins.formatting.stylua,
		null.builtins.diagnostics.eslint,
		null.builtins.formatting.prettierd,
	},
	-- format on save
	on_attach = function(client)
		if client.resolved_capabilities.document_formatting then
			vim.cmd([[
        augroup LspFormatting
          autocmd! * <buffer>
          autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
        augroup END
      ]])
		end
	end,
})
