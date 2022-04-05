local wk = require("which-key")

vim.cmd([[
  let test#javascript#reactscripts#options = "--watchAll=false"
]])

vim.g.ultest_running_sign = ""
vim.g.ultest_not_run_sign = ""
vim.g.ultest_pass_sign = ""
vim.g.ultest_fail_sign = ""

wk.register({
  ["<leader>"] = {
    t = {
      name = "Tests",
      t = { "<cmd>UltestSummary<CR>", "Open testing panel" },
      f = { "<cmd>Ultest<CR>", "Test file" },
      n = { "<cmd>UltestNearest<CR>", "Run nearest test" },
      x = { "<cmd>UltestClear<CR>", "Clear test results" },
    },
  },
})
