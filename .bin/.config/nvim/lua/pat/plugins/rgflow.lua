local colors = require('pat/core.colors')
function get_hi_group_exists(ns_id, name)
  local group_info = vim.api.nvim_get_hl(ns_id, { name = name })
  -- next will return nil if an empty dict, else a value
  return next(group_info)
end

local fg, bg = (function()
  if get_hi_group_exists(0, 'Normal') then
    local hl_info = vim.api.nvim_get_hl_by_name('Normal', true)
    local fg = hl_info.foreground
    local bg = hl_info.background
    if fg and bg then
      return 'fg', 'bg'
    end
  end
  return '#ffffff', '#000000'
end)()
require('rgflow').setup({
  -- Set the default rip grep flags and options for when running a search via
  -- RgFlow. Once changed via the UI, the previous search flags are used for
  -- each subsequent search (until Neovim restarts).
  cmd_flags = '--smart-case --fixed-strings --ignore --max-columns 200',

  -- Mappings to trigger RgFlow functions
  default_trigger_mappings = true,
  -- These mappings are only active when the RgFlow UI (panel) is open
  default_ui_mappings = true,
  -- QuickFix window only mapping
  default_quickfix_mappings = true,
  colors = {
    RgFlowHead = { fg = fg, bg = colors.pink, reverse = true },
    RgFlowHeadLine = { fg = fg, bg = bg },
    RgFlowInputBg = { fg = fg, bg = bg },
    RgFlowInputFlags = { link = '@parameter' },
    RgFlowInputPattern = { fg = fg, bg = bg, bold = true },
    RgFlowInputPath = { link = 'Directory' },
  },
  ui_top_line_char = '═',
})
