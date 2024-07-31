require('scrollbar').setup({
  show_in_active_only = true,
  handlers = {
    gitsigns = true,
  },
})
require('scrollbar.handlers.gitsigns').setup()
