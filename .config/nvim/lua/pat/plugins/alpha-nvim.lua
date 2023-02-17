-----------------------------------------------------------
-- Dashboard configuration file
-----------------------------------------------------------

-- Plugin: alpha-nvim
-- url: https://github.com/goolord/alpha-nvim

-- For configuration examples see: https://github.com/goolord/alpha-nvim/discussions/16

local alpha = require('alpha')
require('alpha.term')
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
  -- local total_plugins = #vim.tbl_keys(vim.g.plugs)
  local datetime = os.date('%m/%d/%y %H:%M')

  local text = fortune()
  table.insert(text, '')
  table.insert(text, '')
  table.insert(text, ' ' .. datetime)
  table.insert(text, ' Neovim ' .. print_version)
  -- table.insert(text, '  ' .. total_plugins .. ' plugins')
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

local height = 7

-- local header = {
--   type = 'terminal',
--   command = 'cat | ' .. os.getenv('HOME') .. '/.config/nvim/support/header.sh',
--   -- command = "echo foo | lolcat",
--   width = 80,
--   height = height,
--   opts = { position = 'center' },
-- }

local header = {
  type = 'text',
  val = banner,
  opts = {
    position = 'center',
    hl = 'AlphaHeader',
  },
}

-- Menu
local buttons = {
  type = 'group',
  val = {
    dashboard.button('e', '  New file', ':ene <BAR> startinsert<CR>'),
    { type = 'padding', val = 1 },
    dashboard.button('f', '  Find file', ':Neotree<CR>'),
    { type = 'padding', val = 1 },
    dashboard.button('s', '  Settings', ':e $MYVIMRC<CR>'),
    { type = 'padding', val = 1 },
    dashboard.button('u', '  Update plugins', ':PackerUpdate<CR>'),
    { type = 'padding', val = 1 },
    dashboard.button('q', '  Quit', ':qa<CR>'),
  },
}

local foot = {
  type = 'text',
  val = footer(),
  opts = {
    position = 'center',
    hl = 'AlphaFooter',
  },
}

local top_padding = vim.fn.max({ 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) })

local config = {
  layout = {
    { type = 'padding', val = top_padding - 4 },
    header,
    { type = 'padding', val = 4 },
    buttons,
    { type = 'padding', val = 1 },
    foot,
  },
}

alpha.setup(config)
