-- tabs.lua: Tab rendering — pill-shaped tabs, process colors, process icons,
-- agent detection (robot icon), and an unseen-output dot.
--
-- Agent detection uses update-status (1s timer, full Pane API) to cache state,
-- which format-tab-title reads for rendering. This is needed because agents like
-- Claude Code run as Node.js processes — foreground_process_name is "node", not
-- "claude". The full Pane API gives us argv to identify the actual command.

local wezterm = require("wezterm")

-- Hot-path locals: see statusbar.lua for rationale. Resolved once at load.
local wz_truncate_right = wezterm.truncate_right
local nf = wezterm.nerdfonts
local NF_ROBOT = nf.fa_robot
local NF_TERMINAL = nf.cod_terminal
local NF_UNSEEN = nf.cod_circle_filled
local NF_PLE_L = nf.ple_left_half_circle_thick
local NF_PLE_R = nf.ple_right_half_circle_thick

local function setup(theme)
  local colors = theme.colors
  local tab_bar = theme.tab_bar
  local basename = theme.basename

  -- Agent state cache: pane_id → "idle" | "working"
  -- Populated by update-status, read by format-tab-title
  local agent_state = {}

  -- Process accent-color cache: pane_id → color.
  -- Resolved in update-status via the full Pane API (like agent_state) because
  -- PaneInformation.foreground_process_name in format-tab-title is unreliable.
  local pane_proc_color = {}

  -- Process-to-color mapping for tab coloring (process name → accent color).
  -- Resolved from the active pane's title/foreground process (same path as
  -- process icons), not from the CWD.
  local process_colors = {
    nvim = colors.purple,
    herdr = colors.cyan,
    claude = colors.orange,
    pi = colors.yellow,
    omp = colors.pink,
    -- Add processes: ["my-tool"] = colors.red,
  }

  -- Check if argv contains a known agent name
  local function argv_has_agent(info)
    if not info or not info.argv then
      return false
    end
    local argv_str = table.concat(info.argv, " ")
    for name, _ in pairs(theme.agent_processes) do
      if argv_str:find(name) then
        return true
      end
    end
    return false
  end

  -- Agent detection (runs every ~1s via update-status timer)
  -- Uses full Pane objects to inspect process argv and user_vars
  wezterm.on("update-status", function(window, pane)
    local new_state = {}
    local new_proc_color = {}
    for _, mux_tab in ipairs(window:mux_window():tabs()) do
      for _, p in ipairs(mux_tab:panes()) do
        local pane_id = p:pane_id()

        -- Foreground process argv: the reliable command identity. Wrapped CLIs
        -- defeat the other signals — Claude's foreground path basename is a
        -- version dir ("2.1.215") and its title is a spinner glyph, but
        -- argv[0] stays "claude" even while it is working.
        local argv0
        local ok_info, info = pcall(p.get_foreground_process_info, p)
        if ok_info and info and info.argv and info.argv[1] then
          argv0 = basename(info.argv[1])
        end

        -- Pane title carries identity for terminal apps (nvim, herdr).
        local title = p:get_title() or ""
        local title_cmd = title:match("^(%S+)")

        -- Process accent color: argv[0] first, then title, then fg basename.
        local fg_name = p:get_foreground_process_name()
        local pc = (argv0 and process_colors[argv0])
          or (title_cmd and process_colors[title_cmd])
          or (fg_name and process_colors[basename(fg_name)])
        if pc then
          new_proc_color[pane_id] = pc
        end

        -- Agent detection for idle/working coloring. WEZTERM_PROG is usually
        -- unset here, so match the agent name against argv[0] and title first.
        local is_agent = (argv0 and theme.agent_processes[argv0])
          or (title_cmd and theme.agent_processes[title_cmd])
          or false
        if not is_agent then
          local prog = (p:get_user_vars() or {}).WEZTERM_PROG or ""
          for name, _ in pairs(theme.agent_processes) do
            if prog:find(name) then
              is_agent = true
              break
            end
          end
        end

        if is_agent then
          -- Idle when the agent itself is foreground (argv holds the agent
          -- name); working when a child (git, rg, node) has taken over.
          local is_idle = (ok_info and info and argv_has_agent(info)) or false
          new_state[pane_id] = is_idle and "idle" or "working"
        end
      end
    end
    agent_state = new_state
    pane_proc_color = new_proc_color
  end)

  -- Pill-shaped tabs: process colors, process/robot icons, and an unseen dot
  wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    -- Check for unseen output (drives the unseen-output icon).
    local unseen = false
    local pane_list = tab.panes or panes or {}
    for _, p in ipairs(pane_list) do
      if p.has_unseen_output then
        unseen = true
        break
      end
    end

    -- Process accent color for the active pane, resolved+cached in update-status.
    local process_color = pane_proc_color[tab.active_pane.pane_id]

    -- Tab colors: active → process color as background (green fallback);
    -- inactive → the same process color as foreground text (muted gray fallback).
    local bg, fg
    if tab.is_active then
      bg = process_color or tab_bar.active_bg
      fg = tab_bar.active_fg
    else
      bg = tab_bar.inactive_bg
      fg = process_color or tab_bar.inactive_fg
    end

    -- Icon: unseen-output dot wins; otherwise lock to robot for agent panes
    -- (prevents flickering when an agent spawns subprocesses like git/node/rg).
    local proc = tab.active_pane.foreground_process_name or ""
    local icon
    if unseen then
      icon = NF_UNSEEN
    elseif agent_state[tab.active_pane.pane_id] then
      icon = NF_ROBOT
    else
      icon = theme.get_process_icon(tab.active_pane.title, basename(proc), NF_TERMINAL)
    end

    -- Build title with index and icon
    local index = tab.tab_index + 1
    local title = tab.tab_title and #tab.tab_title > 0 and tab.tab_title or tab.active_pane.title
    local formatted = index .. ": " .. icon .. " " .. title

    -- Truncate to fit (pill edges + padding = ~4 cells)
    formatted = wz_truncate_right(formatted, max_width - 4)

    return {
      { Background = { Color = tab_bar.bg } },
      { Foreground = { Color = bg } },
      { Text = NF_PLE_L },
      { Background = { Color = bg } },
      { Foreground = { Color = fg } },
      { Text = " " .. formatted .. " " },
      { Background = { Color = tab_bar.bg } },
      { Foreground = { Color = bg } },
      { Text = NF_PLE_R },
    }
  end)
end

return { setup = setup }
