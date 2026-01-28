local wezterm = require("wezterm")
local fish_path = "/opt/homebrew/bin/fish"

-- Helper: extract basename from path
local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end
config.default_prog = { fish_path, "-l" }

-- -----------------------------------------------------------------------------
-- General Config
-- -----------------------------------------------------------------------------
config.enable_kitty_keyboard = true
config.enable_csi_u_key_encoding = false

config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

config.font = wezterm.font_with_fallback({
  {
    family = "Lilex Nerd Font Mono",
    weight = 400,
  },
  {
    family = "FiraCode Nerd Font Mono",
    weight = 400,
  },
})
config.font_size = 18.0

-- Theme selection: "Eldritch", "rose-pine", "rose-pine-moon", "rose-pine-dawn"
local theme = "Eldritch"
config.color_scheme = theme

-- Theme-aware accent colors
local colorRed, colorPurple, colorCyan, colorYellow, colorPink, colorWhite
if theme == "rose-pine-dawn" then
  colorRed = "#b4637a" -- love
  colorPurple = "#907aa9" -- iris
  colorCyan = "#56949f" -- foam
  colorYellow = "#ea9d34" -- gold
  colorPink = "#d7827e" -- rose
  colorWhite = "#575279" -- text
elseif theme:match("^rose%-pine") then
  colorRed = "#eb6f92" -- love
  colorPurple = "#c4a7e7" -- iris
  colorCyan = "#9ccfd8" -- foam
  colorYellow = "#f6c177" -- gold
  colorPink = "#ebbcba" -- rose
  colorWhite = "#e0def4" -- text
else -- Eldritch
  colorRed = "#F16C75"
  colorPurple = "#A48CF2"
  colorCyan = "#04D1F9"
  colorYellow = "#F7F67F"
  colorPink = "#F265B5"
  colorWhite = "#EBFAFA"
end

-- Tab bar colors (mirrors TOML [colors.tab_bar] for format-tab-title)
local tabBarBg, activeTabBg, activeTabFg, inactiveTabBg, inactiveTabFg
if theme == "rose-pine-dawn" then
  tabBarBg = "#f2e9e1"
  activeTabBg = "#faf4ed"
  activeTabFg = "#575279"
  inactiveTabBg = "#fffaf3"
  inactiveTabFg = "#6A6681"
elseif theme:match("^rose%-pine") then
  tabBarBg = "#191724"
  activeTabBg = "#ebbcba"
  activeTabFg = "#191724"
  inactiveTabBg = "#26233a"
  inactiveTabFg = "#9ccfd8"
else -- Eldritch
  tabBarBg = "#171928"
  activeTabBg = "#37F499"
  activeTabFg = "#171928"
  inactiveTabBg = "#212337"
  inactiveTabFg = "#7081D0"
end

local keymaps = require("keymaps")
config.leader = keymaps.leader
config.keys = keymaps.keys
config.key_tables = keymaps.key_tables

config.cursor_blink_rate = 500
config.default_cursor_style = "BlinkingBar"
config.hide_mouse_cursor_when_typing = true
config.audible_bell = "SystemBeep"
config.max_fps = 240
-- initial window size
config.initial_cols = 100
config.initial_rows = 50
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.macos_window_background_blur = 25
config.scrollback_lines = 5000
config.default_workspace = wezterm.nerdfonts.cod_rocket

config.inactive_pane_hsb = {
  saturation = 0.9, -- Slightly reduce saturation for a muted effect
  brightness = 0.5, -- Dim brightness to half for a clear distinction
}

-- Tab bar (override theme cell backgrounds so format-tab-title has full control)
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = true
-- Project-to-color mapping for tab coloring (directory name → accent color)
local project_colors = {
  [".dotfiles"] = colorCyan,
  neoed = colorPurple,
  atlas = colorRed,
  -- Add projects: ["my-project"] = colorPink,
}

