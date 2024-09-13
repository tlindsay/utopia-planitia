if vim.g.started_by_firenvim == true then
  vim.o.laststatus = 0
end

vim.g.firenvim_config = {
  localSettings = {
    [ [[.*]] ] = {
      cmdline = 'firenvim',
      priority = 0,
      selector = 'textarea:not([readonly], [aria-readonly]), div[role="textbox"]',
      takeover = 'never',
    },
    [ [[.*notion\.so.*]] ] = {
      priority = 9,
      takeover = 'never',
    },
    [ [[.*docs\.google\.com.*]] ] = {
      priority = 9,
      takeover = 'never',
    },
  },
}
