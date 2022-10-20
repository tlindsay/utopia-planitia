require('neorg').setup({
  load = {
    ['core.defaults'] = {},
    ['core.norg.dirman'] = {
      config = {
        workspaces = {
          work = '/Volumes/myfiles.fastmail.com/Private/notes/work',
          home = '/Volumes/myfiles.fastmail.com/Private/notes/home',
        },
      },
    },
    ['core.norg.concealer'] = {},
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
