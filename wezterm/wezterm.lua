local wezterm = require 'wezterm';

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
  -- font
  font = wezterm.font("Fira Code", {weight="Medium"}),
  font_size = 15,

  -- key bindings
  keys = {
    -- override QuickSelect binding
    {key=" ", mods="SUPER|SHIFT", action="QuickSelect"}
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
}