local wezterm = require("wezterm")
local config = wezterm.config_builder()

local home = wezterm.home_dir

-- Font settings
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 12
config.freetype_load_flags = "FORCE_AUTOHINT"

-- Window appearance and behavior
config.window_decorations = "RESIZE"
config.window_padding = {
	left = "0cell",
	right = "0cell",
	top = "0cell",
	bottom = "0cell",
}
config.window_close_confirmation = "NeverPrompt"
config.enable_tab_bar = false

-- Color scheme
config.colors = {
	foreground = "#c7c7c7",
	background = "black",
	cursor_bg = "#c7c7c7",
	cursor_fg = "#feffff",
	cursor_border = "#ffffff",
	selection_bg = "#c6dcfc",
	selection_fg = "black",
	scrollbar_thumb = "#222222",
	split = "#444444",
	ansi = {
		"black",
		"#b83019",
		"#51bf37",
		"#c6c43d",
		"#0c24bf",
		"#b93ec1",
		"#53c2c5",
		"#c7c7c7",
	},
	brights = {
		"#676767",
		"#ef766d",
		"#8cf67a",
		"#fefb7e",
		"#6a71f6",
		"#f07ef8",
		"#8ef9fd",
		"#feffff",
	},
}

-- Background image settings
config.background = {
	{
		source = {
			File = home .. "/.dotfiles/zsh/background.jpg",
		},
		hsb = {
			brightness = 0.025,
			hue = 1.0,
			saturation = 0.6,
		},
		width = "Cover",
		repeat_x = "NoRepeat",
		horizontal_align = "Center",
	},
}

return config
