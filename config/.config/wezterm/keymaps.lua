local wezterm = require("wezterm")
local act = wezterm.action

local leader = { key = "k", mods = "SUPER", timeout_milliseconds = 1502, desc = "leader key cmd+k" }
local keys = {
  ---- START LEADER KEY
  { key = "c", mods = "LEADER", action = act.ActivateCopyMode, desc = "copy mode w/ cmd+k c" },
  { key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette, desc = "command palette w/ cmd+k space" },
  {
    key = "k",
    mods = "LEADER",
    action = act.Multiple({
      act.SendKey({ key = "C", mods = "CTRL" }),
      act.SendKey({ key = "L", mods = "CTRL" }),
    }),
    desc = "clear the screen w/ cmd+k k",
  },
  {
    key = "x",
    mods = "LEADER",
    action = act.CloseCurrentPane({ confirm = true }),
    desc = "close the current pane/tab/window",
  },
  {
    key = "-",
    mods = "LEADER",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    desc = "split panes w/ cmd+k | (vertical)",
  },
  {
    key = "\\",
    mods = "LEADER",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    desc = "split panes w/ cmd+k - (horizontal)",
  },
  {
    key = "r",
    mods = "LEADER",
    action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
    desc = "resize pane w/ cmd+k r -> use h,j,k,l to resize",
  },

  -- natural editing
  { key = "RightArrow", mods = "OPT", action = act.SendKey({ mods = "ALT", key = "f" }) },
  { key = "LeftArrow", mods = "OPT", action = act.SendKey({ mods = "ALT", key = "b" }) },
  { key = "LeftArrow", mods = "CMD", action = act.SendKey({ mods = "CTRL", key = "a" }) },
  { key = "RightArrow", mods = "CMD", action = act.SendKey({ mods = "CTRL", key = "e" }) },
  { key = "Backspace", mods = "CMD", action = act.SendKey({ mods = "CTRL", key = "u" }) },

  -- create new tab
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState, desc = "maximize pane w/ cmd+k z" },
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
  --- ---------------------------------------------------------------------------
  -- Workspace and Multiplexing
  --- ---------------------------------------------------------------------------
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
    desc = "Create A Workspace",
  },
  {
    key = "s",
    mods = "LEADER",
    action = act.ShowLauncherArgs({ title = "Workspaces", flags = "FUZZY|WORKSPACES" }),
    desc = "Switch Workspace",
  },
  {
    key = "E",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "Set Workspace Title...",
      action = wezterm.action_callback(function(win, pane, line)
        if line then
          wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
        end
      end),
    }),
    desc = "Rename Workspace",
  },
  { key = "n", mods = "SUPER|CTRL|ALT", action = act.SwitchWorkspaceRelative(1), desc = "Next Workspace" },
  { key = "p", mods = "SUPER|CTRL|ALT", action = act.SwitchWorkspaceRelative(-1), desc = "Previous Workspace" },
  { key = "B", mods = "LEADER", action = act.ShowDebugOverlay, desc = "Debug Overlay" },
  ---- END LEADER KEY

  { key = "=", mods = "CMD|CTRL", action = act.CloseCurrentPane({ confirm = true }), desc = "Close Terminal" },
  { key = "f", mods = "CMD|CTRL", action = act.ToggleFullScreen, desc = "Full Screen" },

  -- resize window/pane/splits see :36 cmd+k r -> use h,j,k,l to resize
  -- {
  --   key = "LeftArrow",
  --   mods = "SUPER|CTRL",
  --   action = act.AdjustPaneSize({ "Left", 6 }),
  -- },
  -- { key = "DownArrow", mods = "SUPER|CTRL", action = act.AdjustPaneSize({ "Down", 6 }) },
  -- { key = "UpArrow", mods = "SUPER|CTRL", action = act.AdjustPaneSize({ "Up", 6 }) },
  -- {
  --   key = "RightArrow",
  --   mods = "SUPER|CTRL",
  --   action = act.AdjustPaneSize({ "Right", 6 }),
  -- },
  {
    key = "T",
    mods = "LEADER",
    action = act.ShowTabNavigator,
    desc = "Tab Navigator",
  },
  -- Tabs/Panes keybindings
  { key = "[", mods = "SUPER|SHIFT", action = act.ActivateTabRelative(0), desc = "Previous Tab" },
  { key = "]", mods = "SUPER|SHIFT", action = act.ActivateTabRelative(2), desc = "Next Tab" },
  { key = "[", mods = "SUPER|CTRL|ALT", action = act.ActivateWindowRelative(1), desc = "Previous Window" },
  { key = "]", mods = "SUPER|CTRL|ALT", action = act.ActivateWindowRelative(-1), desc = "Next Window" },

  { key = "]", mods = "SUPER", action = act.ActivatePaneDirection("Next"), desc = "Next Pane" },
  { key = "[", mods = "SUPER", action = act.ActivatePaneDirection("Prev"), desc = "Previous Pane" },

  -- Reload config
  {
    key = ",",
    mods = "SUPER|CTRL",
    action = act.ReloadConfiguration,
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
