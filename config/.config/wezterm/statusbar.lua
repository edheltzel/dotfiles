-- statusbar.lua: Left and right status bar rendering via the update-status event.
-- Includes workspace/leader display, CWD, git branch (cached), command, and session stats.

local wezterm = require("wezterm")

-- Hot-path locals: resolve module-level functions + constants once at load time.
-- In Lua 5.4 (WezTerm's runtime) globals/table lookups are ~20x slower than
-- local register access. Pays off every time update-status fires.
local wz_format = wezterm.format
local wz_truncate_right = wezterm.truncate_right
local nf = wezterm.nerdfonts
local NF_LIGHTNING = nf.md_lightning_bolt
local NF_LAYERS    = nf.cod_layers
local NF_FOLDER    = nf.md_folder
local NF_BRANCH    = nf.dev_git_branch
local NF_TAB       = nf.md_tab
local NF_PANE      = nf.md_view_split_vertical
local NF_CODE      = nf.fa_code

-- Walk up from cwd looking for a .git directory or file. Handles:
--   1. Regular repo:   <root>/.git/ (directory)
--   2. Worktree/submodule: <dir>/.git (file containing "gitdir: <path>")
-- Returns absolute path to the git dir, or nil if not inside a repo.
local function find_git_dir(cwd)
  if not cwd or cwd == "" then return nil end
  local path = cwd
  while path and path ~= "" and path ~= "/" do
    -- Case 1: .git is a directory with a HEAD file
    local head = io.open(path .. "/.git/HEAD", "r")
    if head then
      head:close()
      return path .. "/.git"
    end
    -- Case 2: .git is a file pointing to a gitdir
    local gitfile = io.open(path .. "/.git", "r")
    if gitfile then
      local first = gitfile:read("*l") or ""
      gitfile:close()
      local gitdir = first:match("^gitdir:%s*(.+)$")
      if gitdir then
        if not gitdir:match("^/") then
          gitdir = path .. "/" .. gitdir
        end
        return gitdir
      end
    end
    -- Walk up one level
    local parent = path:match("^(.+)/[^/]+$")
    if not parent or parent == path then break end
    path = parent
  end
  return nil
end

-- Read current branch from .git/HEAD directly (no subprocess).
-- Handles: symbolic ref (normal branch), detached HEAD (short hash).
-- ~10-20μs per call; replaces the ~20ms `git branch --show-current` fork.
local function read_git_branch(cwd)
  local gitdir = find_git_dir(cwd)
  if not gitdir then return "" end
  local f = io.open(gitdir .. "/HEAD", "r")
  if not f then return "" end
  local line = f:read("*l")
  f:close()
  if not line then return "" end

  -- Common case: symbolic ref on a local branch
  local branch = line:match("^ref: refs/heads/(.+)$")
  if branch then return branch end

  -- Rebase in progress: show the branch being rebased (matches user expectation)
  local rebase = io.open(gitdir .. "/rebase-merge/head-name", "r")
    or io.open(gitdir .. "/rebase-apply/head-name", "r")
  if rebase then
    local rb = rebase:read("*l") or ""
    rebase:close()
    local rb_branch = rb:match("refs/heads/(.+)$")
    if rb_branch then return rb_branch end
  end

  -- Non-heads ref (refs/tags/*, refs/remotes/*, etc.) or detached HEAD.
  -- Return "" to hide the branch section, matching `git branch --show-current`.
  return ""
end

local function setup(theme)
  local colors = theme.colors
  local separator_color = colors.purple_alt or colors.purple
  local basename = theme.basename

  -- Last-rendered signature; used to skip rendering when nothing visible changed.
  local _last_sig = ""

  -- Branch cache: cwd_path → branch string. Avoids re-walking the filesystem
  -- on every tick for an unchanged cwd. Bounded LRU keeps memory under control
  -- across many directory visits; ~32 entries is plenty for typical workflows
  -- and ensures we don't thrash when switching between panes in different
  -- repos (the original single-slot cache did thrash).
  -- Trade-off: `git checkout` in the same pane (cwd unchanged) won't refresh
  -- the displayed branch until cwd changes. Matches the original behavior.
  local GIT_CACHE_MAX = 32
  local _branch_cache = {}        -- cwd_path → branch
  local _branch_cache_order = {}  -- insertion order for LRU eviction

  local function branch_for(cwd_path)
    if not cwd_path or cwd_path == "" then return "" end
    local cached = _branch_cache[cwd_path]
    if cached ~= nil then return cached end
    local branch = read_git_branch(cwd_path)
    _branch_cache[cwd_path] = branch
    _branch_cache_order[#_branch_cache_order + 1] = cwd_path
    if #_branch_cache_order > GIT_CACHE_MAX then
      local evict = table.remove(_branch_cache_order, 1)
      _branch_cache[evict] = nil
    end
    return branch
  end

  -- Workspace tab/pane stats cache. Keyed by (workspace_name, window_id) so
  -- that multi-window workspaces don't cause the cache to thrash between
  -- windows with different tab counts. Each window maintains its own slot.
  -- Invalidated when the current window's tab count, total workspace count,
  -- or active-tab pane count changes.
  local _ws_stats = {} -- (workspace .. "|" .. window_id) → { tabs, panes, local_tabs, ws_count, active_panes }

  local function get_workspace_stats(window, workspace, local_tab_count, workspace_count, active_pane_count)
    local window_id = tostring(window:window_id())
    local key = workspace .. "|" .. window_id
    local cached = _ws_stats[key]
    if cached
      and cached.local_tabs == local_tab_count
      and cached.ws_count == workspace_count
      and cached.active_panes == active_pane_count
    then
      return cached.tabs, cached.panes
    end

    local total_tabs, total_panes = 0, 0
    local ok, all_wins = pcall(function()
      return wezterm.mux.all_windows()
    end)
    if ok and all_wins then
      for _, mux_win in ipairs(all_wins) do
        if mux_win:get_workspace() == workspace then
          local tabs = mux_win:tabs()
          total_tabs = total_tabs + #tabs
          for _, tab in ipairs(tabs) do
            total_panes = total_panes + #tab:panes()
          end
        end
      end
    else
      -- Fallback: current window only
      local win_tabs = window:mux_window():tabs()
      total_tabs = #win_tabs
      for _, tab in ipairs(win_tabs) do
        total_panes = total_panes + #tab:panes()
      end
    end

    _ws_stats[key] = {
      tabs = total_tabs,
      panes = total_panes,
      local_tabs = local_tab_count,
      ws_count = workspace_count,
      active_panes = active_pane_count,
    }
    return total_tabs, total_panes
  end

  -- Herdr snapshot cache. Polling is deliberately slower than update-status,
  -- and gtimeout bounds the synchronous child process so the UI cannot hang on
  -- a stalled socket. Old pane entries are pruned when polling resumes.
  local HERDR_POLL_SECONDS = 3
  local HERDR_CACHE_TTL_SECONDS = 60
  local HERDR_TIMEOUT = "0.5s"
  local HERDR_CLI = wezterm.home_dir .. "/.local/bin/herdr"
  local _herdr_cache = {} -- pane_id → { checked_at, state }

  local function find_by_id(items, key, id)
    if type(items) ~= "table" or not id then return nil end
    for _, item in ipairs(items) do
      if item[key] == id then return item end
    end
    return nil
  end

  local function clean_herdr_label(value, fallback)
    local label = type(value) == "string" and value or ""
    if label == "" then label = fallback or "" end
    label = label:gsub("%c", " ")
    return wz_truncate_right(label, 32)
  end

  local function prune_herdr_cache(now)
    for pane_id, entry in pairs(_herdr_cache) do
      if now - entry.checked_at >= HERDR_CACHE_TTL_SECONDS then
        _herdr_cache[pane_id] = nil
      end
    end
  end

  local function herdr_snapshot_command(pane)
    local args = { "gtimeout", HERDR_TIMEOUT, HERDR_CLI }
    local session
    local ok, info = pcall(pane.get_foreground_process_info, pane)
    if not ok or not info or type(info.argv) ~= "table" then return nil end
    for i, arg in ipairs(info.argv) do
      if arg == "--" then
        break
      elseif arg == "--remote" or arg:match("^%-%-remote=") or arg == "--no-session" then
        return nil
      elseif arg == "--session" and info.argv[i + 1] then
        session = info.argv[i + 1]
      elseif arg == "session" and info.argv[i + 1] == "attach" then
        session = info.argv[i + 2]
        if not session or session:match("^%-") then return nil end
      else
        session = arg:match("^%-%-session=(.+)$") or session
      end
    end
    if session then
      args[#args + 1] = "--session"
      args[#args + 1] = session
    end
    args[#args + 1] = "api"
    args[#args + 1] = "snapshot"
    return args
  end

  local function parse_herdr_state(stdout)
    if type(stdout) ~= "string" then return nil end
    local parsed, payload = pcall(wezterm.json_parse, stdout)
    if not parsed or type(payload) ~= "table" then return nil end
    local result = payload.result
    if type(result) ~= "table" or type(result.snapshot) ~= "table" then return nil end

    local snapshot = result.snapshot
    local workspaces = type(snapshot.workspaces) == "table" and snapshot.workspaces or {}
    local tabs = type(snapshot.tabs) == "table" and snapshot.tabs or {}
    local panes = type(snapshot.panes) == "table" and snapshot.panes or {}
    local active_workspace = find_by_id(workspaces, "workspace_id", snapshot.focused_workspace_id)
    if not active_workspace then return nil end

    local active_tab = find_by_id(tabs, "tab_id", snapshot.focused_tab_id) or {}
    local active_pane = find_by_id(panes, "pane_id", snapshot.focused_pane_id) or {}
    local pane_metadata = type(active_pane.metadata) == "table" and active_pane.metadata or {}
    local workspace_label = clean_herdr_label(active_workspace.label, snapshot.focused_workspace_id)
    local tab_label = clean_herdr_label(active_tab.label, snapshot.focused_tab_id)
    local pane_label = clean_herdr_label(
      active_pane.label
        or pane_metadata.title
        or active_pane.title
        or pane_metadata.terminal_title_stripped
        or active_pane.terminal_title_stripped
        or pane_metadata.terminal_title
        or active_pane.terminal_title,
      snapshot.focused_pane_id
    )
    local pane_cwd = type(active_pane.cwd) == "string" and active_pane.cwd or ""
    local tab_count = tonumber(active_workspace.tab_count) or 0
    local pane_count = tonumber(active_workspace.pane_count) or 0
    local workspace_count = #workspaces
    return {
      workspace = workspace_label,
      tab = tab_label,
      pane = pane_label,
      cwd = pane_cwd,
      tabs = tab_count,
      panes = pane_count,
      workspaces = workspace_count,
      signature = table.concat({
        snapshot.focused_workspace_id or "",
        snapshot.focused_tab_id or "",
        snapshot.focused_pane_id or "",
        workspace_label,
        tab_label,
        pane_label,
        pane_cwd,
        tostring(tab_count),
        tostring(pane_count),
        tostring(workspace_count),
      }, "|"),
    }
  end

  local function get_herdr_state(pane)
    local pane_id = tostring(pane:pane_id())
    local now = os.time()
    local cached = _herdr_cache[pane_id]
    if cached and now - cached.checked_at < HERDR_POLL_SECONDS then
      return cached.state
    end

    prune_herdr_cache(now)
    local state
    local args = herdr_snapshot_command(pane)
    if args then
      local ran, success, stdout = pcall(wezterm.run_child_process, args)
      if ran and success then
        state = parse_herdr_state(stdout)
      end
    end

    _herdr_cache[pane_id] = { checked_at = now, state = state }
    return state
  end

  -- Pre-allocated format slots. Static slots never change — reused every tick.
  -- Dynamic slots have their `.Text` (or `.Foreground.Color`) mutated in place.
  -- This eliminates ~30 table allocations per update-status tick.

  -- Static color slots
  local c_pink       = { Foreground = { Color = colors.pink } }
  local c_white      = { Foreground = { Color = colors.white } }
  local c_sep        = { Foreground = { Color = separator_color } }
  local c_purple     = { Foreground = { Color = colors.purple } }
  local c_purple_alt = { Foreground = { Color = colors.purple_alt } }
  local c_cyan       = { Foreground = { Color = colors.cyan } }
  local c_red2       = { Foreground = { Color = colors.red2 } }

  -- Static text slots
  local t_folder_icon = { Text = NF_FOLDER .. "  " }
  local t_branch_icon = { Text = NF_BRANCH .. "  " }
  local t_sep         = { Text = " ⋮ " }
  local t_spacer      = { Text = "  " }
  local t_tab_icon    = { Text = NF_TAB .. " " }
  local t_pane_icon   = { Text = NF_PANE .. " " }
  local t_ws_icon     = { Text = NF_LAYERS .. " " }
  local t_left_pad    = { Text = "  " }

  -- Dynamic slots (mutated each tick)
  local d_left_color  = { Foreground = { Color = colors.red } }
  local d_left_stat   = { Text = "" }
  local d_cwd         = { Text = "" }
  local d_branch      = { Text = "" }
  local d_cmd_icon    = { Text = "" }
  local d_cmd         = { Text = "" }
  local d_tabs        = { Text = "" }
  local d_panes       = { Text = "" }
  local d_ws_count    = { Text = "" }

  -- Reusable outer arrays
  local left_items = { d_left_color, t_left_pad, d_left_stat, t_sep }
  local right_items = {}

  wezterm.on("update-status", function(window, pane)
    -- Pre-read inputs for both the signature check and the rest of the handler.
    local workspace       = window:active_workspace()
    local key_table       = window:active_key_table() or ""
    local leader          = window:leader_is_active()
    local cwd_path        = theme.get_cwd_path(pane:get_current_working_dir())
    local title           = pane:get_title() or ""
    local cmd_raw         = pane:get_foreground_process_name()
    local cmd             = cmd_raw and basename(cmd_raw) or ""
    local pane_id         = tostring(pane:pane_id())
    local herdr_state
    if cmd == "herdr" then
      herdr_state = get_herdr_state(pane)
    else
      _herdr_cache[pane_id] = nil
    end
    local herdr_sig = herdr_state and herdr_state.signature or ""
    local status_cwd_path = herdr_state and herdr_state.cwd ~= "" and herdr_state.cwd or cwd_path

    local local_tab_count, workspace_count, active_pane_count = 0, 0, 0
    if not herdr_state then
      local_tab_count = #window:mux_window():tabs()
      workspace_count = #wezterm.mux.get_workspace_names()
      local active_tab = window:active_tab()
      active_pane_count = active_tab and #active_tab:panes() or 0
    end

    -- Cheap discriminator: if nothing display-affecting has changed, skip
    -- the expensive mux walk and status re-render. Branch is intentionally
    -- NOT in the sig — it's cached per-cwd by branch_for() below, matching
    -- the original behavior of only refreshing on cwd change.
    local sig = workspace .. "|" .. cwd_path .. "|" .. cmd .. "|" .. title
      .. "|" .. key_table .. "|" .. tostring(leader)
      .. "|" .. local_tab_count .. "|" .. workspace_count
      .. "|" .. active_pane_count .. "|" .. herdr_sig
    if sig == _last_sig then return end
    _last_sig = sig

    -- Branch (cached by cwd_path; runs only on sig change, not every tick)
    local branch = branch_for(status_cwd_path)

    -- Determine left-status label + color.
    local stat = herdr_state and herdr_state.workspace or workspace
    local stat_color = colors.red
    if key_table ~= "" then
      stat = key_table
      stat_color = colors.purple
    end
    if leader then
      stat = NF_LIGHTNING .. NF_LIGHTNING
      stat_color = colors.cyan
    end

    local cwd = status_cwd_path ~= "" and basename(status_cwd_path) or ""
    if herdr_state then cwd = clean_herdr_label(cwd, "") end
    local cmd_icon = theme.get_process_icon(title, cmd, NF_CODE)

    local total_tabs, total_panes, total_workspaces
    if herdr_state then
      total_tabs = herdr_state.tabs
      total_panes = herdr_state.panes
      total_workspaces = herdr_state.workspaces
    else
      total_tabs, total_panes = get_workspace_stats(
        window, workspace, local_tab_count, workspace_count, active_pane_count
      )
      total_workspaces = workspace_count
    end

    -- Left status: mutate pre-allocated slots
    d_left_color.Foreground.Color = stat_color
    d_left_stat.Text = NF_LAYERS .. "  " .. stat
    window:set_left_status(wz_format(left_items))

    -- Right status: mutate dynamic text slots
    d_cwd.Text      = cwd
    d_branch.Text   = branch
    d_cmd_icon.Text = cmd_icon .. "  "
    d_cmd.Text      = cmd
    d_tabs.Text     = herdr_state and (herdr_state.tab .. " · " .. tostring(total_tabs)) or tostring(total_tabs)
    d_panes.Text    = herdr_state and (herdr_state.pane .. " · " .. tostring(total_panes)) or tostring(total_panes)
    d_ws_count.Text = tostring(total_workspaces)

    -- Build right_items with direct indexed writes (no table.insert overhead)
    local n = 0
    -- CWD section
    n = n + 1; right_items[n] = c_pink
    n = n + 1; right_items[n] = t_folder_icon
    n = n + 1; right_items[n] = c_white
    n = n + 1; right_items[n] = d_cwd

    -- Git branch (conditional)
    if branch ~= "" then
      n = n + 1; right_items[n] = c_sep
      n = n + 1; right_items[n] = t_sep
      n = n + 1; right_items[n] = c_purple
      n = n + 1; right_items[n] = t_branch_icon
      n = n + 1; right_items[n] = c_white
      n = n + 1; right_items[n] = d_branch
    end

    -- Command section
    n = n + 1; right_items[n] = c_purple_alt
    n = n + 1; right_items[n] = t_sep
    n = n + 1; right_items[n] = c_cyan
    n = n + 1; right_items[n] = d_cmd_icon
    n = n + 1; right_items[n] = c_white
    n = n + 1; right_items[n] = d_cmd

    -- Session stats
    n = n + 1; right_items[n] = c_purple_alt
    n = n + 1; right_items[n] = t_sep
    n = n + 1; right_items[n] = c_red2
    n = n + 1; right_items[n] = t_tab_icon
    n = n + 1; right_items[n] = c_purple_alt
    n = n + 1; right_items[n] = d_tabs
    n = n + 1; right_items[n] = t_spacer
    n = n + 1; right_items[n] = c_red2
    n = n + 1; right_items[n] = t_pane_icon
    n = n + 1; right_items[n] = c_purple_alt
    n = n + 1; right_items[n] = d_panes
    n = n + 1; right_items[n] = c_red2
    n = n + 1; right_items[n] = t_spacer
    n = n + 1; right_items[n] = t_ws_icon
    n = n + 1; right_items[n] = c_purple_alt
    n = n + 1; right_items[n] = d_ws_count
    n = n + 1; right_items[n] = t_spacer

    -- Truncate any stale entries from a prior longer render (when branch was set
    -- and now isn't, the array would otherwise have leftover trailing slots).
    for i = n + 1, #right_items do right_items[i] = nil end

    window:set_right_status(wz_format(right_items))
  end)
end

return { setup = setup }
