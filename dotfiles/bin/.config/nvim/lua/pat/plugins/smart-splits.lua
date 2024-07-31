local wk = require('which-key')
local splits = require('smart-splits')

splits.setup({
  disable_multiplexer_nav_when_zoomed = false,
  log_level = 'debug',
  at_edge = 'stop',
  -- at_edge = function(args)
  --   vim.print(args.direction, {
  --     current_pane_id = args.mux.current_pane_id(),
  --     is_in_session = args.mux.is_in_session(),
  --     current_pane_is_zoomed = args.mux.current_pane_is_zoomed(),
  --     current_pane_at_edge = args.mux.current_pane_at_edge(args.direction),
  --     -- next_pane = mux.next_pane(direction),
  --     -- resize_pane = mux.resize_pane(direction),
  --     -- split_pane = mux.split_pane(direction),
  --   })
  --   args.mux.next_pane(args.direction)
  -- end,
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
