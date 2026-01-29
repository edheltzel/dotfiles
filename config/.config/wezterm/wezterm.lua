-- wezterm.lua: Orchestrator — wires together all modules.
--
-- Module map:
--   theme.lua         → Theme colors, tab bar palette, process icons, basename helper
--   configuration.lua → Config settings (shell, font, window, rendering)
--   keymaps.lua       → Leader key, key bindings, key tables
--   tabs.lua          → format-tab-title (pill tabs, project colors)
--   statusbar.lua     → update-status (workspace, CWD, git branch, command, time)
--   workspaces.lua    → gui-startup (named workspace layouts with pane splits)

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

return config
