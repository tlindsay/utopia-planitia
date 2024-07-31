-- local mas_reg = require('mason-registry')
--
-- if mas_reg.get_package('llm-ls'):is_installed() then
require('llm').setup({
  model = 'starcoder2',
  url = 'http://localhost:11434/api/generate',
  -- cf https://github.com/ollama/ollama/blob/main/docs/api.md#parameters
  request_body = {
    -- Modelfile options for the model you use
    options = {
      temperature = 0.2,
      top_p = 0.95,
    },
  },

  backend = 'ollama',
  tokens_to_clear = { '<|endoftext|>' },
  fim = {
    enabled = true,
    prefix = '<fim_prefix>',
    middle = '<fim_middle>',
    suffix = '<fim_suffix>',
  },
  context_window = 8192,
  tokenizer = {
    repository = 'bigcode/starcoder2',
  },

  accept_keymap = '<CR>',
  tls_skip_verify_insecure = true,

  enable_suggestions_on_startup = true,
  enable_suggestions_on_files = '*', -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
  -- lsp = {
  --   bin_path = mas_reg.get_package('llm-ls'):get_install_path() .. 'llm-ls-aarch64-apple-darwin',
  -- },
})
-- else
--   vim.notify('LLM-LS not installed. Skipping llm.nvim setup', vim.log.levels.WARN)
-- end
