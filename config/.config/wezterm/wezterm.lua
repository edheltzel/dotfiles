local wezterm = require("wezterm")

local act = wezterm.action

-- Load key mappings and key tables from external file
-- see ./keybindings.lua
local keymaps = require("keymaps")

local fish_path = "/opt/homebrew/bin/fish"

local config = {}
-- Use config builder object if possible
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Settings
config.default_prog = { fish_path, "-l" }

-- Cursor
config.cursor_blink_rate = 500
config.default_cursor_style = "BlinkingBar"

-- Audio
-- config.audible_bell = "SystemBeep"

-- Load leader (super+k), maps and tables - see keymaps.lua
config.leader = keymaps.leader
config.keys = keymaps.keys
config.key_tables = keymaps.key_tables

-- Color Scheme - see: https://wezfurlong.org/wezmerm/colorschemes/index.html
-- see ./colors/eldritch.toml
config.color_scheme = "Eldritch"

-- Nerdfonts are baked into Wezterm
config.font = wezterm.font_with_fallback({
  { family = "Lilex", weight = "Regular", scale = 1.45 },
  { family = "CommitMono", weight = "Regular", scale = 1.45 },
})

-- Window Config
config.max_fps = 240
-- config.window_background_opacity = 0.85
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt" -- AlwaysPrompt | NeverPrompt
-- config.macos_window_background_blur = 30
-- config.window_background_image = "~/.wallpapers/wallpapers/getShitDone--dark.jpg"

config.scrollback_lines = 10000
config.default_workspace = wezterm.nerdfonts.cod_rocket

-- initial window size
config.initial_cols = 90
config.initial_rows = 40

-- Dim inactive panes with Eldritch theme
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
  local stat_color = "#F7768E"

  -- Utilize this to display LDR or current key table name
  if window:active_key_table() then
    stat = window:active_key_table()
    stat_color = "#BB9AF7"
  end
  if window:leader_is_active() then
    stat = wezterm.nerdfonts.md_lightning_bolt .. wezterm.nerdfonts.md_lightning_bolt
    stat_color = "#7DCFFF"
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
    { Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
    { Text = " ⋮ " },
    { Foreground = { Color = "#e0af68" } },
    { Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
    "ResetAttributes",
    { Text = " ⋮ " },
    { Text = wezterm.nerdfonts.md_clock .. "  " .. time },
    { Text = "  " },
  }))
end)

return config
