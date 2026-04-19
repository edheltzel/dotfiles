-- workspaces.lua: Startup workspace layouts via gui-startup event.
-- Uses wezterm.mux to spawn named workspaces with custom pane splits.

local wezterm = require("wezterm")
local mux = wezterm.mux

local function setup()
  wezterm.on("gui-startup", function(cmd)
    -- Default Workspace: single tab, single pane
    mux.spawn_window(cmd or { workspace = wezterm.nerdfonts.md_delta .. " HQ" })

    -- 3-pane split layout workspace
    --   ┌────────────┬────────────┐
    --   │    left    │            │
    --   │    top     │            │
    --   ├────────────┤    main    │
    --   │    left    │   (nvim)   │
    --   │   bottom   │            │
    --   └────────────┴────────────┘
    local _, left_pane = mux.spawn_window({
      workspace = wezterm.nerdfonts.md_triforce,
      cwd = wezterm.home_dir .. "/Developer/MyChronSystems/MyChron",
    })
    local right_pane = left_pane:split({
      direction = "Right",
      size = 0.6,
      cwd = wezterm.home_dir,
    })
    left_pane:split({
      direction = "Bottom",
      size = 0.5,
      cwd = wezterm.home_dir .. "/Developer/MyChronSystems/MyChron",
    })
    right_pane:send_text("nvim\n")

    -- Start in the default workspace
    mux.set_active_workspace(wezterm.nerdfonts.md_delta)
  end)
end

return { setup = setup }
