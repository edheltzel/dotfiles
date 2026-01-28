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

-- Accent colors (theme-aware)
local colors = {}
if M.name == "rose-pine-dawn" then
  colors.red = "#b4637a" -- love
  colors.purple = "#907aa9" -- iris
  colors.cyan = "#56949f" -- foam
  colors.yellow = "#ea9d34" -- gold
  colors.pink = "#d7827e" -- rose
  colors.white = "#575279" -- text
elseif M.name:match("^rose%-pine") then
  colors.red = "#eb6f92" -- love
  colors.purple = "#c4a7e7" -- iris
  colors.cyan = "#9ccfd8" -- foam
  colors.yellow = "#f6c177" -- gold
  colors.pink = "#ebbcba" -- rose
  colors.white = "#e0def4" -- text
else -- Eldritch
  colors.red = "#F16C75"
  colors.purple = "#A48CF2"
  colors.cyan = "#04D1F9"
  colors.yellow = "#F7F67F"
  colors.pink = "#F265B5"
  colors.white = "#EBFAFA"
end
M.colors = colors

-- Tab bar colors (mirrors TOML [colors.tab_bar] for format-tab-title)
local tab_bar = {}
if M.name == "rose-pine-dawn" then
  tab_bar.bg = "#f2e9e1"
  tab_bar.active_bg = "#faf4ed"
  tab_bar.active_fg = "#575279"
  tab_bar.inactive_bg = "#fffaf3"
  tab_bar.inactive_fg = "#6A6681"
elseif M.name:match("^rose%-pine") then
  tab_bar.bg = "#191724"
  tab_bar.active_bg = "#ebbcba"
  tab_bar.active_fg = "#191724"
  tab_bar.inactive_bg = "#26233a"
  tab_bar.inactive_fg = "#9ccfd8"
else -- Eldritch
  tab_bar.bg = "#171928"
  tab_bar.active_bg = "#37F499"
  tab_bar.active_fg = "#171928"
  tab_bar.inactive_bg = "#212337"
  tab_bar.inactive_fg = "#7081D0"
end
M.tab_bar = tab_bar

-- Process-to-icon mapping (shared by tabs and statusbar)
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

return M
