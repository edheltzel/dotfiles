local wezterm = require("wezterm")
local fish_path = "/opt/homebrew/bin/fish"

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end
config.default_prog = { fish_path, "-l" }

-- -----------------------------------------------------------------------------
-- Workspace Multiplexing
-- -----------------------------------------------------------------------------
config.unix_domains = {
  { name = "core" },
}

-- -----------------------------------------------------------------------------
-- General Config
-- -----------------------------------------------------------------------------
config.font = wezterm.font_with_fallback({
  {
    family = "VictorMono Nerd Font Mono",
    weight = 500,
    scale = 1.7,
  },
  {
    family = "FiraCode Nerd Font Mono",
    weight = 400,
    scale = 1.7,
  },
})
config.color_scheme = "Eldritch"
local colorRed = "#F7768E"
local colorPurple = "#A48CF2"
local colorCyan = "#04D1F9"

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

-- Custom tab titles: show CWD for inactive tabs, process name for active tab
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

  -- Truncate if too long
  if #title > max_width - 2 then
    title = string.sub(title, 1, max_width - 5) .. "..."
  end

  return title
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
