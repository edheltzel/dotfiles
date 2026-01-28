local wezterm = require("wezterm")
local fish_path = "/opt/homebrew/bin/fish"

-- Helper: extract basename from path
local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end
config.default_prog = { fish_path, "-l" }

-- -----------------------------------------------------------------------------
-- General Config
-- -----------------------------------------------------------------------------
config.enable_kitty_keyboard = true
config.enable_csi_u_key_encoding = false

config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

config.font = wezterm.font_with_fallback({
  {
    family = "Lilex Nerd Font Mono",
    weight = 400,
  },
  {
    family = "FiraCode Nerd Font Mono",
    weight = 400,
  },
})
config.font_size = 18.0

-- Theme selection: "Eldritch", "rose-pine", "rose-pine-moon", "rose-pine-dawn"
local theme = "Eldritch"
config.color_scheme = theme

-- Theme-aware accent colors
local colorRed, colorPurple, colorCyan, colorYellow, colorPink, colorWhite
if theme == "rose-pine-dawn" then
  colorRed = "#b4637a" -- love
  colorPurple = "#907aa9" -- iris
  colorCyan = "#56949f" -- foam
  colorYellow = "#ea9d34" -- gold
  colorPink = "#d7827e" -- rose
  colorWhite = "#575279" -- text
elseif theme:match("^rose%-pine") then
  colorRed = "#eb6f92" -- love
  colorPurple = "#c4a7e7" -- iris
  colorCyan = "#9ccfd8" -- foam
  colorYellow = "#f6c177" -- gold
  colorPink = "#ebbcba" -- rose
  colorWhite = "#e0def4" -- text
else -- Eldritch
  colorRed = "#F16C75"
  colorPurple = "#A48CF2"
  colorCyan = "#04D1F9"
  colorYellow = "#F7F67F"
  colorPink = "#F265B5"
  colorWhite = "#EBFAFA"
end

local keymaps = require("keymaps")
config.leader = keymaps.leader
config.keys = keymaps.keys
config.key_tables = keymaps.key_tables

config.cursor_blink_rate = 500
config.default_cursor_style = "BlinkingBar"
config.hide_mouse_cursor_when_typing = true
config.audible_bell = "SystemBeep"
config.max_fps = 240
-- initial window size
config.initial_cols = 100
config.initial_rows = 50
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.macos_window_background_blur = 25
config.scrollback_lines = 5000
config.default_workspace = wezterm.nerdfonts.cod_rocket

config.inactive_pane_hsb = {
  saturation = 0.9, -- Slightly reduce saturation for a muted effect
  brightness = 0.5, -- Dim brightness to half for a clear distinction
}

-- Tab bar
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = true

wezterm.on("update-status", function(window, pane)
  -- Workspace name
  local stat = window:active_workspace()
  local stat_color = colorRed

  -- Utilize this to display LDR or current key table name
  if window:active_key_table() then
    stat = window:active_key_table()
    stat_color = colorPurple
  end
  if window:leader_is_active() then
    stat = wezterm.nerdfonts.md_lightning_bolt .. wezterm.nerdfonts.md_lightning_bolt
    stat_color = colorCyan
  end

  -- Current working directory
  local cwd = pane:get_current_working_dir()
  if cwd then
    if type(cwd) == "userdata" then
      cwd = basename(cwd.file_path)
    else
      cwd = basename(cwd)
    end
  else
    cwd = ""
  end

  -- Current command
  local cmd = pane:get_foreground_process_name()

  -- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
  cmd = cmd and basename(cmd) or ""

  -- Time
  local time = wezterm.strftime("%H:%M")

  -- Left status (left of the tab line)
  window:set_left_status(wezterm.format({
    { Foreground = { Color = stat_color } },
    { Text = "  " },
    { Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
    { Text = " ⋮ " },
  }))

  -- Right status
  window:set_right_status(wezterm.format({
    -- CWD: pink icon, white text
    { Foreground = { Color = colorPink } },
    { Text = wezterm.nerdfonts.md_folder .. "  " },
    { Foreground = { Color = colorWhite } },
    { Text = cwd },
    { Text = " ⋮ " },
    -- Command: cyan icon, white text
    { Foreground = { Color = colorCyan } },
    { Text = wezterm.nerdfonts.fa_code .. "  " },
    { Foreground = { Color = colorWhite } },
    { Text = cmd },
    { Text = " ⋮ " },
    -- Time: yellow icon, white text
    { Foreground = { Color = colorYellow } },
    { Text = wezterm.nerdfonts.md_clock .. "  " },
    { Foreground = { Color = colorWhite } },
    { Text = time },
    { Text = "  " },
  }))
end)

return config
