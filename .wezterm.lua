local wt = require("wezterm")
return {
	term = "wezterm",
	font = wt.font({
		family = "FantasqueSansMono Nerd Font",
		harfbuzz_features = { "calt=1" },
	}),
	font_size = 17,
	hide_tab_bar_if_only_one_tab = true,

	window_padding = {
		top = 0,
		right = 0,
		bottom = 0,
		left = 0,
	},

	audible_bell = "Disabled",
	visual_bell = {
		fade_in_function = "EaseIn",
		fade_in_duration_ms = 150,
		fade_out_function = "EaseOut",
		fade_out_duration_ms = 150,
	},

	window_frame = {
		font = wt.font("FantasqueSansMono Nerd Font", { weight = "Bold" }),
		font_size = 14,
		active_titlebar_bg = "#222436",
		inactive_titlebar_bg = "#1e2031",
	},

	colors = {
		visual_bell = "#444a73",
		inactive_tab_edge = "#c099ff",
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
