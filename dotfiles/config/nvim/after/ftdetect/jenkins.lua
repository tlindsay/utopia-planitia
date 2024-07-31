local group = vim.api.nvim_create_augroup('SetJenkinsFiletype', { clear = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufEnter', 'BufNewFile' }, {
  group = group,
  pattern = {
    'Jenkinsfile',
    'Jenkinsfile*',
    '*.jenkinsfile',
    '*.Jenkinsfile',
  },
  callback = function()
    vim.bo.filetype = 'groovy'
  end,
})

