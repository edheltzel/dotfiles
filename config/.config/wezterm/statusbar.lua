-- statusbar.lua: Left and right status bar rendering via the uppurple-status event.
-- Includes workspace/leader display, CWD, git branch (cached), command, and session stats.

local wezterm = require("wezterm")

-- Hot-path locals: resolve module-level functions + constants once at load time.
-- In Lua 5.4 (WezTerm's runtime) globals/table lookups are ~20x slower than
-- local register access. Pays off every time update-status fires.
local wz_format = wezterm.format
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
  local branch = line:match("^ref: refs/heads/(.+)$")
  if branch then return branch end
  return line:sub(1, 7) -- detached HEAD: show short hash
end

local function setup(theme)
  local colors = theme.colors
  local separator_color = colors.purple_alt or colors.purple
  local basename = theme.basename

  -- Last-rendered signature; used to skip rendering when nothing visible changed.
  local _last_sig = ""

  -- Workspace tab/pane stats cache (feature-preserving: still an accurate
  -- cross-window count, just not recomputed on every tick). Invalidated when
  -- the current window's tab count OR total workspace count changes. Edge
  -- cases (pane split without tab count change, tab add in a different window
  -- of same workspace) may be momentarily stale — next real change refreshes.
  local _ws_stats = {} -- workspace_name → { tabs, panes, local_tabs, ws_count }

  local function get_workspace_stats(window, workspace, local_tab_count, workspace_count)
    local cached = _ws_stats[workspace]
    if cached
      and cached.local_tabs == local_tab_count
      and cached.ws_count == workspace_count
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

    _ws_stats[workspace] = {
      tabs = total_tabs,
      panes = total_panes,
      local_tabs = local_tab_count,
      ws_count = workspace_count,
    }
    return total_tabs, total_panes
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
    local local_tab_count = #window:mux_window():tabs()
    local workspace_count = #wezterm.mux.get_workspace_names()
    -- Read branch directly from .git/HEAD (no subprocess). Included in the
    -- signature so `git checkout` without other state change still refreshes.
    local branch = read_git_branch(cwd_path)

    -- Cheap discriminator: if nothing display-affecting has changed, skip
    -- the expensive mux walk and status re-render. Note: pane splits *within*
    -- a single tab are not caught by local_tab_count; they'll surface on the
    -- next cwd/cmd/workspace change. Acceptable trade-off.
    local sig = workspace .. "|" .. cwd_path .. "|" .. cmd .. "|" .. title
      .. "|" .. key_table .. "|" .. tostring(leader)
      .. "|" .. local_tab_count .. "|" .. workspace_count
      .. "|" .. branch
    if sig == _last_sig then return end
    _last_sig = sig

    -- Determine left-status label + color.
    local stat = workspace
    local stat_color = colors.red
    if key_table ~= "" then
      stat = key_table
      stat_color = colors.purple
    end
    if leader then
      stat = NF_LIGHTNING .. NF_LIGHTNING
      stat_color = colors.cyan
    end

    local cwd = cwd_path ~= "" and basename(cwd_path) or ""
    local cmd_icon = theme.get_process_icon(title, cmd, NF_CODE)

    -- Session stats (cross-window accurate, cached by workspace structure)
    local total_tabs, total_panes = get_workspace_stats(window, workspace, local_tab_count, workspace_count)

    -- Left status: mutate pre-allocated slots
    d_left_color.Foreground.Color = stat_color
    d_left_stat.Text = NF_LAYERS .. "  " .. stat
    window:set_left_status(wz_format(left_items))

    -- Right status: mutate dynamic text slots
    d_cwd.Text      = cwd
    d_branch.Text   = branch
    d_cmd_icon.Text = cmd_icon .. "  "
    d_cmd.Text      = cmd
    d_tabs.Text     = tostring(total_tabs)
    d_panes.Text    = tostring(total_panes)
    d_ws_count.Text = tostring(workspace_count)

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
