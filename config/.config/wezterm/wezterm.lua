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
  active = false,
  padding_percent = 0.25,
}

local function apply_zen_padding(window)
  if not zen_state.active then
    return
  end

  local window_dims = window:get_dimensions()
  local padding = math.floor(window_dims.pixel_width * zen_state.padding_percent)
  local overrides = window:get_config_overrides() or {}

  if overrides.window_padding and overrides.window_padding.left == padding then
    return
  end

  overrides.window_padding = {
    left = padding,
    right = padding,
    top = 0,
    bottom = 0,
  }
  window:set_config_overrides(overrides)
end

local function toggle_zen_mode(window, pane)
  local overrides = window:get_config_overrides() or {}

  if zen_state.active then
    -- Exit zen mode
    overrides.window_padding = nil
    zen_state.active = false
    window:set_config_overrides(overrides)
  else
    -- Enter zen mode
    zen_state.active = true
    apply_zen_padding(window)
  end
end

wezterm.on("toggle-zen-mode", function(window, pane)
  toggle_zen_mode(window, pane)
end)

-- Recalculate padding when window is resized
wezterm.on("window-resized", function(window, pane)
  apply_zen_padding(window)
end)

return config
