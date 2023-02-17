local wk = require('which-key')
local splits = require('smart-splits')

splits.setup({
  disable_tmux_nav_when_zoomed = false,
})

wk.register({
  ['<C-h>'] = { splits.move_cursor_left, 'Focus left' },
  ['<C-j>'] = { splits.move_cursor_down, 'Focus down' },
  ['<C-k>'] = { splits.move_cursor_up, 'Focus up' },
  ['<C-l>'] = { splits.move_cursor_right, 'Focus right' },
  ['<A-h>'] = { splits.resize_left, 'Resize pane left' },
  ['<A-j>'] = { splits.resize_down, 'Resize pane down' },
  ['<A-k>'] = { splits.resize_up, 'Resize pane up' },
  ['<A-l>'] = { splits.resize_right, 'Resize pane right' },
})
