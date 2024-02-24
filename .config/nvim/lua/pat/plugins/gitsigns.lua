local wk = require('which-key')
require('gitsigns').setup({
  yadm = {
    -- enable = true,
  },
})
wk.register({
  ['<leader>G'] = { ':Gitsigns<CR>', 'Select a Git operation' },
})
