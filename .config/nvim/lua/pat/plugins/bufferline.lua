local colors = require('pat.core.colors').tokyonight
require('bufferline').setup({
  options = {
    mode = 'tabs',
    name_formatter = function(buf)
      local success, custom = pcall(vim.api.nvim_tabpage_get_var, buf.tabnr, 'custom_tab_name')
      if(success and string.len(custom) > 0)then
        return custom
      end
      return buf.name
    end,
    numbers = function(opts)
      return string.format('%s', opts.ordinal)
    end,
    -- modified_icon = "●",
    modified_icon = "⧆",
    offsets = { text_align = 'left' },
    persist_buffer_sort = false,
    show_buffer_icons = false,
    show_close_icon = false,
    show_buffer_close_icons = false,
    separator_style = 'thick',
  },
  highlights = {
    modified = {
      guifg = colors.fg_dark
    },
    modified_selected = {
      guifg = '#ffa0a0' -- salmon color
    },
    buffer_visible = {
      guifg = colors.comment,
      guibg = colors.bg,
    },
    buffer_selected = {
      gui = 'bold',
      guibg = colors.bg
    },
  },
})

local group = vim.api.nvim_create_augroup('TabAutoSort', {})
vim.api.nvim_create_autocmd('TabNew', {
  group = group,
  command = 'BufferLineSortByTabs'
})
vim.api.nvim_create_autocmd('TabClosed', {
  group = group,
  command = 'BufferLineSortByTabs'
})
