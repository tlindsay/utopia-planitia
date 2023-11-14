require('repolink').setup({})
require('which-key').register({
  y = { '<cmd>RepoLink!<cr>', 'Yank HTTP permalink' },
}, {
  mode = { 'n', 'v' },
  prefix = '<leader>',
})

vim.api.nvim_create_user_command('LinkTest', function(args)
  vim.print(args)
end, {
  bang = true,
  nargs = '*',
  range = true,
})
