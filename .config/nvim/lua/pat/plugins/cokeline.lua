local colors = require('pat.core.colors').tokyonight
local get_hex = require('cokeline/utils').get_hex

require('cokeline').setup({
  buffers = {
    filter_valid = function(buffer)
      P(buffer)
      return true
    end,
  },
  default_hl = {
    fg = function(buffer)
      return buffer.is_focused and get_hex('Normal', 'fg') or colors.purple
    end,
    bg = function(buffer)
      return buffer.is_focused and colors.purple or get_hex('Comment', 'fg')
    end,
  },

  components = {
    {
      text = ' ',
      bg = get_hex('Normal', 'bg'),
    },
    {
      text = '',
      fg = function(buffer)
        return buffer.is_focused and colors.purple or get_hex('Comment', 'fg')
      end,
      bg = get_hex('Normal', 'bg'),
    },
    {
      text = function(buffer)
        return ' ' .. buffer.devicon.icon
      end,
      fg = function(buffer)
        return buffer.devicon.color
      end,
    },
    {
      text = ' ',
    },
    {
      text = function(buffer)
        return buffer.index .. ': ' .. buffer.filename .. '  '
      end,
      style = function(buffer)
        return buffer.is_focused and 'bold' or nil
      end,
    },
    {
      text = '',
      delete_buffer_on_left_click = true,
    },
    {
      text = '',
      fg = function(buffer)
        return buffer.is_focused and colors.purple or get_hex('Comment', 'fg')
      end,
      bg = get_hex('Normal', 'bg'),
    },
  },
})
