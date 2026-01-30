-- tabs.lua: Tab rendering — pill-shaped tabs, process icons, project colors,
-- and unseen output indicators via the format-tab-title event.

local wezterm = require("wezterm")

local function setup(theme)
  local colors = theme.colors
  local tab_bar = theme.tab_bar
  local basename = theme.basename

  -- Project-to-color mapping for tab coloring (directory name → accent color)
  local project_colors = {
    [".dotfiles"] = colors.cyan,
    neoed = colors.purple,
    atlas = colors.red,
    -- Add projects: ["my-project"] = colors.pink,
  }

  -- Pill-shaped tabs with activity indicator and process icons
  wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    -- Check for unseen output (use panes param; tab.panes is undocumented)
    local unseen = false
    if panes then
      for _, p in ipairs(panes) do
        if p.has_unseen_output then
          unseen = true
          break
        end
      end
    end

    -- Detect project color from CWD
    local cwd_path = theme.get_cwd_path(tab.active_pane.current_working_dir)
    local project_color = cwd_path ~= "" and project_colors[basename(cwd_path)] or nil

    -- Determine tab colors
    local bg, fg
    if tab.is_active then
      bg = project_color or tab_bar.active_bg
      fg = tab_bar.active_fg
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

    -- Process icon: check pane title first (catches interpreted scripts where
    -- the process name is the runtime, e.g. node/python), then process name
    local proc = tab.active_pane.foreground_process_name or ""
    local icon = theme.get_process_icon(tab.active_pane.title, basename(proc), wezterm.nerdfonts.cod_terminal)

    -- Build title with index and icon
    local index = tab.tab_index + 1
    local title = tab.tab_title and #tab.tab_title > 0 and tab.tab_title or tab.active_pane.title
    local formatted = index .. ": " .. icon .. " " .. title

    -- Truncate to fit (pill edges + padding = ~4 cells)
    formatted = wezterm.truncate_right(formatted, max_width - 4)

    return {
      { Background = { Color = tab_bar.bg } },
      { Foreground = { Color = bg } },
      { Text = wezterm.nerdfonts.ple_left_half_circle_thick },
      { Background = { Color = bg } },
      { Foreground = { Color = fg } },
      { Text = " " .. formatted .. " " },
      { Background = { Color = tab_bar.bg } },
      { Foreground = { Color = bg } },
      { Text = wezterm.nerdfonts.ple_right_half_circle_thick },
    }
  end)
end

return { setup = setup }
