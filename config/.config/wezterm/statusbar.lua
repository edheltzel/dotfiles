-- statusbar.lua: Left and right status bar rendering via the uppurple-status event.
-- Includes workspace/leader display, CWD, git branch (cached), command, and session stats.

local wezterm = require("wezterm")

local function setup(theme)
  local colors = theme.colors
  local basename = theme.basename

  -- Git branch cache (only re-query when CWD changes)
  local git_cache = { cwd = "", branch = "" }

  wezterm.on("update-status", function(window, pane)
    -- Workspace name
    local stat = window:active_workspace()
    local stat_color = colors.red

    -- Utilize this to display LDR or current key table name
    if window:active_key_table() then
      stat = window:active_key_table()
      stat_color = colors.purple
    end
    if window:leader_is_active() then
      stat = wezterm.nerdfonts.md_lightning_bolt .. wezterm.nerdfonts.md_lightning_bolt
      stat_color = colors.cyan
    end

    -- Current working directory (full path + basename)
    local cwd_path = theme.get_cwd_path(pane:get_current_working_dir())
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

    -- Current command + dynamic icon (title-first for Node.js CLIs, then process name)
    local cmd = pane:get_foreground_process_name()
    cmd = cmd and basename(cmd) or ""
    local cmd_icon = theme.get_process_icon(pane:get_title(), cmd, wezterm.nerdfonts.fa_code)

    -- Session stats: total tabs + panes across all workspaces
    -- Falls back to current window only if wezterm.mux.all_windows() is unavailable
    local total_tabs = 0
    local total_panes = 0
    local workspace_count = #wezterm.mux.get_workspace_names()
    local ok, all_wins = pcall(function()
      return wezterm.mux.all_windows()
    end)
    if ok and all_wins then
      for _, mux_win in ipairs(all_wins) do
        local tabs = mux_win:tabs()
        total_tabs = total_tabs + #tabs
        for _, tab in ipairs(tabs) do
          total_panes = total_panes + #tab:panes()
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
    window:set_left_status(wezterm.format({
      { Foreground = { Color = stat_color } },
      { Text = "  " },
      { Text = wezterm.nerdfonts.cod_layers .. "  " .. stat },
      { Text = " ⋮ " },
    }))

    -- Right status
    local right_items = {
      -- CWD: pink icon, white text
      { Foreground = { Color = colors.pink } },
      { Text = wezterm.nerdfonts.md_folder .. "  " },
      { Foreground = { Color = colors.white } },
      { Text = cwd },
    }

    -- Git branch (only show if in a git repo)
    if branch ~= "" then
      table.insert(right_items, { Foreground = { Color = colors.purple_alt } })
      table.insert(right_items, { Text = " ⋮ " })
      table.insert(right_items, { Foreground = { Color = colors.purple } })
      table.insert(right_items, { Text = wezterm.nerdfonts.dev_git_branch .. "  " })
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
    table.insert(right_items, { Text = wezterm.nerdfonts.md_tab .. " " })
    table.insert(right_items, { Foreground = { Color = colors.purple_alt } })
    table.insert(right_items, { Text = tostring(total_tabs) })
    table.insert(right_items, { Text = "  " })
    table.insert(right_items, { Foreground = { Color = colors.red2 } })
    table.insert(right_items, { Text = wezterm.nerdfonts.md_view_split_vertical .. " " })
    table.insert(right_items, { Foreground = { Color = colors.purple_alt } })
    table.insert(right_items, { Text = tostring(total_panes) })
    table.insert(right_items, { Foreground = { Color = colors.red2 } })
    table.insert(right_items, { Text = "  " })
    table.insert(right_items, { Text = wezterm.nerdfonts.cod_layers .. " " })
    table.insert(right_items, { Foreground = { Color = colors.purple_alt } })
    table.insert(right_items, { Text = tostring(workspace_count) })
    table.insert(right_items, { Text = "  " })

    window:set_right_status(wezterm.format(right_items))
  end)
end

return { setup = setup }
