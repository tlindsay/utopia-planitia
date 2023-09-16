local wk = require('which-key')
require('neorg').setup({
  load = {
    ['core.defaults'] = {}, -- Loads default behavior
    ['core.dirman'] = {
      config = {
        workspaces = {
          work = '~/Code/work/notes/',
          home = '/Volumes/myfiles.fastmail.com/Private/notes/home',
        },
        default_workspace = 'work',
      },
    },
    ['core.concealer'] = {}, -- Adds pretty icons to your documents
    ['core.completion'] = {
      config = {
        engine = 'nvim-cmp',
      },
    },
    ['core.qol.toc'] = {},
    ['core.journal'] = {},
    ['core.esupports.metagen'] = {
      config = {
        type = 'auto',
      },
    },
    ['core.integrations.telescope'] = {},
  },
})

-- require('neorg.callbacks').on_event('core.keybinds.events.enable_keybinds', function(_, keybinds)
--   keybinds.map_event_to_mode('norg', {
--     i = {
--       { '<C-l>', 'core.integrations.telescope.insert_link' },
--       { '<C-f>', 'core.integrations.telescope.insert_file_link' },
--     },
--   }, { silent = true, noremap = true })
-- end)
