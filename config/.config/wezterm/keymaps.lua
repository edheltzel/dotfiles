-- keymaps.lua: Leader key, key bindings, and key tables.
-- Exports leader, keys, and key_tables for the config.

local wezterm = require("wezterm")
local act = wezterm.action

local leader = { key = "k", mods = "SUPER", timeout_milliseconds = 1502, desc = "leader key cmd+k" }
local keys = {
  -- Command palette aliases
  { key = "p", mods = "LEADER", action = act.ActivateCommandPalette, desc = "command palette w/ cmd+k p" },
  { key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette, desc = "command palette w/ cmd+k space" },

  -- natural editing
  { key = "RightArrow", mods = "OPT", action = act.SendKey({ mods = "ALT", key = "f" }) },
  { key = "LeftArrow", mods = "OPT", action = act.SendKey({ mods = "ALT", key = "b" }) },
  { key = "LeftArrow", mods = "CMD", action = act.SendKey({ mods = "CTRL", key = "a" }) },
  { key = "RightArrow", mods = "CMD", action = act.SendKey({ mods = "CTRL", key = "e" }) },
  { key = "Backspace", mods = "CMD", action = act.SendKey({ mods = "CTRL", key = "u" }) },

  ---- START LEADER KEY
  {
    key = "k",
    mods = "LEADER",
    action = act.Multiple({
      act.SendKey({ key = "C", mods = "CTRL" }),
      act.SendKey({ key = "L", mods = "CTRL" }),
    }),
    desc = "clear the screen w/ cmd+k k",
  },
  -- New window/tab/pane
  { key = "n", mods = "LEADER", action = act.SpawnWindow, desc = "new window w/ cmd+k n" },
  {
    key = "t",
    mods = "LEADER",
    action = act.SpawnTab("CurrentPaneDomain"),
    desc = "new tab w/ cmd+k t",
  },
  {
    key = "x",
    mods = "LEADER",
    action = act.CloseCurrentPane({ confirm = false }),
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
  -- Ghostty style Split directions (h=left, j=down, l=right, u=up) k is used to clear
  { key = "h", mods = "LEADER", action = act.SplitPane({ direction = "Left" }), desc = "split left w/ cmd+k h" },
  {
    key = "l",
    mods = "LEADER",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    desc = "split right w/ cmd+k l",
  },
  {
    key = "j",
    mods = "LEADER",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    desc = "split down w/ cmd+k j",
  },
  { key = "u", mods = "LEADER", action = act.SplitPane({ direction = "Up" }), desc = "split up w/ cmd+k u" },

  -- Zoom/Focus a pane
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState, desc = "maximize pane w/ cmd+k z" },

  --- ---------------------------------------------------------------------------
  -- these will jump you into a modes for wezterm
  --- ---------------------------------------------------------------------------
  { key = "c", mods = "LEADER", action = act.ActivateCopyMode, desc = "copy mode w/ cmd+k c" },

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
  -- resize pane
  {
    key = "r",
    mods = "LEADER",
    action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
    desc = "resize pane w/ cmd+k r -> use h,j,k,l to resize",
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

  { key = "n", mods = "SUPER|CTRL", action = act.SwitchWorkspaceRelative(1), desc = "Next Workspace" },
  { key = "p", mods = "SUPER|CTRL|ALT", action = act.SwitchWorkspaceRelative(-1), desc = "Previous Workspace" },
  { key = "B", mods = "LEADER", action = act.ShowDebugOverlay, desc = "Debug Overlay" },
  ---- END LEADER KEY

  { key = "=", mods = "CMD|CTRL", action = act.CloseCurrentPane({ confirm = false }), desc = "Close Terminal" },
  { key = "w", mods = "CMD|SHIFT", action = act.QuitApplication, desc = "Close Window" },
  { key = "f", mods = "CMD|CTRL", action = act.ToggleFullScreen, desc = "Full Screen" },

  {
    key = "T",
    mods = "LEADER",
    action = act.ShowTabNavigator,
    desc = "Tab Navigator",
  },
  -- Tabs/Panes keybindings
  { key = "[", mods = "SUPER|SHIFT", action = act.ActivateTabRelative(0), desc = "Previous Tab" },
  { key = "]", mods = "SUPER|SHIFT", action = act.ActivateTabRelative(2), desc = "Next Tab" },

  { key = "]", mods = "SUPER", action = act.ActivatePaneDirection("Next"), desc = "Next Pane" },
  { key = "[", mods = "SUPER", action = act.ActivatePaneDirection("Prev"), desc = "Previous Pane" },

  -- Reload config
  {
    key = ",",
    mods = "SUPER|CTRL|ALT",
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

  -- fzf.fish keybindings - Cmd+Ctrl sends Ctrl+Alt sequences to fish
  { key = "f", mods = "SUPER|CTRL", action = act.SendString("\x1b\x06"), desc = "fzf: Search Directory" },
  { key = "l", mods = "SUPER|CTRL", action = act.SendString("\x1b\x0c"), desc = "fzf: Search Git Log" },
  { key = "s", mods = "SUPER|CTRL", action = act.SendString("\x1b\x13"), desc = "fzf: Search Git Status" },
  { key = "r", mods = "SUPER|CTRL", action = act.SendString("\x12"), desc = "fzf: Search History" },
  { key = "p", mods = "SUPER|CTRL", action = act.SendString("\x1b\x10"), desc = "fzf: Search Processes" },
  { key = "v", mods = "SUPER|CTRL", action = act.SendString("\x16"), desc = "fzf: Search Variables" },
  { key = "Enter", mods = "SHIFT", action = act.SendString("\x1b\r"), desc = "fzf: Accept entry" },

  -- Quick-access split/resize (matching Ghostty's super+ctrl+alt bindings)
  {
    key = "\\",
    mods = "SUPER|CTRL|ALT",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    desc = "split right",
  },
  {
    key = "-",
    mods = "SUPER|CTRL|ALT",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    desc = "split down",
  },
  { key = "h", mods = "SUPER|CTRL|ALT", action = act.AdjustPaneSize({ "Left", 10 }), desc = "resize pane left" },
  { key = "j", mods = "SUPER|CTRL|ALT", action = act.AdjustPaneSize({ "Down", 10 }), desc = "resize pane down" },
  { key = "k", mods = "SUPER|CTRL|ALT", action = act.AdjustPaneSize({ "Up", 10 }), desc = "resize pane up" },
  { key = "l", mods = "SUPER|CTRL|ALT", action = act.AdjustPaneSize({ "Right", 10 }), desc = "resize pane right" },
  { key = "z", mods = "SUPER|CTRL|ALT", action = act.TogglePaneZoomState, desc = "toggle zoom" },
  { key = ",", mods = "SUPER|CTRL|ALT", action = act.ReloadConfiguration, desc = "reload config" },
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
