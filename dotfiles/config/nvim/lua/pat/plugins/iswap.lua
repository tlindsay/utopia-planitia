local wk = require('which-key')
local iswap = require('iswap')
iswap.setup({ autoswap = true })
wk.register({
  ['#'] = { iswap.iswap_node_with, 'Interactively swap node' },
})
