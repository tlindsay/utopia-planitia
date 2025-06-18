----------------------------------------------------------
-- Statusline configuration file
-----------------------------------------------------------

-- Plugin: feline.nvim
-- url: https://github.com/famiu/feline.nvim

--- For the configuration see the Usage section:
--- https://github.com/famiu/feline.nvim/blob/master/USAGE.md

--- Thanks to ibhagwan for the example to follow:
--- https://github.com/ibhagwan/nvim-lua

-- Set colorscheme (from core/colors.lua/colorscheme_name)
local colors = require('pat.core/colors').tokyonight
local utils = require('pat.utils')

local vi_mode_colors = {
  NORMAL = colors.cyan,
  INSERT = colors.green,
  VISUAL = colors.yellow,
  OP = colors.cyan,
  BLOCK = colors.cyan,
  REPLACE = colors.red,
  ['V-REPLACE'] = colors.red,
  ENTER = colors.orange,
  MORE = colors.orange,
  SELECT = colors.yellow,
  COMMAND = colors.pink,
  SHELL = colors.pink,
  TERM = colors.pink,
  NONE = colors.purple,
}

-- Providers (LSP, vi_mode)
local vi_mode_utils = require('feline.providers.vi_mode')
local navic = require('nvim-navic')

-- My components
local component = {}
component.recording_macro = {
  provider = 'recording_macro',
  hl = { fg = colors.red, bg = colors.bg },
  update = { 'RecordingEnter', 'RecordingLeave' },
  enabled = function()
    return vim.fn.reg_recording() ~= ''
  end,
}
component.format_on_save = {
  provider = 'format_on_save',
  hl = { fg = colors.bg, bg = colors.pink },
}
-- vi_mode -> NORMAL, INSERT..
component.vi_mode = {
  left = {
    provider = function()
      local label = ' ' .. vi_mode_utils.get_vim_mode() .. ' '
      return label
    end,
    hl = function()
      return {
        name = vi_mode_utils.get_mode_highlight_name(),
        fg = colors.bg,
        bg = vi_mode_utils.get_mode_color(),
        style = 'bold',
      }
    end,
    left_sep = '',
    right_sep = ' ',
  },
}
component.search = {
  provider = 'search_count',
  hl = {
    fg = colors.yellow,
  },
  left_sep = '',
  right_sep = ' ',
}
-- Parse file information:
component.file = {
  -- File name
  info = {
    provider = {
      name = 'file_info',
      opts = {
        type = 'relative',
        -- file_modified_icon = '',
        file_modified_icon = '⧆ ',
        file_readonly_icon = ' ',
      },
    },
    hl = { fg = colors.cyan },
    icon = '',
  },
  -- File type
  type = {
    provider = {
      name = 'file_type',
      opts = {
        filetype_icon = true,
        colored_icon = true,
      },
      left_sep = ' ',
      right_sep = ' ',
    },
  },
  -- Operating system
  os = {
    provider = function()
      local os = vim.bo.fileformat:lower()
      local icon
      if os == 'unix' then
        icon = '  '
      elseif os == 'mac' then
        icon = '  '
      else
        icon = '  '
      end
      return icon .. os
    end,
    hl = { fg = colors.fg },
    --left_sep = ' ',
    right_sep = ' ',
  },
  -- Line-column
  position = {
    provider = { name = 'position' },
    hl = {
      fg = colors.fg,
      style = 'bold',
    },
    left_sep = ' ',
    right_sep = ' ',
  },
  -- Cursor position in %
  line_percentage = {
    provider = { name = 'line_percentage' },
    hl = {
      fg = colors.cyan,
      style = 'bold',
    },
    left_sep = ' ',
    right_sep = ' ',
  },
  -- Simple scrollbar
  scroll_bar = {
    provider = { name = 'scroll_bar' },
    hl = { fg = colors.cyan },
    left_sep = ' ',
    right_sep = ' ',
  },
  scroll_wheel = {
    provider = { name = 'scroll_wheel' },
    hl = { fg = colors.cyan },
    left_sep = ' ',
    right_sep = ' ',
  },
}
-- LSP info
component.diagnos = {
  err = {
    provider = 'diagnostic_errors',
    -- icon = ' ',
    icon = utils:get_diagnostic_icon('error'),
    hl = { fg = colors.error },
    left_sep = '  ',
  },
  warn = {
    provider = 'diagnostic_warnings',
    -- icon = ' ',
    icon = utils:get_diagnostic_icon('warn'),
    hl = { fg = colors.warning },
    left_sep = ' ',
  },
  info = {
    provider = 'diagnostic_info',
    -- icon = ' ',
    icon = utils:get_diagnostic_icon('info'),
    hl = { fg = colors.info },
    left_sep = ' ',
  },
  hint = {
    provider = 'diagnostic_hints',
    -- icon = ' ',
    icon = utils:get_diagnostic_icon('hint'),
    hl = { fg = colors.hint },
    left_sep = ' ',
  },
}
component.lsp = {
  name = {
    provider = 'lsp_client_names',
    icon = '  ',
    hl = { fg = colors.pink },
    left_sep = '  ',
    right_sep = ' ',
  },
}
-- git info
component.git = {
  branch = {
    provider = 'git_branch',
    icon = ' ',
    hl = { fg = colors.pink },
    left_sep = '  ',
  },
  add = {
    provider = 'git_diff_added',
    icon = '  ',
    hl = { fg = colors.green },
    left_sep = ' ',
  },
  change = {
    provider = 'git_diff_changed',
    icon = '  ',
    hl = { fg = colors.orange },
    left_sep = ' ',
  },
  remove = {
    provider = 'git_diff_removed',
    icon = '  ',
    hl = { fg = colors.red },
    left_sep = ' ',
  },
}
-- navic
component.navic = {
  provider = function()
    return navic.get_location()
  end,
  enabled = function()
    return navic.is_available()
  end,
  hl = { bg = colors.pink, fg = colors.bg },
  left_sep = '█',
  right_sep = '█',
}

