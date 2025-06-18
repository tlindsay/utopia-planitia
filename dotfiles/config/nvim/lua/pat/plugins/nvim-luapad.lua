require('luapad').setup({
  context = {
    P = P,
    vim = {
      api = vim.api,
      fn = vim.fn,
      regex = vim.regex,
      print = vim.print,
      inspect = vim.inspect,
    },
    tbl = {
      contains = vim.tbl_contains,
      count = vim.tbl_count,
      deep_extend = vim.tbl_deep_extend,
      extend = vim.tbl_extend,
      filter = vim.tbl_filter,
      get = vim.tbl_get,
      is_empty = vim.tbl_is_empty,
      is_list = vim.tbl_is_list,
      keys = vim.tbl_keys,
      map = vim.tbl_map,
      values = vim.tbl_values,
    },
  },
})