-- Process-to-icon mapping for tab titles
local process_icons = {
  nvim = wezterm.nerdfonts.custom_vim,
  vim = wezterm.nerdfonts.custom_vim,
  glow = wezterm.nerdfonts.oct_markdown,
  fish = wezterm.nerdfonts.md_fish,
  zsh = wezterm.nerdfonts.dev_terminal,
  bash = wezterm.nerdfonts.cod_terminal_bash,
  git = wezterm.nerdfonts.dev_git,
  gh = wezterm.nerdfonts.oct_mark_github,
  lazygit = wezterm.nerdfonts.dev_git,
  deno = wezterm.nerdfonts.dev_denojs,
  node = wezterm.nerdfonts.md_nodejs,
  python = wezterm.nerdfonts.dev_python,
  python3 = wezterm.nerdfonts.dev_python,
  ruby = wezterm.nerdfonts.dev_ruby,
  go = wezterm.nerdfonts.md_language_go,
  cargo = wezterm.nerdfonts.dev_rust,
  rustc = wezterm.nerdfonts.dev_rust,
  docker = wezterm.nerdfonts.dev_docker,
  ssh = wezterm.nerdfonts.md_ssh,
  make = wezterm.nerdfonts.seti_makefile,
  btop = wezterm.nerdfonts.md_chart_areaspline,
  claude = wezterm.nerdfonts.fa_robot,
  opencode = wezterm.nerdfonts.md_robot,
  gemini = wezterm.nerdfonts.md_robot,
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
  local cwd_url = tab.active_pane.current_working_dir
  local project_color = nil
  if cwd_url then
    local cwd_str = type(cwd_url) == "userdata" and cwd_url.file_path or tostring(cwd_url)
    project_color = project_colors[basename(cwd_str)]
  end

  -- Determine tab colors
  local bg, fg
  if tab.is_active then
    bg = project_color or activeTabBg
    fg = activeTabFg
  elseif unseen then
    bg = inactiveTabBg
    fg = colorYellow
  elseif project_color then
    bg = inactiveTabBg
    fg = project_color
  else
    bg = inactiveTabBg
    fg = inactiveTabFg
  end

  -- Process icon: check pane title first (catches interpreted scripts where
  -- the process name is the runtime, e.g. node/python), then process name
  local title_cmd = (tab.active_pane.title or ""):match("^(%S+)")
  local proc = tab.active_pane.foreground_process_name or ""
  local proc_name = basename(proc)
  local icon = (title_cmd and process_icons[title_cmd])
    or process_icons[proc_name]
    or wezterm.nerdfonts.cod_terminal

  -- Build title with index and icon
  local index = tab.tab_index + 1
  local title = tab.tab_title and #tab.tab_title > 0 and tab.tab_title or tab.active_pane.title
  local formatted = index .. ": " .. icon .. " " .. title

  -- Truncate to fit (pill edges + padding = ~4 cells)
  local max_chars = max_width - 4
  if #formatted > max_chars and max_chars > 0 then
    formatted = formatted:sub(1, max_chars - 1) .. "…"
  end

  return {
    { Background = { Color = tabBarBg } },
    { Foreground = { Color = bg } },
    { Text = wezterm.nerdfonts.ple_left_half_circle_thick },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = " " .. formatted .. " " },
    { Background = { Color = tabBarBg } },
    { Foreground = { Color = bg } },
    { Text = wezterm.nerdfonts.ple_right_half_circle_thick },
  }
end)

-- Git branch cache (only re-query when CWD changes)
local git_cache = { cwd = "", branch = "" }

wezterm.on("update-status", function(window, pane)
  -- Workspace name
  local stat = window:active_workspace()
  local stat_color = colorRed

  -- Utilize this to display LDR or current key table name
  if window:active_key_table() then
    stat = window:active_key_table()
    stat_color = colorPurple
  end
  if window:leader_is_active() then
    stat = wezterm.nerdfonts.md_lightning_bolt .. wezterm.nerdfonts.md_lightning_bolt
    stat_color = colorCyan
  end

  -- Current working directory (full path + basename)
  local cwd_uri = pane:get_current_working_dir()
  local cwd_path = ""
  local cwd = ""
  if cwd_uri then
    if type(cwd_uri) == "userdata" then
      cwd_path = cwd_uri.file_path
    else
      cwd_path = tostring(cwd_uri)
    end
    cwd = basename(cwd_path)
  end

  -- Git branch (cached, only updates on CWD change)
  local branch = ""
  if cwd_path ~= "" and cwd_path ~= git_cache.cwd then
    local handle = io.popen("git -C " .. wezterm.shell_quote_arg(cwd_path) .. " branch --show-current 2>/dev/null")
    if handle then
      branch = handle:read("*l") or ""
      handle:close()
    end
    git_cache.cwd = cwd_path
    git_cache.branch = branch
  else
    branch = git_cache.branch
  end

  -- Current command
  local cmd = pane:get_foreground_process_name()

  -- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
  cmd = cmd and basename(cmd) or ""

  -- Time
  local time = wezterm.strftime("%H:%M")

  -- Left status (left of the tab line)
  window:set_left_status(wezterm.format({
    { Foreground = { Color = stat_color } },
    { Text = "  " },
    { Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
    { Text = " ⋮ " },
  }))

  -- Right status
  local right_items = {
    -- CWD: pink icon, white text
    { Foreground = { Color = colorPink } },
    { Text = wezterm.nerdfonts.md_folder .. "  " },
    { Foreground = { Color = colorWhite } },
    { Text = cwd },
  }

  -- Git branch (only show if in a git repo)
  if branch ~= "" then
    table.insert(right_items, { Text = " ⋮ " })
    table.insert(right_items, { Foreground = { Color = colorPurple } })
    table.insert(right_items, { Text = wezterm.nerdfonts.dev_git_branch .. "  " })
    table.insert(right_items, { Foreground = { Color = colorWhite } })
    table.insert(right_items, { Text = branch })
  end

  -- Command: cyan icon, white text
  table.insert(right_items, { Text = " ⋮ " })
  table.insert(right_items, { Foreground = { Color = colorCyan } })
  table.insert(right_items, { Text = wezterm.nerdfonts.fa_code .. "  " })
  table.insert(right_items, { Foreground = { Color = colorWhite } })
  table.insert(right_items, { Text = cmd })

  -- Time: yellow icon, white text
  table.insert(right_items, { Text = " ⋮ " })
  table.insert(right_items, { Foreground = { Color = colorYellow } })
  table.insert(right_items, { Text = wezterm.nerdfonts.md_clock .. "  " })
  table.insert(right_items, { Foreground = { Color = colorWhite } })
  table.insert(right_items, { Text = time })
  table.insert(right_items, { Text = "  " })

  window:set_right_status(wezterm.format(right_items))
end)

return config
