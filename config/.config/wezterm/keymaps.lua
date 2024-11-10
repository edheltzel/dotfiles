local wezterm = require("wezterm")
local act = wezterm.action

-- Define the leader key
local leader = { key = "k", mods = "SUPER", timeout_milliseconds = 1500 }

-- Define key mappings
local keys = {
  { key = "c", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },

  -- Natural Editing
  { key = "Backspace", mods = "CMD", action = wezterm.action.SendString("\x15") }, -- Ctrl+U
  { key = "LeftArrow", mods = "CMD", action = wezterm.action.SendString("\x01") }, -- Ctrl+A
  { key = "h", mods = "CMD|CTRL", action = wezterm.action.SendString("\x01") }, -- Ctrl+A
  { key = "RightArrow", mods = "CMD", action = wezterm.action.SendString("\x05") }, -- Ctrl+E
  { key = "l", mods = "CMD|CTRL", action = wezterm.action.SendString("\x05") }, -- Ctrl+E
  --[[
   This clears the screen without clearning the scrollback but make sure to
   add a MacOS keyboard short for Wezterm to change the Clear scrollback to something
   else. I use `ctrl+shift+k` for this. This is workaround 
  --]]
  {
    key = "k",
    mods = "LEADER",
    action = wezterm.action.Multiple({
      wezterm.action.SendKey({ key = "C", mods = "CTRL" }),
      wezterm.action.SendKey({ key = "L", mods = "CTRL" }),
    }),
  },
  { key = "=", mods = "CMD|CTRL", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
  { key = "f", mods = "CMD|CTRL", action = wezterm.action.ToggleFullScreen },

  -- Pane keybindings
  { key = "d", mods = "SUPER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "SUPER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "]", mods = "SUPER", action = act.ActivatePaneDirection("Next") },
  { key = "[", mods = "SUPER", action = act.ActivatePaneDirection("Prev") },
  { key = "w", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  --maximize pane ↓
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },

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
  { key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
  { key = "[", mods = "SUPER|CTRL", action = act.MoveTabRelative(-1) },
  { key = "]", mods = "SUPER|CTRL", action = act.MoveTabRelative(1) },

  -- Workspace
  { key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
}

-- Jump to a tab with index (⌘+k 1-9 OR ⌘+1-9)
for i = 1, 9 do
  table.insert(keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1),
  })
end

-- Define key tables
local key_tables = {
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

return {
  leader = leader,
  keys = keys,
  key_tables = key_tables,
}
