local wk = require('which-key')
require('neorg').setup({
  load = {
    ['core.defaults'] = {}, -- Loads default behavior
    ['core.norg.dirman'] = {
      config = {
        workspaces = {
          work = '~/Code/work/notes/',
          home = '/Volumes/myfiles.fastmail.com/Private/notes/home',
        },
        default_workspace = 'work',
      },
    },
    ['core.norg.concealer'] = {}, -- Adds pretty icons to your documents
    ['core.norg.completion'] = {
      config = {
        engine = 'nvim-cmp',
      },
    },
    ['core.norg.qol.toc'] = {},
    ['core.norg.journal'] = {},
    ['core.integrations.telescope'] = {},
  },
})

wk.register()
