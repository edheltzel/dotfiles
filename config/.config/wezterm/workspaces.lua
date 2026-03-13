-- workspaces.lua: Startup workspace layouts via gui-startup event.
-- Uses wezterm.mux to spawn named workspaces with custom pane splits.

local wezterm = require("wezterm")
local mux = wezterm.mux

local function setup()
  wezterm.on("gui-startup", function(cmd)
    -- default workspace: single tab, single pane (rocket icon matches config.default_workspace)
    mux.spawn_window(cmd or { workspace = wezterm.nerdfonts.md_delta })

    -- "dotfiles" workspace: 3-pane split layout (disabled for Layered Harmony — Zellij owns panes)
    --   ┌────────────┬────────────┐
    --   │    left    │            │
    --   │    top     │            │
    --   ├────────────┤    main    │
    --   │    left    │   (nvim)   │
    --   │   bottom   │            │
    --   └────────────┴────────────┘
    -- local _, left_pane = mux.spawn_window({
    --   workspace = wezterm.nerdfonts.md_triforce,
    --   cwd = wezterm.home_dir .. "/Developer/GAT/MyChron",
    -- })
    -- local right_pane = left_pane:split({
    --   direction = "Right",
    --   size = 0.6,
    --   cwd = wezterm.home_dir,
    -- })
    -- left_pane:split({
    --   direction = "Bottom",
    --   size = 0.5,
    --   cwd = wezterm.home_dir .. "/Developer/GAT/MyChron",
    -- })
    -- right_pane:send_text("nvim\n")
    --
    -- -- Start in the default workspace
    -- mux.set_active_workspace(wezterm.nerdfonts.md_delta)
  end)
end

return { setup = setup }
