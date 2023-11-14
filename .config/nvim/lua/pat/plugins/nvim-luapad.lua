require('luapad').setup({
  context = {
    vim = {
      regex = vim.regex,
      print = vim.print,
      inspect = vim.inspect,
    },
  },
})
