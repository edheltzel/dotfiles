-- configuration.lua: All WezTerm config settings — shell, rendering, font,
-- cursor, window, panes, and tab bar options.

local wezterm = require("wezterm")

local function setup(theme, keymaps)
  local config = {}
  if wezterm.config_builder then
    config = wezterm.config_builder()
  end

  -- Shell
  config.default_prog = { "/opt/homebrew/bin/fish", "-l" }

  -- Input
  config.enable_kitty_keyboard = true
  config.enable_csi_u_key_encoding = false

  -- Rendering
  config.front_end = "WebGpu"
  config.webgpu_power_preference = "HighPerformance"

  -- Font (light themes get bolder weight for readability)
  local font_weight = theme.name == "rose-pine-dawn" and "DemiBold" or "Regular"
  config.font = wezterm.font_with_fallback({
    { family = "VictorMono Nerd Font", weight = font_weight },
    { family = "Lilex Nerd Font Mono", weight = font_weight },
    { family = "FiraCode Nerd Font Mono", weight = font_weight },
  })
  config.font_size = 19.0

  -- Theme
  config.color_scheme = theme.name

  -- Keymaps
  config.leader = keymaps.leader
  config.keys = keymaps.keys
  config.key_tables = keymaps.key_tables

  -- Cursor & window
  config.cursor_blink_rate = 500
  config.default_cursor_style = "BlinkingBar"
  config.hide_mouse_cursor_when_typing = true
  config.audible_bell = "SystemBeep"
  config.max_fps = 240
  config.initial_cols = 100
  config.initial_rows = 50
  config.window_decorations = "RESIZE"
  config.window_close_confirmation = "AlwaysPrompt"
  config.macos_window_background_blur = 25
  config.scrollback_lines = 5000
  config.default_workspace = wezterm.nerdfonts.cod_rocket
  config.native_macos_fullscreen_mode = false

  -- Panes
  config.inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.5,
  }

  -- Tab bar (override color scheme's tab_bar background to match theme.lua)
  config.use_fancy_tab_bar = false
  config.status_update_interval = 1000
  config.tab_bar_at_bottom = true
  config.colors = {
    tab_bar = {
      background = theme.tab_bar.bg,
    },
  }

  return config
end

return { setup = setup }
