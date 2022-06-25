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

  title = " " .. (tab.tab_index + 1) .. ": " .. tab.active_pane.title .. "  "

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
    -- activate pane selection mode with the default alphabet (labels are "a", "s", "d", "f" and so on)
    {key="8", mods="SUPER", action=act.PaneSelect},
    {key="9", mods="SUPER", action=wezterm.action.ShowTabNavigator},
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
