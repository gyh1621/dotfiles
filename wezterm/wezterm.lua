local wezterm = require("wezterm")
local act = wezterm.action

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
local SOLID_LEFT_MOST = utf8.char(0xe0ba)
local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)

local VIM_ICON = utf8.char(0xe62b)
local CAT_ICON = utf8.char(0xf0c7c)
local RUST_ICON = utf8.char(0xe68b)
local TERMINAL_ICON = utf8.char(0xe795)
local SUNGLASS_ICON = utf8.char(0xeba2)
local PYTHON_ICON = utf8.char(0xf820)
local NODE_ICON = utf8.char(0xe74e)

local SUB_IDX = {
	"₁",
	"₂",
	"₃",
	"₄",
	"₅",
	"₆",
	"₇",
	"₈",
	"₉",
	"₁₀",
	"₁₁",
	"₁₂",
	"₁₃",
	"₁₄",
	"₁₅",
	"₁₆",
	"₁₇",
	"₁₈",
	"₁₉",
	"₂₀",
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	wezterm.log_info("trigger format title")

	local edge_background = "#121212"
	local background = "#4E4E4E"
	local foreground = "#1C1B19"
	local dim_foreground = "#3A3A3A"

	if tab.is_active then
		background = "#FBB829"
		foreground = "#1C1B19"
	elseif hover then
		background = "#FF8700"
		foreground = "#1C1B19"
	end

	local edge_foreground = background
	local process_name = tab.active_pane.foreground_process_name
	local pane_title = tab.active_pane.title
	local exec_name = basename(process_name):gsub("%.exe$", "")
	local title_with_icon

	if exec_name == "nvim" then
		title_with_icon = VIM_ICON .. " " .. pane_title:gsub("^(%S+)%s+(%d+/%d+) %- nvim", "  %2 %1")
	elseif exec_name == "cargo" then
		title_with_icon = RUST_ICON .. " " .. pane_title
	elseif exec_name == "bat" or exec_name == "less" or exec_name == "moar" then
		title_with_icon = CAT_ICON .. " " .. exec_name:upper()
	elseif exec_name == "btm" or exec_name == "ntop" or exec_name == "top" or exec_name == "btop" then
		title_with_icon = SUNGLASS_ICON .. " " .. exec_name:upper()
	elseif exec_name == "python" or exec_name == "hiss" then
		title_with_icon = PYTHON_ICON .. " " .. exec_name
	elseif exec_name == "node" then
		title_with_icon = NODE_ICON .. " " .. exec_name:upper()
	else
		title_with_icon = TERMINAL_ICON .. " " .. pane_title
	end
	local left_arrow = SOLID_LEFT_ARROW
	if tab.tab_index == 0 then
		left_arrow = SOLID_LEFT_MOST
	end
	local id = SUB_IDX[tab.tab_index + 1]
	local title = " " .. wezterm.truncate_right(title_with_icon, max_width - 5) .. " "

	wezterm.log_info("title " .. title)

	return {
		{ Attribute = { Intensity = "Bold" } },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = left_arrow },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = id },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
		{ Attribute = { Intensity = "Normal" } },
	}
end)

local window_padding = {
	left = "1.5cell",
	right = "1cell",
	top = "0.4cell",
	bottom = "0.3cell",
}

local full_screen_window_padding = {
	left = "0.2cell",
	right = "0.2cell",
	top = "0.1cell",
	bottom = "0cell",
}

local function update_window_padding(window, pane)
	local overrides = window:get_config_overrides() or {}
	local process_name = pane:get_foreground_process_name()

	if process_name == nil then
		process_name = pane:tab():get_title()
	end

	if string.find(process_name, "vim") then
		if
				overrides.window_padding == nil
				or (
					overrides.window_padding.left ~= full_screen_window_padding.left
					or overrides.window_padding.right ~= full_screen_window_padding.right
					or overrides.window_padding.top ~= full_screen_window_padding.top
					or overrides.window_padding.bottom ~= full_screen_window_padding.bottom
				)
		then
			overrides.window_padding = full_screen_window_padding
			window:set_config_overrides(overrides)
		end
	else
		if overrides.window_padding ~= nil then
			overrides.window_padding = nil
			window:set_config_overrides(overrides)
		end
	end
end

wezterm.on("update-status", function(window, pane)
	update_window_padding(window, pane)

	local palette = window:effective_config().resolved_palette
	local firstTabActive = window:mux_window():tabs_with_info()[1].is_active

	local RIGHT_DIVIDER = utf8.char(0xe0bc)
	local text = "   "

	if window:leader_is_active() then
		text = "   "
	end

	local divider_bg = firstTabActive and "#0F0F0F" or "#0F0F0F"

	window:set_left_status(wezterm.format({
		{ Foreground = { Color = "#000000" } },
		{ Background = { Color = palette.ansi[5] } },
		{ Text = text },
		{ Background = { Color = divider_bg } },
		{ Foreground = { Color = "#BD93F9" } },
		-- { Foreground = { Color = palette.ansi[5] } },
		{ Text = RIGHT_DIVIDER },
	}))
end)

local custom = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
-- custom.background = "#000000"
custom.tab_bar.background = "#040404"
custom.tab_bar.inactive_tab.bg_color = "#0f0f0f"
custom.tab_bar.new_tab.bg_color = "#080808"

local darkTheme = "OLEDppuccin"
local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return darkTheme
	else
		return "Dracula"
		-- return darkTheme
		-- return "Catppuccin Latte"
	end
end

