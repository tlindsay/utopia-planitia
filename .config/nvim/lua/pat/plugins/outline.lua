local outline = require('outline')
outline.setup({
  outline_items = {
    show_symbol_lineno = true,
  },
})
local wk = require('which-key')
wk.register({
  ['<leader><leader>v'] = { outline.toggle_outline, 'Toggle Symbol Outline' },
})
