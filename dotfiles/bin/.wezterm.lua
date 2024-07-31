-- WezTerm docs: https://wezfurlong.org/wezterm/config/files.html

local wt = require("wezterm")
local fantasque = wt.font_with_fallback({
	{
		family = "FantasqueSansMono Nerd Font",
		harfbuzz_features = {
			"calt=1", -- Fantasque Ligatures
			"liga=0",
			"clig=0",
		},
	},
	{
		family = "Symbols Nerd Font",
		assume_emoji_presentation = true,
	},
})

return {
	term = "wezterm",
	font = fantasque,
	font_size = 18,
	hide_tab_bar_if_only_one_tab = true,
	native_macos_fullscreen_mode = false,

	window_padding = {
		top = 0,
		right = 0,
		bottom = 0,
		left = 0,
	},

	audible_bell = "Disabled",
	visual_bell = {
		fade_in_function = "EaseOut",
		fade_in_duration_ms = 50,
		fade_out_function = "EaseOut",
		fade_out_duration_ms = 50,
	},

	window_frame = {
		font = wt.font("FantasqueSansMono Nerd Font", { weight = "Bold" }),
		font_size = 14,
		active_titlebar_bg = "#222436",
		inactive_titlebar_bg = "#1e2031",
	},

	colors = {
		visual_bell = "#444a73",
		-- inactive_tab_edge = "#c099ff",

		-- RETRO TAB BAR
		tab_bar = {
			-- The color of the strip that goes along the top of the window
			-- (does not apply when fancy tab bar is in use)
			background = "#0b0022",

			-- The active tab is the one that has focus in the window
			active_tab = {
				-- The color of the background area for the tab
				bg_color = "#2b2042",
				-- The color of the text for the tab
				fg_color = "#c0c0c0",

				-- Specify whether you want "Half", "Normal" or "Bold" intensity for the
				-- label shown for this tab.
				-- The default is "Normal"
				intensity = "Normal",

				-- Specify whether you want "None", "Single" or "Double" underline for
				-- label shown for this tab.
				-- The default is "None"
				underline = "None",

				-- Specify whether you want the text to be italic (true) or not (false)
				-- for this tab.  The default is false.
				italic = false,

				-- Specify whether you want the text to be rendered with strikethrough (true)
				-- or not for this tab.  The default is false.
				strikethrough = false,
			},

			-- Inactive tabs are the tabs that do not have focus
			inactive_tab = {
				bg_color = "#1b1032",
				fg_color = "#808080",

				-- The same options that were listed under the `active_tab` section above
				-- can also be used for `inactive_tab`.
			},

			-- You can configure some alternate styling when the mouse pointer
			-- moves over inactive tabs
			inactive_tab_hover = {
				bg_color = "#3b3052",
				fg_color = "#909090",
				italic = true,

				-- The same options that were listed under the `active_tab` section above
				-- can also be used for `inactive_tab_hover`.
			},

			-- The new tab button that let you create new tabs
			new_tab = {
				bg_color = "#1b1032",
				fg_color = "#ff757f",

				-- The same options that were listed under the `active_tab` section above
				-- can also be used for `new_tab`.
			},

			-- You can configure some alternate styling when the mouse pointer
			-- moves over the new tab button
			new_tab_hover = {
				bg_color = "#3b3052",
				fg_color = "#909090",
				italic = true,

				-- The same options that were listed under the `active_tab` section above
				-- can also be used for `new_tab_hover`.
			},
		},
	},

	color_scheme = "Tokyonight Moon",
	color_schemes = {
		["Tokyonight Moon"] = {
			foreground = "#c8d3f5",
			background = "#222436",
			cursor_bg = "#c8d3f5",
			cursor_border = "#c8d3f5",
			cursor_fg = "#222436",
			selection_bg = "#3654a7",
			selection_fg = "#c8d3f5",

			ansi = { "#1b1d2b", "#ff757f", "#c3e88d", "#ffc777", "#82aaff", "#c099ff", "#86e1fc", "#828bb8" },
			brights = { "#444a73", "#ff757f", "#c3e88d", "#ffc777", "#82aaff", "#c099ff", "#86e1fc", "#c8d3f5" },
		},
		["Tokyonight Day"] = {
			foreground = "#3760bf",
			background = "#e1e2e7",
			cursor_bg = "#3760bf",
			cursor_border = "#3760bf",
			cursor_fg = "#e1e2e7",
			selection_bg = "#99a7df",
			selection_fg = "#3760bf",

			ansi = { "#e9e9ed", "#f52a65", "#587539", "#8c6c3e", "#2e7de9", "#9854f1", "#007197", "#6172b0" },
			brights = { "#a1a6c5", "#f52a65", "#587539", "#8c6c3e", "#2e7de9", "#9854f1", "#007197", "#3760bf" },
		},
	},
}
