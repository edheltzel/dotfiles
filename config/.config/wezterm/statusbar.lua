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

local function setup(theme)
  local colors = theme.colors
  local separator_color = colors.purple_alt or colors.purple
  local basename = theme.basename

  -- Git branch cache (only re-query when CWD changes)
  local git_cache = { cwd = "", branch = "" }

  -- Last-rendered signature; used to skip rendering when nothing visible changed.
  local _last_sig = ""

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

    -- Cheap discriminator: if nothing display-affecting has changed, skip
    -- the expensive mux walk and status re-render. Note: pane splits *within*
    -- a single tab are not caught by local_tab_count; they'll surface on the
    -- next cwd/cmd/workspace change. Acceptable trade-off.
    local sig = workspace .. "|" .. cwd_path .. "|" .. cmd .. "|" .. title
      .. "|" .. key_table .. "|" .. tostring(leader)
      .. "|" .. local_tab_count .. "|" .. workspace_count
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

    -- Git branch (cached, only updates on CWD change)
    local branch = ""
    if cwd_path ~= "" and cwd_path ~= git_cache.cwd then
      local success, stdout, _ = wezterm.run_child_process({
        "git",
        "-C",
        cwd_path,
        "branch",
        "--show-current",
      })
      branch = success and stdout:gsub("%s+$", "") or ""
      git_cache.cwd = cwd_path
      git_cache.branch = branch
    else
      branch = git_cache.branch
    end

    local cmd_icon = theme.get_process_icon(title, cmd, NF_CODE)

    -- Session stats: tabs + panes for current workspace only (cross-window accurate)
    local total_tabs = 0
    local total_panes = 0
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

    -- Left status (left of the tab line)
    window:set_left_status(wz_format({
      { Foreground = { Color = stat_color } },
      { Text = "  " },
      { Text = NF_LAYERS .. "  " .. stat },
      { Text = " ⋮ " },
    }))

    -- Right status
    local right_items = {
      -- CWD: pink icon, white text
      { Foreground = { Color = colors.pink } },
      { Text = NF_FOLDER .. "  " },
      { Foreground = { Color = colors.white } },
      { Text = cwd },
    }

    -- Git branch (only show if in a git repo)
    if branch ~= "" then
      table.insert(right_items, { Foreground = { Color = separator_color } })
      table.insert(right_items, { Text = " ⋮ " })
      table.insert(right_items, { Foreground = { Color = colors.purple } })
      table.insert(right_items, { Text = NF_BRANCH .. "  " })
      table.insert(right_items, { Foreground = { Color = colors.white } })
      table.insert(right_items, { Text = branch })
    end

    -- Command: cyan dynamic icon, white text
    table.insert(right_items, { Foreground = { Color = colors.purple_alt } })
    table.insert(right_items, { Text = " ⋮ " })
    table.insert(right_items, { Foreground = { Color = colors.cyan } })
    table.insert(right_items, { Text = cmd_icon .. "  " })
    table.insert(right_items, { Foreground = { Color = colors.white } })
    table.insert(right_items, { Text = cmd })

    -- Session stats: tabs (yellow), panes (green), workspaces (red)
    table.insert(right_items, { Foreground = { Color = colors.purple_alt } })
    table.insert(right_items, { Text = " ⋮ " })
    table.insert(right_items, { Foreground = { Color = colors.red2 } })
    table.insert(right_items, { Text = NF_TAB .. " " })
    table.insert(right_items, { Foreground = { Color = colors.purple_alt } })
    table.insert(right_items, { Text = tostring(total_tabs) })
    table.insert(right_items, { Text = "  " })
    table.insert(right_items, { Foreground = { Color = colors.red2 } })
    table.insert(right_items, { Text = NF_PANE .. " " })
    table.insert(right_items, { Foreground = { Color = colors.purple_alt } })
    table.insert(right_items, { Text = tostring(total_panes) })
    table.insert(right_items, { Foreground = { Color = colors.red2 } })
    table.insert(right_items, { Text = "  " })
    table.insert(right_items, { Text = NF_LAYERS .. " " })
    table.insert(right_items, { Foreground = { Color = colors.purple_alt } })
    table.insert(right_items, { Text = tostring(workspace_count) })
    table.insert(right_items, { Text = "  " })

    window:set_right_status(wz_format(right_items))
  end)
end

return { setup = setup }
