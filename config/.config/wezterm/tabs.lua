-- tabs.lua: Tab rendering — pill-shaped tabs, process icons, project colors,
-- agent activity detection, and unseen output indicators.
--
-- Agent detection uses update-status (1s timer, full Pane API) to cache state,
-- which format-tab-title reads for rendering. This is needed because agents like
-- Claude Code run as Node.js processes — foreground_process_name is "node", not
-- "claude". The full Pane API gives us argv to identify the actual command.

local wezterm = require("wezterm")

-- Hot-path locals: see statusbar.lua for rationale. Resolved once at load.
local wz_truncate_right = wezterm.truncate_right
local nf = wezterm.nerdfonts
local NF_ROBOT    = nf.fa_robot
local NF_TERMINAL = nf.cod_terminal
local NF_PLE_L    = nf.ple_left_half_circle_thick
local NF_PLE_R    = nf.ple_right_half_circle_thick

local function setup(theme)
  local colors = theme.colors
  local tab_bar = theme.tab_bar
  local basename = theme.basename

  -- Agent state cache: pane_id → "idle" | "working"
  -- Populated by update-status, read by format-tab-title
  local agent_state = {}

  -- Project-to-color mapping for tab coloring (directory name → accent color)
  local project_colors = {
    [".dotfiles"] = colors.cyan,
    neoed = colors.purple,
    ["atlas-config"] = colors.pink,
    -- Add projects: ["my-project"] = colors.pink,
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

  -- PERF_DEBUG: logs a warning to wezterm.log whenever a single update-status
  -- tick exceeds the threshold. Remove this block once the lag is diagnosed.
  local PERF_THRESHOLD_MS = 50

  -- Agent detection (runs every ~1s via update-status timer)
  -- Uses full Pane objects to inspect process argv and user_vars
  wezterm.on("update-status", function(window, pane)
    local _t0 = wezterm.time.now()
    local _pane_count = 0
    local _fg_info_calls = 0
    local _fg_info_ms = 0

    local new_state = {}
    for _, mux_tab in ipairs(window:mux_window():tabs()) do
      for _, p in ipairs(mux_tab:panes()) do
        _pane_count = _pane_count + 1
        local pane_id = p:pane_id()
        local is_agent = false

        -- Check pane title (most reliable — set by terminal, not process tree)
        local title = p:get_title() or ""
        local title_cmd = title:match("^(%S+)")
        if title_cmd and theme.agent_processes[title_cmd] then
          is_agent = true
        end

        -- Check user_vars (shell integration sets WEZTERM_PROG)
        if not is_agent then
          local vars = p:get_user_vars()
          local prog = vars.WEZTERM_PROG or ""
          for name, _ in pairs(theme.agent_processes) do
            if prog:find(name) then
              is_agent = true
              break
            end
          end
        end

        if is_agent then
          -- Determine idle vs working by checking if the agent itself is
          -- the foreground process. When idle, argv contains the agent name.
          -- When busy, a child (git, rg, bash) is the foreground process.
          local is_idle = false
          local _fg_t0 = wezterm.time.now()
          local ok, info = pcall(p.get_foreground_process_info, p)
          _fg_info_ms = _fg_info_ms + (wezterm.time.now() - _fg_t0):get_seconds() * 1000
          _fg_info_calls = _fg_info_calls + 1
          if ok and info then
            is_idle = argv_has_agent(info)
          end
          new_state[pane_id] = is_idle and "idle" or "working"
        end
      end
    end
    agent_state = new_state

    local _elapsed = (wezterm.time.now() - _t0):get_seconds() * 1000
    if _elapsed > PERF_THRESHOLD_MS then
      wezterm.log_warn(string.format(
        "[tabs.update-status] SLOW: %.1fms total, %d panes, %d get_fg_info calls (%.1fms)",
        _elapsed, _pane_count, _fg_info_calls, _fg_info_ms
      ))
    end
  end)

  -- Pill-shaped tabs with agent activity, project colors, and process icons
  wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    -- Check for unseen output and read cached agent state
    local unseen = false
    local agent_waiting = false
    local agent_working = false
    local pane_list = tab.panes or panes or {}
    for _, p in ipairs(pane_list) do
      if p.has_unseen_output then
        unseen = true
      end
      local state = agent_state[p.pane_id]
      if state == "idle" then
        agent_waiting = true
      elseif state == "working" then
        agent_working = true
      end
    end

    -- Detect project color from CWD
    local cwd_path = theme.get_cwd_path(tab.active_pane.current_working_dir)
    local project_color = cwd_path ~= "" and project_colors[basename(cwd_path)] or nil

    -- Determine tab colors
    -- Priority: active > agent idle > agent working (unseen) > unseen > project > default
    local bg, fg
    if tab.is_active then
      bg = project_color or tab_bar.active_bg
      fg = tab_bar.active_fg
    elseif agent_waiting then
      -- Agent idle/needs response: orange bg pill
      bg = tab_bar.agent_activity
      fg = tab_bar.active_fg
    elseif agent_working and unseen then
      -- Agent busy with unseen output: yellow text
      bg = tab_bar.inactive_bg
      fg = colors.yellow
    elseif unseen then
      bg = tab_bar.inactive_bg
      fg = colors.yellow
    elseif project_color then
      bg = tab_bar.inactive_bg
      fg = project_color
    else
      bg = tab_bar.inactive_bg
      fg = tab_bar.inactive_fg
    end

    -- Process icon: lock to robot for agent panes (prevents flickering
    -- when agent spawns subprocesses like git, node, rg)
    local proc = tab.active_pane.foreground_process_name or ""
    local icon
    if agent_state[tab.active_pane.pane_id] then
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