-- Custom providers
local scroll_wheel_slices = {
  ' ',
  ' ',
  ' ',
  ' ',
  ' ',
  ' ',
  ' ',
  ' ',
  ' ',
  ' ',
  ' ',
  ' ',
  ' ',
  ' ',
}
local custom_providers = {
  scroll_wheel = function(_, opts)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local mod = #scroll_wheel_slices - 1

    if opts.reverse then
      return scroll_wheel_slices[5 - math.floor(curr_line / lines * mod)]
    else
      return scroll_wheel_slices[math.floor(curr_line / lines * mod) + 1]
    end
  end,
  format_on_save = function()
    local enabled = not vim.g.disable_autoformat
    local label = ''
    if enabled then
      label = ' 󰉼 '
    end
    return label
  end,
  recording_macro = function()
    local reg_recording = vim.fn.reg_recording()
    if reg_recording ~= '' then
      return '󰑊 ' .. reg_recording .. ' '
    end
    return ''
  end,
}

local left = {
  component.recording_macro,
  component.format_on_save,
  component.vi_mode.left,
  component.file.info,
  -- component.navic,
}
local middle = {}
local right = {
  component.diagnos.err,
  component.diagnos.warn,
  component.diagnos.hint,
  component.diagnos.info,
  -- component.search,
  component.file.type,
  component.file.position,
  component.file.scroll_wheel,
}

-- Get active/inactive components
--- see: https://github.com/famiu/feline.nvim/blob/master/USAGE.md#components
local components = {
  active = { left, middle, right },
  inactive = {
    { component.file.info },
    {},
    {},
  },
}

-- Call feline
require('feline').setup({
  custom_providers = custom_providers,
  theme = {
    bg = colors.bg,
    fg = colors.fg,
  },
  components = components,
  vi_mode_colors = vi_mode_colors,
  disable = {
    filetypes = {
      '^alpha$',
    },
  },
  force_inactive = {
    filetypes = {
      '^packer$',
      '^vista$',
      '^help$',
    },
    buftypes = {
      '^terminal$',
    },
    bufnames = {},
  },
})

local wcomps = {
  active_file_info = {
    provider = function(comp)
      local opts =
        vim.tbl_extend('force', component.file.info.provider.opts, { colored_icon = true, type = 'unique-short' })
      local isBound = require('pat.utils').getVarWithDefault('t', 0, 'is_scroll_bound', false)
      local file_info, icon = require('feline.providers.file').file_info(comp, opts)
      return file_info, isBound and '󱈖 ' or icon
    end,
    hl = function()
      local isBound = require('pat.utils').getVarWithDefault('t', 0, 'is_scroll_bound', false)
      return {
        bg = isBound and colors.red or vi_mode_utils.get_mode_color(),
        fg = colors.bg,
      }
    end,
    left_sep = '',
    right_sep = '',
  },
  inactive_file_info = {
    provider = function(comp)
      local opts = vim.tbl_extend('force', component.file.info.provider.opts, { colored_icon = false })
      local isBound = require('pat.utils').getVarWithDefault('t', 0, 'is_scroll_bound', false)
      local file_info, icon = require('feline.providers.file').file_info(comp, opts)
      return file_info, isBound and '󱈖 ' or icon
    end,
    hl = function()
      local isBound = require('pat.utils').getVarWithDefault('t', 0, 'is_scroll_bound', false)
      return {
        fg = isBound and colors.red or colors.bg,
        bg = colors.comment,
      }
    end,
    left_sep = '',
    right_sep = '',
  },
}

local winbar_components = {
  active = {},
  inactive = {},
}

table.insert(winbar_components.active, { component.navic, {} })
table.insert(winbar_components.active, {
  {
    provider = 'search_count',
    hl = {
      bg = colors.yellow,
      fg = colors.bg_dark,
    },
    icon = ' ',
    left_sep = '',
    right_sep = ' ',
  },
  wcomps.active_file_info,
})
table.insert(winbar_components.inactive, {})
table.insert(winbar_components.inactive, { wcomps.inactive_file_info })

require('feline').winbar.setup({
  components = winbar_components,
  disable = {
    filetypes = {
      '^alpha$',
      '^outline$',
      '^guihua$',
      '^trouble$',
      '^neotest.*$',
    },
    buftypes = {
      '^nofile$',
    },
  },
})
