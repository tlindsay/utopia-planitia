-----------------------------------------------------------
-- Dashboard configuration file
-----------------------------------------------------------

-- Plugin: alpha-nvim
-- url: https://github.com/goolord/alpha-nvim

-- For configuration examples see: https://github.com/goolord/alpha-nvim/discussions/16

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
local fortune = require("alpha.fortune")

-- Footer
local function footer()
	local version = vim.version()
	local print_version = "v" .. version.major .. "." .. version.minor .. "." .. version.patch
	local datetime = os.date("%Y/%m/%d %H:%M:%S")

	local text = fortune()

	table.insert(text, print_version .. " " .. datetime)
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

local banner = {
	"███████╗ █████╗ ███████╗████████╗██╗  ██╗   ██╗",
	"██╔════╝██╔══██╗██╔════╝╚══██╔══╝██║  ╚██╗ ██╔╝",
	"█████╗  ███████║███████╗   ██║   ██║   ╚████╔╝ ",
	"██╔══╝  ██╔══██║╚════██║   ██║   ██║    ╚██╔╝  ",
	"██║     ██║  ██║███████║   ██║   ███████╗██║   ",
	"╚═╝     ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝   ",
}

dashboard.section.header.val = banner
dashboard.section.header.opts.hl = "Error"

-- Menu
dashboard.section.buttons.val = {
	dashboard.button("e", " New file", ":ene <BAR> startinsert<CR>"),
	dashboard.button("f", " Find file", ":NvimTreeOpen<CR>"),
	dashboard.button("s", " Settings", ":e $MYVIMRC<CR>"),
	dashboard.button("u", " Update plugins", ":PackerUpdate<CR>"),
	dashboard.button("q", " Quit", ":qa<CR>"),
}

dashboard.section.footer.val = fortune()

alpha.setup(dashboard.config)
