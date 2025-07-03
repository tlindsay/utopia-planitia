local gs = require('gitsigns')
local wk = require('which-key')
gs.setup({
  current_line_blame_opts = {
    virt_text_pos = 'right_align',
  },
  sign_priority = 100, -- Force git signs to the left
  signs = {
    delete = {
      delete = { text = '┻' },
      topdelete = { text = '┳' },
    },
  },
  signs_staged = {
    delete = {
      delete = { text = '┻' },
      topdelete = { text = '┳' },
    },
  },
})

---@param direction 'first'|'last'|'next'|'prev'
---@param opts? Gitsigns.NavOpts
local function nav_hunk(direction, opts)
  return function()
    gs.nav_hunk(direction, opts)
  end
end

wk.add({
  group = 'Git',
  icon = { name = 'git' },
  { '<leader><leader>g', ':Gitsigns<CR>', desc = 'Select a Git operation' },
  { '<leader>gb', gs.toggle_current_line_blame, desc = 'Stage the hunk under cursor' },
  { '<leader>gs', gs.stage_hunk, desc = 'Stage the hunk under cursor' },
  { '<leader><leader>gs', gs.stage_buffer, desc = 'Stage the current buffer' },
  { '<leader>gr', gs.reset_hunk, desc = 'Reset the hunk under cursor (broken?)' },
  { '<leader><leader>gr', gs.reset_buffer_index, desc = 'Reset the current buffer' },
  { '<leader>ga', nav_hunk('next'), desc = 'Navigate to the next unstaged hunk' },
  { '<leader>gA', nav_hunk('prev'), desc = 'Navigate to the previous unstaged hunk' },
})
