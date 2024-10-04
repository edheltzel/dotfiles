local wezterm = require("wezterm")
local act = wezterm.action

local fish_path = "/opt/homebrew/bin/fish"

local config = {}
-- Use config builder object if possible
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Settings
config.default_prog = { fish_path, "-l" }

config.color_scheme = "Solarized Dark Higher Contrast"
config.font = wezterm.font_with_fallback({
  { family = "Cascadia Code NF", scale = 1.5 },
  { family = "FiraCode Nerd Font Mono", scale = 1.3 },
})
config.macos_window_background_blur = 10
config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "main"

-- Dim inactive panes
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.5,
}

-- Custom tab bar colors
config.colors = {
  tab_bar = {
    background = "#002b36", -- Solarized base03

    active_tab = {
      bg_color = "#073642", -- Solarized base02
      fg_color = "#93a1a1", -- Solarized base1
    },

    inactive_tab = {
      bg_color = "#002b36", -- Solarized base03
      fg_color = "#839496", -- Solarized base0
    },

    inactive_tab_hover = {
      bg_color = "#586e75", -- Solarized base01
      fg_color = "#93a1a1", -- Solarized base1
    },

    new_tab = {
      bg_color = "#073642", -- Solarized base02
      fg_color = "#93a1a1", -- Solarized base1
    },

    new_tab_hover = {
      bg_color = "#586e75", -- Solarized base01
      fg_color = "#93a1a1", -- Solarized base1
    },
  },
    -- Pane split color
  split = "#073642", -- Solarized base02
}

-- Keys - iTerm-ish
config.leader = { key = "k", mods = "SUPER", timeout_milliseconds = 1500 }
config.keys = {
  { key = "c", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },

  -- Natural Editing
  -- Bind Cmd+Backspace to delete the entire line
  {
    key = 'Backspace',
    mods = 'CMD',
    action = wezterm.action.SendString('\x15'), -- Ctrl+U
  },
  -- Bind Cmd+LeftArrow to move to the start of the line
  {
    key = 'LeftArrow',
    mods = 'CMD',
    action = wezterm.action.SendString('\x01'), -- Ctrl+A
  },
  {
    key = 'h',
    mods = 'CMD|CTRL',
    action = wezterm.action.SendString('\x01'), -- Ctrl+A
  },
  -- Bind Cmd+RightArrow to move to the end of the line
  {
    key = 'RightArrow',
    mods = 'CMD',
    action = wezterm.action.SendString('\x05'), -- Ctrl+E
  },
  {
    key = 'l',
    mods = 'CMD|CTRL',
    action = wezterm.action.SendString('\x05'), -- Ctrl+E
  },
  -- Bind Leader+k to run the `clear` command
  {
    key = 'k',
    mods = 'LEADER',
    action = wezterm.action.Multiple {
      wezterm.action.SendKey { key = 'C', mods = 'CTRL' },
      wezterm.action.SendKey { key = 'L', mods = 'CTRL' },
    },
  },
  -- Bind Cmd+Ctrl+= to close the active pane
  {
    key = '=',
    mods = 'CMD|CTRL',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },

  -- Pane keybindings
  { key = "d", mods = "SUPER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "SUPER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "]", mods = "SUPER", action = act.ActivatePaneDirection("Next") },
  { key = "[", mods = "SUPER", action = act.ActivatePaneDirection("Prev") },
  { key = "w", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }), },

  -- Tab keybindings
  { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "[", mods = "SUPER|SHIFT", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "SUPER|SHIFT", action = act.ActivateTabRelative(1) },
  { key = "n", mods = "LEADER", action = act.ShowTabNavigator },
  {
    key = "e",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { AnsiColor = "Fuchsia" } },
        { Text = "Renaming Tab Title...:" },
      }),
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
  -- Key table for moving tabs around
  { key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
  { key = "[", mods = "SUPER|CTRL", action = act.MoveTabRelative(-1) },
  { key = "]", mods = "SUPER|CTRL", action = act.MoveTabRelative(1) },

  -- Workspace
  { key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
}
-- Jump to a tab with index (⌘+k 1-9 OR ⌘+1-9 )
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1),
  })
end

config.key_tables = {
  resize_pane = {
    { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter", action = "PopKeyTable" },
  },
  move_tab = {
    { key = "h", action = act.MoveTabRelative(-1) },
    { key = "j", action = act.MoveTabRelative(-1) },
    { key = "k", action = act.MoveTabRelative(1) },
    { key = "l", action = act.MoveTabRelative(1) },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter", action = "PopKeyTable" },
  },
}

-- Tab bar
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = false
wezterm.on("update-status", function(window, pane)
  -- Workspace name
  local stat = window:active_workspace()
  local stat_color = "#f7768e"
  -- Utilize this to display LDR or current key table name
  if window:active_key_table() then
    stat = window:active_key_table()
    stat_color = "#7dcfff"
  end
  if window:leader_is_active() then
    stat = "LDR"
    stat_color = "#bb9af7"
  end

  local basename = function(s)
    -- Nothing a little regex can't fix
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
  end

  -- Current working directory
  local cwd = pane:get_current_working_dir()
  if cwd then
    if type(cwd) == "userdata" then
      -- Wezterm introduced the URL object in 20240127-113634-bbcac864
      cwd = basename(cwd.file_path)
    else
      -- 20230712-072601-f4abf8fd or earlier version
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
    { Text = " |" },
  }))

  -- Right status
  window:set_right_status(wezterm.format({
    -- Wezterm has a built-in nerd fonts
    -- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
    { Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
    { Text = " | " },
    { Foreground = { Color = "#e0af68" } },
    { Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
    "ResetAttributes",
    { Text = " | " },
    { Text = wezterm.nerdfonts.md_clock .. "  " .. time },
    { Text = "  " },
  }))
end)

return config
