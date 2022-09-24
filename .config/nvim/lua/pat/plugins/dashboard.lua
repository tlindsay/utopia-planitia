local db = require('dashboard')
-- local fortune = require('alpha.fortune')

-- db.custom_header = {
--   '╔═══════════════════════════════════════════════════╗',
--   '║                                                   ║',
--   '║  ███████╗ █████╗ ███████╗████████╗██╗  ██╗   ██╗  ║',
--   '║  ██╔════╝██╔══██╗██╔════╝╚══██╔══╝██║  ╚██╗ ██╔╝  ║',
--   '║  █████╗  ███████║███████╗   ██║   ██║   ╚████╔╝   ║',
--   '║  ██╔══╝  ██╔══██║╚════██║   ██║   ██║    ╚██╔╝    ║',
--   '║  ██║     ██║  ██║███████║   ██║   ███████╗██║     ║',
--   '║  ╚═╝     ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝     ║',
--   '║                                                   ║',
--   '╚═══════════════════════════════════════════════════╝',
-- }
db.custom_header = {
  '╔════════════════════════════════════════════════════════════════════════════════╗',
  '║                                                                                ║',
  '║       ██████████   ████████  ▄█████████ ▐███▌   ▄█████ ████   ████████████████ ║',
  '║       ▀▀▀▀▀████▌   ▀▀▀▀▀▀▀  ████▀▀████▌  ███▌  ████▀▀ ████   ▀▀▀▀▀▀▀▀▀▀▀▀████  ║',
  '║     ████  ████▌  ███████▌  ████▀ ▐███▌   ███▌ ███▀   ████  ▐███▌  ████  ████   ║',
  '║    ████  ████▌  ███████▀  ████▀ ▄███▌    ███████▀   ████   ████  ████  ████    ║',
  '║   ████  ████▌  ████      ████▌ ▄███▌     ▐█████    ████   ████  ████  ████     ║',
  '║  ████  ████▌  ████████  ▐█████████▌      ▐███▀    ████   ████  ████  ████      ║',
  '║  ▀▀▀   ▀▀▀    ▀▀▀▀▀▀▀     ▀▀▀▀▀▀          ▀▀      ▀▀▀   ▀▀▀▀   ▀▀▀   ▀▀▀       ║',
  '╚════════════════════════════════════════════════════════════════════════════════╝',
}

db.custom_center = {
  { shortcut = 'e', icon = ' ', desc = 'New file           ', action = ':ene <BAR> startinsert<CR>' },
  { shortcut = 'f', icon = ' ', desc = 'Find file          ', action = ':NvimTreeOpen' },
  { shortcut = 's', icon = ' ', desc = 'Settings           ', action = ':e $MYVIMRC' },
  { shortcut = 'u', icon = ' ', desc = 'Update plugins     ', action = ':PackerUpdate' },
  { shortcut = 'q', icon = ' ', desc = 'Quit               ', action = ':qa' },
}

db.custom_footer = function()
  local version = vim.version()
  local print_version = 'v' .. version.major .. '.' .. version.minor .. '.' .. version.patch
  local datetime = os.date('%m/%d/%y %H:%M')

  -- local text = fortune()
  local text = {}
  local quote, _ = string.gsub(vim.fn.system('makeitso -p 1 -l 1 -c picard'), '\n', '')

  table.insert(text, quote)
  table.insert(text, '    - Jean-Luc Picard')
  table.insert(text, '')
  table.insert(text, ' ' .. datetime)
  table.insert(text, ' Neovim ' .. print_version)
  return text
end
