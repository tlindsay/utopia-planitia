-----------------------------------------------------------
-- Dashboard configuration file
-----------------------------------------------------------

-- Plugin: alpha-nvim
-- url: https://github.com/goolord/alpha-nvim

-- For configuration examples see: https://github.com/goolord/alpha-nvim/discussions/16

local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')
local fortune = require('alpha.fortune')

-- local buffer = vim.api.nvim_get_current_buf()
-- local group = vim.api.nvim_create_augroup('alphaTabline', { clear = true })
-- vim.api.nvim_create_autocmd('User AlphaClosed', {
--   command = 'set showtabline=2',
--   group = group,
-- })
-- vim.api.nvim_create_autocmd('User AlphaReady', {
--   command = 'set showtabline=0',
--   buffer = buffer,
--   group = group,
-- })

-- Footer
local function footer()
  local version = vim.version()
  local print_version = 'v' .. version.major .. '.' .. version.minor .. '.' .. version.patch
  local datetime = os.date('%m/%d/%y %H:%M')

  local text = fortune()

  table.insert(text, '')
  table.insert(text, '')
  table.insert(text, ' ' .. datetime)
  table.insert(text, ' Neovim ' .. print_version)
  return text
end

-- Banner
-- local banner = {
--   "                                                    ",
--   " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
--   " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
--   " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
--   " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
--   " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
--   " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
--   "                                                    ",
-- }

-- local banner = {
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

-- local banner = {
--   '╔═════════════════════════════════╗',
--   '║                                 ║',
--   '║                .                ║',
--   '║               .:.               ║',
--   '║              .:::.              ║',
--   '║             .:::::.             ║',
--   '║         ***.:::::::.***         ║',
--   '║    *******.:::::::::.*******    ║',
--   '║  ********.:::::::::::.********  ║',
--   '║ ********.:::::::::::::.******** ║',
--   "║ *******.::::::'***`::::.******* ║",
--   "║ ******.::::'*********`::.****** ║",
--   "║  ****.:::'*************`:.****  ║",
--   "║    *.::'*****************`.*    ║",
--   "║    .:'  ***************    .    ║",
--   '║   .                             ║',
--   '║                                 ║',
--   '╚═════════════════════════════════╝',
--
--   -- ------------------------------------------------
--   -- Thank you for visiting https://asciiart.website/
--   -- This ASCII pic can be found at
--   -- https://asciiart.website/index.php?art=television/star%20trek
-- }

local banner = {
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

dashboard.section.header.val = banner
dashboard.section.header.opts.hl = 'AlphaHeader'

-- Menu
dashboard.section.buttons.val = {
  dashboard.button('e', '  New file', ':ene <BAR> startinsert<CR>'),
  dashboard.button('f', '  Find file', ':NvimTreeOpen<CR>'),
  dashboard.button('s', '  Settings', ':e $MYVIMRC<CR>'),
  dashboard.button('u', '  Update plugins', ':PackerUpdate<CR>'),
  dashboard.button('q', '  Quit', ':qa<CR>'),
}

dashboard.section.footer.val = footer()
dashboard.section.footer.opts.hl = 'AlphaFooter'

alpha.setup(dashboard.config)
