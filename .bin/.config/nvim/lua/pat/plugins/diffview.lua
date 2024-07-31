require('diffview').setup({
  enhanced_diff_hl = true,
  hooks = {
    diff_buf_read = function(bufnr)
      vim.opt_local.wrap = false
      vim.opt_local.list = false
    end,
  },
})
