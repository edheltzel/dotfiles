-- workspaces.lua: Startup workspace layouts via gui-startup event.
-- Uses wezterm.mux to spawn named workspaces with custom pane splits.

local wezterm = require("wezterm")
local mux = wezterm.mux

local HQ_WORKSPACE = wezterm.nerdfonts.md_delta .. " HQ"
local DOTFILES_WORKSPACE = wezterm.nerdfonts.md_triforce .. " dotfiles"
local DOTFILES_DIR = wezterm.home_dir .. "/.dotfiles"

local function setup()
  wezterm.on("gui-startup", function(cmd)
    -- If launched with a command (e.g. `wezterm ssh <host>`), honor it and
    -- skip the startup workspace layout entirely.
    if cmd then
      mux.spawn_window(cmd)
      return
    end

    -- Default Workspace: single tab, single pane
    mux.spawn_window({ workspace = HQ_WORKSPACE })

    -- 3-pane split layout workspace
    --   ┌────────────┬────────────┐
    --   │    left    │            │
    --   │    top     │            │
    --   ├────────────┤    main    │
    --   │    left    │   (nvim)   │
    --   │   bottom   │            │
    --   └────────────┴────────────┘
    local _, left_pane = mux.spawn_window({
      workspace = DOTFILES_WORKSPACE,
      cwd = DOTFILES_DIR,
    })
    local right_pane = left_pane:split({
      direction = "Right",
      size = 0.6,
      cwd = wezterm.home_dir,
    })
    left_pane:split({
      direction = "Bottom",
      size = 0.5,
      cwd = DOTFILES_DIR,
    })
    right_pane:send_text("nvim\n")

    -- Start in the default workspace
    mux.set_active_workspace(HQ_WORKSPACE)
  end)
end

return { setup = setup }
