local wezterm = require 'wezterm';
local act = wezterm.action

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#f1fa8c"
  local foreground = "black"
  local edge_background = background
  local edge_foreground = foreground

  local pane_title = tab.active_pane.title
  local user_title = tab.active_pane.user_vars.panetitle

  if user_title ~= nil and #user_title > 0 then
    pane_title = user_title
  end

  local title = " " .. (tab.tab_index + 1) .. ": " .. pane_title .. "  "

  if tab.is_active then
    return {
      {Background={Color=edge_background}},
      {Foreground={Color=edge_foreground}},
      {Text=""},
      {Background={Color=background}},
      {Foreground={Color=foreground}},
      {Text=title},
      {Background={Color=edge_background}},
      {Foreground={Color=edge_foreground}},
      {Text=""},
    }
  else
    return {
      {Text=title},
    }
  end
end)


return {

  -- initial window size
  initial_rows = 44,
  initial_cols = 135,

  -- font
  font = wezterm.font_with_fallback({
    {family="Berkeley Mono", weight="Medium"},
  }),
  font_size = 16,

  -- key bindings
  keys = {
    -- override QuickSelect binding
    {key=" ", mods="SUPER|SHIFT", action="QuickSelect"},
    -- This will create a new split and run your default program inside it
    {key="|", mods="SUPER|SHIFT", action=wezterm.action.SplitHorizontal{domain="CurrentPaneDomain"}},
    {key="_", mods="SUPER|SHIFT", action=wezterm.action.SplitVertical{domain="CurrentPaneDomain"}},
    -- activate pane selection mode with the default alphabet (labels are "a", "s", "d", "f" and so on)
    {key="8", mods="SUPER", action=act.PaneSelect},
    {key="9", mods="SUPER", action=wezterm.action.ShowTabNavigator},
    -- CTRL+ALT + number to move to that position
    {key=tostring(1), mods = 'CTRL|ALT', action = wezterm.action.MoveTab(0)},
    {key=tostring(2), mods = 'CTRL|ALT', action = wezterm.action.MoveTab(1)},
    {key=tostring(3), mods = 'CTRL|ALT', action = wezterm.action.MoveTab(2)},
    {key=tostring(4), mods = 'CTRL|ALT', action = wezterm.action.MoveTab(3)},
    {key=tostring(5), mods = 'CTRL|ALT', action = wezterm.action.MoveTab(4)},
    {key=tostring(6), mods = 'CTRL|ALT', action = wezterm.action.MoveTab(5)},
    {key=tostring(7), mods = 'CTRL|ALT', action = wezterm.action.MoveTab(6)},
    {key=tostring(8), mods = 'CTRL|ALT', action = wezterm.action.MoveTab(7)},
  },

  -- color scheme
  color_scheme = "Dracula",

  window_background_opacity = 0.99,

  -- cursor style
  default_cursor_style = 'SteadyBlock',

  -- smart tab bar [distraction-free mode]
  hide_tab_bar_if_only_one_tab = true,

  -- tab bar
  use_fancy_tab_bar=false,
  window_decorations = "RESIZE",

  -- widdow padding
  window_padding = {
    left = 15,
    right = 15,
    top = 25,
    bottom = 8,
  }

}
