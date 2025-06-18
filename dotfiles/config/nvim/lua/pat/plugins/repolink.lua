require('repolink').setup({})
require('which-key').add({
  { '<leader>y', '<cmd>RepoLink!<cr>', desc = 'Yank HTTP permalink', mode = 'n' },
  { '<leader>y', "'<,'><cmd>RepoLink!<cr>", desc = 'Yank HTTP permalink', mode = 'v' },
})
