vim.filetype.add({
  pattern = {
    ['openapi.*%.ya?ml'] = 'yaml.openapi',
    ['*.ya?ml'] = {
      function(path, bufnr)
        local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)
        P(content)
        if vim.regex([[^openapi:]]):match_str(content) ~= nil then
          return 'yaml.openapi'
        end
      end,
    },
  },
})
