local neotest = require('neotest')
local wk = require('which-key')

local neotest_ns = vim.api.nvim_create_namespace('neotest')
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
      return message
    end,
  },
}, neotest_ns)

---@diagnostic disable-next-line: missing-fields
neotest.setup({
  adapters = {
    -- require('neotest-vitest'),
    -- require('neotest-jest')({
    --   jestCommand = 'yarn test --watchAll=false',
    -- }),
    -- require('neotest-go')({
    --   experimental = { test_table = true },
    -- }),
    require('neotest-golang')({
      dap_go_enabled = true,
    }),
  },
  diagnostic = {
    enabled = true,
    severity = vim.log.levels.ERROR,
  },
  output = {
    enabled = true,
    open_on_run = true,
  },
  output_panel = {
    enabled = true,
    open = "botright split | resize 15",
  },
  icons = {
    passed = '󰗠 ',
    running = '󰐌 ',
    skipped = '󰙡 ',
    failed = '󰅙 ',
    unknown = '󰋗 ',
  },
  -- summary = {
  --   mappings = {
  --     run = '<Space>',
  --     mark = '<Tab>',
  --     clear_marked = '<S-Tab>',
  --     run_marked = 'R',
  --   },
  -- },
})

-- vim.cmd([[
--   let test#javascript#reactscripts#options = "--watchAll=false"
--   let test#javascript#jest#options = "--color=always"
-- ]])

vim.g.ultest_running_sign = ' '
vim.g.ultest_not_run_sign = ' '
vim.g.ultest_pass_sign = ' '
vim.g.ultest_fail_sign = ' '

vim.cmd([[
command! NeotestSummary lua require("neotest").summary.toggle()
command! NeotestFile lua require("neotest").run.run(vim.fn.expand("%"))
command! Neotest lua require("neotest").run.run(vim.fn.getcwd())
command! NeotestNearest lua require("neotest").run.run()
command! NeotestDebug lua require("neotest").run.run({ strategy = "dap" })
command! NeotestAttach lua require("neotest").run.attach()
command! NeotestOutput lua require("neotest").output.open()
]])

local function clearAndRun(...)
  local args = { ... }
  return function()
    neotest.output_panel.clear()
    neotest.run.run(unpack(args))
  end
end

wk.register({
  ['<leader>'] = {
    t = {
      name = 'Tests',
      t = { neotest.summary.toggle, 'Open testing panel' },
      o = { neotest.output_panel.toggle, 'Open output panel' },
      f = {
        clearAndRun(vim.fn.expand('%')),
        'Test file',
      },
      n = { clearAndRun(), 'Run nearest test' },
      d = {
        clearAndRun({
          strategy = 'dap',
          env = {
            ['RUN_CLICKHOUSE_TESTS'] = '1',
            ['RUN_MYSQL_TESTS'] = '1',
          },
        }),
        'Debug nearest test',
      },
      a = { neotest.jump.next, 'Jump to the next test' },
      A = { neotest.jump.prev, 'Jump to the previous test' },
    },
  },
})
