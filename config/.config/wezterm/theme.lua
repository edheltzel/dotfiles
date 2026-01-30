-- theme.lua: Single source of truth for theme selection, color variables,
-- and process icon mappings. All shared data lives here.

local wezterm = require("wezterm")
local M = {}

-- Helper: extract basename from path (shared across modules)
function M.basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- Theme selection: "Eldritch", "rose-pine", "rose-pine-moon", "rose-pine-dawn"
M.name = "Eldritch"

-- Theme data lookup table (colors + tab_bar per theme)
local themes = {
  ["rose-pine-dawn"] = {
    colors = { red = "#b4637a", purple = "#907aa9", cyan = "#56949f", yellow = "#ea9d34", pink = "#d7827e", white = "#575279" },
    tab_bar = { bg = "#f2e9e1", active_bg = "#faf4ed", active_fg = "#575279", inactive_bg = "#fffaf3", inactive_fg = "#6A6681" },
  },
  ["rose-pine"] = {
    colors = { red = "#eb6f92", purple = "#c4a7e7", cyan = "#9ccfd8", yellow = "#f6c177", pink = "#ebbcba", white = "#e0def4" },
    tab_bar = { bg = "#191724", active_bg = "#ebbcba", active_fg = "#191724", inactive_bg = "#26233a", inactive_fg = "#9ccfd8" },
  },
  default = {
    colors = { red = "#F16C75", purple = "#A48CF2", cyan = "#04D1F9", yellow = "#F7F67F", pink = "#F265B5", white = "#EBFAFA" },
    tab_bar = { bg = "#171928", active_bg = "#37F499", active_fg = "#171928", inactive_bg = "#212337", inactive_fg = "#7081D0" },
  },
}

-- Resolve theme key (rose-pine-moon inherits rose-pine)
local function get_theme_key(name)
  if themes[name] then return name end
  if name:match("^rose%-pine") then return "rose-pine" end
  return "default"
end

local theme_data = themes[get_theme_key(M.name)]
M.colors = theme_data.colors
M.tab_bar = theme_data.tab_bar

-- Process-to-icon mapping (shared by tabs and statusbar) - defined before helpers that use it
M.process_icons = {
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

-- Helper: extract file path from CWD URI (handles Url object or string)
function M.get_cwd_path(cwd_uri)
  if not cwd_uri then return "" end
  if type(cwd_uri) == "userdata" then return cwd_uri.file_path or "" end
  return tostring(cwd_uri)
end

-- Helper: resolve process icon from title and process name
function M.get_process_icon(title, proc_name, default_icon)
  local title_cmd = title and title:match("^(%S+)")
  return (title_cmd and M.process_icons[title_cmd]) or M.process_icons[proc_name] or default_icon
end

return M
