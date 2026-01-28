-- theme.lua: Single source of truth for theme selection and all color variables.
-- All accent colors and tab bar colors are derived from the active theme.

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

return M
