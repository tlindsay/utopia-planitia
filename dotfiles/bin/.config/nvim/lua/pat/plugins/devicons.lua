require('nvim-web-devicons').setup({
  override = {
    nvim = {
      icon = '',
      color = '#00b952',
      cterm_color = '65',
      name = 'Neovim',
    },
  },
  override_by_filename = {
    ['.config/nvim/**/*'] = {
      icon = '',
      color = '#00b952',
      cterm_color = '65',
      name = 'Neovim',
    },
  },
})
