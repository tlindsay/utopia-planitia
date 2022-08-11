local neotest = require('neotest')
local wk = require('which-key')

neotest.setup({
  adapters = {
    require('neotest-jest'),
    require('neotest-go'),
  },
  icons = {
    passed = '﫟',
    running = '喇',
    skipped = 'ﭠ',
    failed = '',
    unknown = '',
  },
})

-- vim.cmd([[
--   let test#javascript#reactscripts#options = "--watchAll=false"
--   let test#javascript#jest#options = "--color=always"
-- ]])

vim.g.ultest_running_sign = ''
vim.g.ultest_not_run_sign = ''
vim.g.ultest_pass_sign = ''
vim.g.ultest_fail_sign = ''

wk.register({
  ['<leader>'] = {
    t = {
      name = 'Tests',
      t = { neotest.summary.toggle, 'Open testing panel' },
      f = {
        function()
          neotest.run.run(vim.fn.expand('%'))
        end,
        'Test file',
      },
      n = { neotest.run.run, 'Run nearest test' },
      -- x = { '<cmd>UltestClear<CR>', 'Clear test results' },
      -- j = { '<Plug>(ultest-summary-jump)', 'Jump to results window' },
    },
  },
})