return {
	disable_default_key_bindings = false,
	leader = { key = "a", mods = "CTRL", timeout_milliseconds = 5002 },
	colors = {
		quick_select_label_bg = { Color = "grey" },
		quick_select_label_fg = { Color = "white" },
		tab_bar = {
			-- Setting the bar color to black
			background = "#000000",
		},
	},
	keys = {
		-- This will create a new split and run your default program inside it
		{
			key = "|",
			mods = "SUPER|SHIFT",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "_",
			mods = "SUPER|SHIFT",
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		-- CTRL+ALT + number to move to that position
		{ key = tostring(1), mods = "LEADER|ALT", action = wezterm.action.MoveTab(0) },
		{ key = tostring(2), mods = "LEADER|ALT", action = wezterm.action.MoveTab(1) },
		{ key = tostring(3), mods = "LEADER|ALT", action = wezterm.action.MoveTab(2) },
		{ key = tostring(4), mods = "LEADER|ALT", action = wezterm.action.MoveTab(3) },
		{ key = tostring(5), mods = "LEADER|ALT", action = wezterm.action.MoveTab(4) },
		{ key = tostring(6), mods = "LEADER|ALT", action = wezterm.action.MoveTab(5) },
		{ key = tostring(7), mods = "LEADER|ALT", action = wezterm.action.MoveTab(6) },
		{ key = tostring(8), mods = "LEADER|ALT", action = wezterm.action.MoveTab(7) },
		{
			key = "|",
			mods = "LEADER",
			action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},
		{
			key = "-",
			mods = "LEADER",
			action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }),
		},
		{ key = "h", mods = "LEADER",       action = act({ ActivatePaneDirection = "Left" }) },
		{ key = "j", mods = "LEADER",       action = act({ ActivatePaneDirection = "Down" }) },
		{ key = "k", mods = "LEADER",       action = act({ ActivatePaneDirection = "Up" }) },
		{ key = "l", mods = "LEADER",       action = act({ ActivatePaneDirection = "Right" }) },
		-- -- Shift + 'hjkl' to resize panes
		{ key = "h", mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Left", 5 } }) },
		{ key = "j", mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Down", 5 } }) },
		{ key = "k", mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Up", 5 } }) },
		{ key = "l", mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Right", 5 } }) },
		-- numbers to navigate to tabs
		{ key = "1", mods = "SUPER",        action = act({ ActivateTab = 0 }) },
		{ key = "2", mods = "SUPER",        action = act({ ActivateTab = 1 }) },
		{ key = "3", mods = "SUPER",        action = act({ ActivateTab = 2 }) },
		{ key = "4", mods = "SUPER",        action = act({ ActivateTab = 3 }) },
		{ key = "5", mods = "SUPER",        action = act({ ActivateTab = 4 }) },
		{ key = "6", mods = "SUPER",        action = act({ ActivateTab = 5 }) },
		{ key = "7", mods = "SUPER",        action = act({ ActivateTab = 6 }) },
		{ key = "8", mods = "SUPER",        action = act({ ActivateTab = 7 }) },
		{ key = "9", mods = "SUPER",        action = act({ ActivateTab = 8 }) },
		{ key = "9", mods = "SUPER",        action = act({ ActivateTab = 9 }) },
		{ key = "0", mods = "SUPER",        action = act({ ActivateTab = -1 }) },
		-- tab navigate
		{ key = "t", mods = "LEADER",       action = wezterm.action.ShowTabNavigator },
		{ key = "H", mods = "SUPER",        action = act.ActivateTabRelative(-1) },
		{ key = "L", mods = "SUPER",        action = act.ActivateTabRelative(1) },
		-- tab rename
		{
			key = "r",
			mods = "LEADER",
			action = act.PromptInputLine({
				description = "Enter new name for tab",
				action = wezterm.action_callback(function(window, pane, line)
					-- line will be `nil` if they hit escape without entering anything
					-- An empty string if they just hit enter
					-- Or the actual line of text they wrote
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
		-- 'c' to create a new tab
		{ key = "c", mods = "LEADER", action = act({ SpawnTab = "CurrentPaneDomain" }) },
		-- 'x' to kill the current pane
		{ key = "x", mods = "LEADER", action = act({ CloseCurrentPane = { confirm = true } }) },
		-- 'z' to toggle the zoom for the current pane
		{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },

		-- quick select
		{ key = "v", mods = "LEADER", action = "ActivateCopyMode" },
		{ key = " ", mods = "LEADER", action = act.QuickSelect },
		{
			key = "p",
			mods = "LEADER",
			action = wezterm.action.QuickSelectArgs({
				label = "select path",
				patterns = {
					"//\\S+",
				},
			}),
		},
		{
			key = "w",
			mods = "LEADER",
			action = wezterm.action.QuickSelectArgs({
				label = "select word",
				patterns = {
					"\\S*\\w+",
				},
			}),
		},
		{
			key = "o",
			mods = "LEADER",
			action = wezterm.action.QuickSelectArgs({
				label = "open url",
				patterns = {
					"https?://\\S+",
				},
				action = wezterm.action_callback(function(window, pane)
					local url = window:get_selection_text_for_pane(pane)
					wezterm.log_info("opening: " .. url)
					wezterm.open_with(url)
				end),
			}),
		},
	},
	use_fancy_tab_bar = false,
	show_new_tab_button_in_tab_bar = false,
	tab_bar_at_bottom = true,
	hide_tab_bar_if_only_one_tab = false,
	tab_max_width = 50,

	window_decorations = "RESIZE",
	window_padding = window_padding,
	color_schemes = {
		["OLEDppuccin"] = custom,
	},
	color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
	clean_exit_codes = { 130 },
	audible_bell = "Disabled",
	initial_rows = 65,
	initial_cols = 220,
	cursor_thickness = "2",
	-- font
	font = wezterm.font_with_fallback({
		{ family = "Pragmasevka Nerd Font", weight = "Regular" },
	}),
	font_size = 18,
}
