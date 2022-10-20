local so = require('symbols-outline')
so.setup({})
local wk = require('which-key')
wk.register({
  ['<leader><leader>v'] = { so.toggle_outline, 'Toggle Symbol Outline' },
})
