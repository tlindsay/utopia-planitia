local wk = require('which-key')
local neotree = require('neo-tree')
neotree.setup({
  window = {
    position = 'left',
    mappings = {
      ['<C-v>'] = 'open_vsplit',
      ['<C-x>'] = 'open_split',
      ['<C-t>'] = 'open_tabnew',
    },
  },
})

wk.register({
  ['<C-n>'] = {
    ':Neotree toggle float reveal<CR>',
    'Open file browser',
  },
})
