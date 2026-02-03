-- wezterm.lua: Orchestrator
--
-- Module map:
--   theme.lua         → Theme colors, tab bar palette, process icons, basename helper
--   configuration.lua → Config settings (shell, font, window, rendering)
--   keymaps.lua       → Leader key, key bindings, key tables
--   tabs.lua          → format-tab-title (pill tabs, project colors)
--   statusbar.lua     → update-status (workspace, CWD, git branch, command, time)
--   workspaces.lua    → gui-startup (named workspace layouts with pane splits)

local wezterm = require("wezterm")
local theme = require("theme")
local keymaps = require("keymaps")
local configuration = require("configuration")
local tabs = require("tabs")
local statusbar = require("statusbar")
local workspaces = require("workspaces")

local config = configuration.setup(theme, keymaps)

tabs.setup(theme)
statusbar.setup(theme)
workspaces.setup()

-- Zen Mode
local zen_state = {
  zen_windows = {}, -- Track which windows are zen windows by window_id
  padding_percent = 0.25,
  pending_zen = false, -- Flag to mark next focused window as zen
  source_window_id = nil, -- Track which window spawned the zen window
}

local function is_zen_window(window)
  local window_id = tostring(window:window_id())
  return zen_state.zen_windows[window_id] == true
end

local function apply_zen_padding(window)
  local overrides = window:get_config_overrides() or {}
  local window_dims = window:get_dimensions()
  local padding = math.floor(window_dims.pixel_width * zen_state.padding_percent)

  overrides.window_padding = {
    left = padding,
    right = padding,
    top = 0,
    bottom = 0,
  }
  overrides.enable_tab_bar = false
  window:set_config_overrides(overrides)
end

local function clear_zen_padding(window)
  local overrides = window:get_config_overrides() or {}
  overrides.window_padding = nil
  overrides.enable_tab_bar = nil
  window:set_config_overrides(overrides)
end

-- Toggle zen mode in CURRENT window (affects all tabs in this window)
wezterm.on("toggle-zen-mode", function(window, pane)
  local window_id = tostring(window:window_id())

  if zen_state.zen_windows[window_id] then
    -- Exit zen mode
    zen_state.zen_windows[window_id] = nil
    clear_zen_padding(window)
  else
    -- Enter zen mode
    zen_state.zen_windows[window_id] = true
    apply_zen_padding(window)
  end
end)

-- Spawn NEW zen window (isolated from other windows)
wezterm.on("spawn-zen-window", function(window, pane)
  local window_id = tostring(window:window_id())

  if zen_state.zen_windows[window_id] then
    -- Already in zen window, exit zen mode
    zen_state.zen_windows[window_id] = nil
    clear_zen_padding(window)
  else
    -- Spawn a new zen window, preserving cwd
    zen_state.pending_zen = true
    zen_state.source_window_id = window_id
    local cwd = pane:get_current_working_dir()
    local spawn_args = {}
    if cwd then
      spawn_args.cwd = cwd.file_path or cwd
    end
    window:perform_action(wezterm.action.SpawnCommandInNewWindow(spawn_args), pane)
  end
end)

-- Use update-status to detect and apply zen to newly spawned windows
wezterm.on("update-status", function(window, pane)
  local window_id = tostring(window:window_id())

  -- Check if this is a newly spawned zen window
  if zen_state.pending_zen and window_id ~= zen_state.source_window_id then
    zen_state.pending_zen = false
    zen_state.source_window_id = nil
    zen_state.zen_windows[window_id] = true
    apply_zen_padding(window)
  end
end)

-- Recalculate padding when window is resized
wezterm.on("window-resized", function(window, pane)
  if is_zen_window(window) then
    apply_zen_padding(window)
  end
end)

return config
