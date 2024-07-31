require('dressing').setup({
  input = {
    relative = 'win',
  },
  select = {
    backend = { 'telescope', 'nui', 'builtin' },
    telescope = require('telescope.themes').get_dropdown({}),
  },
})
