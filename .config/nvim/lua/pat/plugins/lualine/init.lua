local theme = require('pat.plugins/lualine.tokyonight')
local colors = require('pat.core/colors')
local formatOnSave = function()
  local label = ''
  if vim.api.nvim_get_var('PAT_format_on_save') then
    label = '  '
  end
  return label
end

require('lualine').setup({
  options = {
    component_separators = '',
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = { 'alpha' },
      tabline = { 'alpha' },
      winbar = { 'vista', 'packer', 'alpha', 'help', 'terminal' },
    },
    theme = theme,
  },
  sections = {
    lualine_a = {
      {
        formatOnSave,
        padding = 0,
        color = { bg = colors.purple, fg = 'black', gui = 'italic' },
      },
      {
        'mode',
        color = { gui = 'bold' },
        fmt = function(str)
          return str:sub(1, 1)
        end,
      },
    },
    lualine_b = { 'filename' },
    lualine_c = { 'diagnostics' },
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'filetype', 'location', 'progress' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {
    lualine_a = {
      {
        'tabs',
        mode = 2,
        fmt = function(name, context)
          -- Show + if buffer is modified in tab
          local buflist = vim.fn.tabpagebuflist(context.tabnr)
          local winnr = vim.fn.tabpagewinnr(context.tabnr)
          local bufnr = buflist[winnr]
          local mod = vim.fn.getbufvar(bufnr, '&mod')

          return name .. (mod == 1 and ' +' or '')
        end,
      },
    },
    lualine_z = { 'branch' },
  },
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = { 'filename' },
    lualine_y = {},
    lualine_z = {},
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = { 'filename' },
    lualine_y = {},
    lualine_z = {},
  },
})
