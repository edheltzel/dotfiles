-- workspaces.lua: Startup workspace layouts via gui-startup event.
-- Uses wezterm.mux to spawn named workspaces with custom pane splits.

local wezterm = require("wezterm")
local mux = wezterm.mux

local function setup()
  wezterm.on("gui-startup", function(cmd)
    -- default workspace: single tab, single pane (rocket icon matches config.default_workspace)
    mux.spawn_window(cmd or { workspace = wezterm.nerdfonts.cod_rocket })

    -- "dotfiles" workspace: 3-pane split layout
    --   ┌────────────┬────────────┐
    --   │            │   right    │
    --   │   main     │    top     │
    --   │            ├────────────┤
    --   │            │   right    │
    --   │            │   bottom   │
    --   └────────────┴────────────┘
    local _, project_pane = mux.spawn_window({
      workspace = wezterm.nerdfonts.md_triforce,
      cwd = wezterm.home_dir .. "/.dotfiles",
    })
    local right_pane = project_pane:split({
      direction = "Right",
      size = 0.5,
    })
    right_pane:split({
      direction = "Bottom",
      size = 0.5,
    })

    -- Start in the default workspace
    mux.set_active_workspace(wezterm.nerdfonts.cod_rocket)
  end)
end

return { setup = setup }
