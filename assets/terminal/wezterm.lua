local wezterm = require 'wezterm'

local config = {

  -- What to set the TERM variable to
  term = "xterm-256color",
  -- Don't ask the macOS IME/text services to compose input
  use_dead_keys = true,
  use_ime = false,

  -- Window size
  initial_rows = 24,
  initial_cols = 210,

  -- Window padding for macOS aesthetics
  window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  },

  -- Window decorations
  window_decorations = "RESIZE",

  -- Font rendering features
  harfbuzz_features = { "calt=1", "clig=1", "liga=1" },

  -- Scroll
  scrollback_lines = 10000,
  enable_scroll_bar = true,

    -- Font settings
    font_size = 13.0,
    font = wezterm.font_with_fallback({
      "DroidSansMono Nerd Font",
      "JetBrains Mono",
    }),
    font_rules = {
      {
          italic = true,
          font = wezterm.font("DroidSansMono Nerd Font", {italic=true}),
          font = wezterm.font("JetBrains Mono", {italic=true}),
      }
    },

  -- Appearance settings
  color_scheme = "Builtin Solarized Dark",
  macos_window_background_blur = 10,
  use_fancy_tab_bar = false,

  -- Cursor settings
  default_cursor_style = "BlinkingUnderline",  -- Sets cursor to blinking underline
  cursor_blink_rate = 500,  -- Blink rate in milliseconds
  cursor_thickness = 2.0,   -- Thickness of the cursor

  -- Keyboard

  send_composed_key_when_left_alt_is_pressed = true,
  send_composed_key_when_right_alt_is_pressed = true,

  -- Modifiers: CTRL|SHIFT|CMD|ALT|OPT|META
  keys = {
    -- Existing shortcuts
    { key = "t", mods = "CMD", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
    { key = "w", mods = "CMD", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
    { key = "k", mods = "CMD", action = wezterm.action.ClearScrollback("ScrollbackAndViewport") },
    { key = "1", mods = "CMD", action = wezterm.action.ActivateTab(0) },
    { key = "2", mods = "CMD", action = wezterm.action.ActivateTab(1) },
    { key = "3", mods = "CMD", action = wezterm.action.ActivateTab(2) },
    { key = "4", mods = "CMD", action = wezterm.action.ActivateTab(3) },
    { key = "c", mods = "CMD", action = wezterm.action.SendKey{ key = "c", mods = "CMD" } },
    { key = "d", mods = "CMD", action = wezterm.action.SendKey{ key = "d", mods = "CMD" } },
    { key = "z", mods = "CMD", action = wezterm.action.SendKey{ key = "z", mods = "CMD" } },
  },
}

return config
