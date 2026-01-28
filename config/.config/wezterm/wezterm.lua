local wezterm = require("wezterm")
local fish_path = "/opt/homebrew/bin/fish"

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
local colorRed, colorPurple, colorCyan, colorYellow, colorPink, colorGreen, colorWhite, colorMuted
if theme == "rose-pine-dawn" then
  colorRed = "#b4637a" -- love
  colorPurple = "#907aa9" -- iris
  colorCyan = "#56949f" -- foam
  colorYellow = "#ea9d34" -- gold
  colorPink = "#d7827e" -- rose
  colorGreen = "#286983" -- pine
  colorWhite = "#575279" -- text
  colorMuted = "#9893a5" -- subtle
elseif theme:match("^rose%-pine") then
  colorRed = "#eb6f92" -- love
  colorPurple = "#c4a7e7" -- iris
  colorCyan = "#9ccfd8" -- foam
  colorYellow = "#f6c177" -- gold
  colorPink = "#ebbcba" -- rose
  colorGreen = "#31748f" -- pine
  colorWhite = "#e0def4" -- text
  colorMuted = "#6e6a86" -- muted
else -- Eldritch
  colorRed = "#F16C75"
  colorPurple = "#A48CF2"
  colorCyan = "#04D1F9"
  colorYellow = "#F7F67F"
  colorPink = "#F265B5"
  colorGreen = "#37F499"
  colorWhite = "#EBFAFA"
  colorMuted = "#7081D0" -- alt purple / muted
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
config.scrollback_lines = 10000
config.default_workspace = wezterm.nerdfonts.cod_rocket

config.inactive_pane_hsb = {
  saturation = 0.9, -- Slightly reduce saturation for a muted effect
  brightness = 0.5, -- Dim brightness to half for a clear distinction
}

-- Tab bar
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = true

-- Pill-shaped tabs with NerdFont half-circle glyphs
local PILL_LEFT = wezterm.nerdfonts.ple_right_half_circle_thick
local PILL_RIGHT = wezterm.nerdfonts.ple_left_half_circle_thick
local TAB_BAR_BG = "#171928" -- Eldritch background

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab:active_pane()
  local title = ""

  if tab.is_active then
    -- Show process name for active tab
    local cmd = pane:get_foreground_process_name()
    if cmd and cmd ~= "" then
      title = basename(cmd)
    else
      title = "Terminal"
    end
  else
    -- Show current working directory for inactive tabs
    local cwd = pane:get_current_working_dir()
    if cwd then
      if type(cwd) == "userdata" then
        title = basename(cwd.file_path)
      else
        title = basename(cwd)
      end
    else
      title = "~"
    end
  end

  -- Truncate if too long (account for pill edges)
  if #title > max_width - 4 then
    title = wezterm.truncate_right(title, max_width - 6) .. "…"
  end

  -- Determine colors based on state
  local bg, fg
  if tab.is_active then
    bg = colorGreen -- #37F499
    fg = TAB_BAR_BG -- dark text on bright bg
  elseif hover then
    bg = "#3b3052" -- hover highlight
    fg = colorWhite
  else
    bg = "#212337" -- subtle inactive
    fg = colorMuted
  end

  return {
    { Background = { Color = TAB_BAR_BG } },
    { Foreground = { Color = bg } },
    { Text = PILL_LEFT },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = " " .. title .. " " },
    { Background = { Color = TAB_BAR_BG } },
    { Foreground = { Color = bg } },
    { Text = PILL_RIGHT },
  }
end)

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

  local basename = function(s)
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
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
