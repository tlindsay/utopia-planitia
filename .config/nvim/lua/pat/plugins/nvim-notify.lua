local M = {}

function M.setup()
  if #vim.api.nvim_list_uis() == 0 then
    -- no need to configure notifications in headless
    return
  end

  -- local opts = pcall(lvim.builtin.notify) and pcall(lvim.builtin.notify.opts) or defaults
  local notify = require('notify')

  notify.setup({
    background_colour = 'NotifyBackground',
    fps = 30,
    icons = {
      ERROR = '󰅙 ',
      WARN = '󰗖 ',
      INFO = '󰋽 ',
      DEBUG = '󱏛 ',
      TRACE = '󰝶 ',
    },
    level = 2,
    minimum_width = 50,
    render = 'compact',
    stages = 'fade_in_slide_out',
    timeout = 3500,
    top_down = false,
  })
  vim.notify = notify
end

M.setup()
return M
