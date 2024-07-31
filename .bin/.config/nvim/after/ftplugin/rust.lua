local wk = require('which-key')
local utils = require('pat.utils')
wk.register({
  ['<leader>rP'] = {
    function()
      utils.rust_playground({ open = true })
    end,
    'Open current file as Rust Playground',
  },
  ['<leader>rp'] = {
    function()
      utils.rust_playground({ copy = true })
      vim.notify('Rust Playground URL copied to clipboard!', vim.log.levels.INFO)
    end,
    'Copy URL to current file as Rust Playground',
  },
}, { buffer = 0 })
