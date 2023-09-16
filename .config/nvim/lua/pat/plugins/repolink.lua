require('repolink').setup({})
require('which-key').register({
  y = { '<cmd>RepoLink!<cr>', 'Yank HTTP permalink' },
}, {
  mode = { 'n', 'v' },
  prefix = '<leader>',
})

vim.api.nvim_create_user_command('LinkTest', function(args)
  vim.print('Line 1: ' .. args.line1)
  vim.print('Line 2: ' .. args.line2)
  vim.print('Range: ' .. args.range)
end, {
  bang = true,
  nargs = '*',
  range = true,
})
