local wezterm = require("wezterm")
local act = wezterm.action

-- Define the leader key -> ⌘+k
local leader = { key = "k", mods = "SUPER", timeout_milliseconds = 1502 }
local keys = {
  ---- START LEADER KEY
  -- copy mode with cmd+k c
  { key = "c", mods = "LEADER", action = act.ActivateCopyMode }, -- copy mode
  -- command palette with cmd+k space
  { key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },
  -- clear the screen with cmd+k k
  {
    key = "k",
    mods = "LEADER",
    action = wezterm.action.Multiple({
      wezterm.action.SendKey({ key = "C", mods = "CTRL" }),
      wezterm.action.SendKey({ key = "L", mods = "CTRL" }),
    }),
  },
  --maximize pane w/ cmd+k z
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  -- split panes w/ cmd+k | (vertical) and cmd+k - (horizontal)
  { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  -- resize pane w/ cmd+k r -> use h,j,k,l to resize
  { key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  -- create new tab
  { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "T", mods = "LEADER", action = act.ShowTabNavigator },
  { key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
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
  -- Workspace Multiplexing switcher
  {
    key = "S",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { AnsiColor = "Fuchsia" } },
        { Text = "Create A Workspace..." },
      }),
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            act.SwitchToWorkspace({
              name = line,
            }),
            pane
          )
        end
      end),
    }),
  },
  {
    key = "$",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "Set Workspace Title...",
      action = wezterm.action_callback(function(win, pane, line)
        if line then
          wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
        end
      end),
    }),
  },
  {
    key = "s",
    mods = "LEADER",
    action = act.ShowLauncherArgs({ title = "Workspaces", flags = "FUZZY|WORKSPACES" }),
  },
  { key = "n", mods = "SUPER|CTRL|ALT", action = act.SwitchWorkspaceRelative(2) },
  { key = "p", mods = "SUPER|CTRL|ALT", action = act.SwitchWorkspaceRelative(0) },
  -- debug overlay with cmd+k d
  { key = "d", mods = "LEADER", action = act.ShowDebugOverlay },
  ---- END LEADER KEY

  -- Natural Editing
  { key = "Backspace", mods = "CMD", action = wezterm.action.SendString("\x16") }, -- Ctrl+U
  { key = "LeftArrow", mods = "CMD", action = wezterm.action.SendString("\x02") }, -- Ctrl+A
  { key = "h", mods = "CMD|CTRL", action = wezterm.action.SendString("\x02") }, -- Ctrl+A
  { key = "RightArrow", mods = "CMD", action = wezterm.action.SendString("\x06") }, -- Ctrl+E
  { key = "l", mods = "CMD|CTRL", action = wezterm.action.SendString("\x06") }, -- Ctrl+E

  -- close the current pane/tab/window
  { key = "=", mods = "CMD|CTRL", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
  { key = "f", mods = "CMD|CTRL", action = wezterm.action.ToggleFullScreen },

  -- resize window/pane/splits
  {
    key = "LeftArrow",
    mods = "SUPER|CTRL",
    action = act.AdjustPaneSize({ "Left", 6 }),
  },
  { key = "DownArrow", mods = "SUPER|CTRL", action = act.AdjustPaneSize({ "Down", 6 }) },
  { key = "UpArrow", mods = "SUPER|CTRL", action = act.AdjustPaneSize({ "Up", 6 }) },
  {
    key = "RightArrow",
    mods = "SUPER|CTRL",
    action = act.AdjustPaneSize({ "Right", 6 }),
  },
  --
  -- Tabs/Panes keybindings
  { key = "[", mods = "SUPER|SHIFT", action = act.ActivateTabRelative(0) },
  { key = "]", mods = "SUPER|SHIFT", action = act.ActivateTabRelative(2) },
  { key = "[", mods = "SUPER|ALT", action = act.ActivateWindowRelative(1) },
  { key = "]", mods = "SUPER|ALT", action = act.ActivateWindowRelative(-1) },

  { key = "]", mods = "SUPER", action = act.ActivatePaneDirection("Next") },
  { key = "[", mods = "SUPER", action = act.ActivatePaneDirection("Prev") },

  -- Reload config
  {
    key = ",",
    mods = "SUPER|CTRL",
    action = wezterm.action.ReloadConfiguration,
  },

  -- Disable CTRL+SHIFT+L and CTRL+SHIFT+U to allow pass-through to Neovim
  {
    key = "L",
    mods = "CTRL|SHIFT",
    action = act.DisableDefaultAssignment,
  },
  {
    key = "U",
    mods = "CTRL|SHIFT",
    action = act.DisableDefaultAssignment,
  },
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
