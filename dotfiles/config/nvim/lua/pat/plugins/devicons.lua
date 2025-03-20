local colors = require('pat.core.colors')
require('nvim-web-devicons').setup({
  override = {
    nvim = {
      icon = '',
      color = colors.green,
      cterm_color = '65',
      name = 'Neovim',
    },
  },
})
