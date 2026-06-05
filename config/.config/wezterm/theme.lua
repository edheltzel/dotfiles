-- theme.lua: Single source of truth for theme selection, color variables,
-- and process icon mappings. All shared data lives here.

local wezterm = require("wezterm")
local M = {}

-- Helper: extract basename from path (shared across modules)
function M.basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- Theme selection: set by theme-switcher, must match a WezTerm color_scheme name
M.name = "Catppuccin Latte"

-- Theme data lookup table (colors + tab_bar per theme)
local themes = {
  ["Aura"] = {
    colors = {
      red = "#FF6767",
      purple = "#A277FF",
      cyan = "#82E2FF",
      yellow = "#FFCA85",
      pink = "#F694FF",
      white = "#EDECEE",
    },
    tab_bar = {
      bg = "#15141B",
      active_bg = "#A277FF",
      active_fg = "#15141B",
      inactive_bg = "#1C1B22",
      inactive_fg = "#6D6D6D",
      agent_activity = "#FFCA85",
    },
  },
  ["Eldritch"] = {
    colors = {
      red = "#F16C75",
      red2 = "#AD4E54",
      red3 = "#743E42",
      purple = "#A48CF2",
      purple_alt = "#7081D0",
      cyan = "#04D1F9",
      yellow = "#F7F67F",
      pink = "#F265B5",
      white = "#EBFAFA",
      green = "#37F499",
      orange = "#F7C67F",
      dark = "#212337",
      black = "#171928",
    },
    tab_bar = {
      bg = "#171928",
      active_bg = "#37F499",
      active_fg = "#171928",
      inactive_bg = "#212337",
      inactive_fg = "#7081D0",
      agent_activity = "#F7C67F",
    },
  },
  ["Eldritch Light"] = {
    colors = {
      red = "#E83D50",
      red2 = "#C42D3F",
      red3 = "#8F1F2C",
      purple = "#7A5CF0",
      purple_alt = "#5A45C4",
      cyan = "#00AEE0",
      yellow = "#C8AB00",
      pink = "#E63F9B",
      white = "#171928", -- semantic "fg" slot — inverted to navy for dark text on light bg
      green = "#1FD085",
      orange = "#E88A2C",
      dark = "#DDDFEA", -- inverted from Eldritch's #212337
      black = "#EDEEF5", -- inverted from Eldritch's #171928 (true bg)
    },
    tab_bar = {
      bg = "#DDDFEA",
      active_bg = "#1FD085",
      active_fg = "#171928",
      inactive_bg = "#DDDFEA",
      inactive_fg = "#5A45C4",
      agent_activity = "#E88A2C",
    },
  },
  ["rose-pine"] = {
    colors = {
      red = "#eb6f92",
      purple = "#c4a7e7",
      cyan = "#9ccfd8",
      yellow = "#f6c177",
      pink = "#ebbcba",
      white = "#e0def4",
    },
    tab_bar = {
      bg = "#191724",
      active_bg = "#ebbcba",
      active_fg = "#191724",
      inactive_bg = "#26233a",
      inactive_fg = "#9ccfd8",
      agent_activity = "#f6c177",
    },
  },
  ["rose-pine-dawn"] = {
    colors = {
      red = "#b4637a",
      purple = "#907aa9",
      cyan = "#56949f",
      yellow = "#ea9d34",
      pink = "#d7827e",
      white = "#575279",
    },
    tab_bar = {
      bg = "#f2e9e1",
      active_bg = "#faf4ed",
      active_fg = "#575279",
      inactive_bg = "#fffaf3",
      inactive_fg = "#6A6681",
      agent_activity = "#ea9d34",
    },
  },
  ["rose-pine-moon"] = {
    colors = {
      red = "#eb6f92",
      purple = "#c4a7e7",
      cyan = "#9ccfd8",
      yellow = "#f6c177",
      pink = "#ea9a97",
      white = "#e0def4",
    },
    tab_bar = {
      bg = "#232136",
      active_bg = "#ea9a97",
      active_fg = "#232136",
      inactive_bg = "#232136",
      inactive_fg = "#9ccfd8",
      agent_activity = "#f6c177",
    },
  },
  ["Tokyo Night"] = {
    colors = {
      red = "#F7768E",
      purple = "#BB9AF7",
      cyan = "#7AA2F7",
      yellow = "#E0AF68",
      pink = "#FF9E64",
      white = "#C0CAF5",
    },
    tab_bar = {
      bg = "#1A1B26",
      active_bg = "#BB9AF7",
      active_fg = "#1A1B26",
      inactive_bg = "#1A1B26",
      inactive_fg = "#565F89",
      agent_activity = "#E0AF68",
    },
  },
  ["Tokyo Night Moon"] = {
    colors = {
      red = "#FF757F",
      purple = "#C099FF",
      cyan = "#82AAFF",
      yellow = "#FFC777",
      pink = "#FF966C",
      white = "#C8D3F5",
    },
    tab_bar = {
      bg = "#222236",
      active_bg = "#C099FF",
      active_fg = "#222236",
      inactive_bg = "#222236",
      inactive_fg = "#636DA6",
      agent_activity = "#FFC777",
    },
  },
  ["Catppuccin Latte"] = {
    colors = {
      red = "#d20f39",
      purple = "#8839ef",
      cyan = "#04a5e5",
      yellow = "#df8e1d",
      pink = "#ea76cb",
      white = "#4c4f69",
    },
    tab_bar = {
      bg = "#eff1f5",
      active_bg = "#8839ef",
      active_fg = "#dce0e8",
      inactive_bg = "#e6e9ef",
      inactive_fg = "#8c8fa1",
      agent_activity = "#fe640b",
    },
  },
  ["Catppuccin Frappe"] = {
    colors = {
      red = "#e78284",
      purple = "#ca9ee6",
      cyan = "#99d1db",
      yellow = "#e5c890",
      pink = "#f4b8e4",
      white = "#c6d0f5",
    },
    tab_bar = {
      bg = "#303446",
      active_bg = "#ca9ee6",
      active_fg = "#232634",
      inactive_bg = "#292c3c",
      inactive_fg = "#838ba7",
      agent_activity = "#ef9f76",
    },
  },
  ["Catppuccin Macchiato"] = {
    colors = {
      red = "#ed8796",
      purple = "#c6a0f6",
      cyan = "#91d7e3",
      yellow = "#eed49f",
      pink = "#f5bde6",
      white = "#cad3f5",
    },
    tab_bar = {
      bg = "#24273a",
      active_bg = "#c6a0f6",
      active_fg = "#181926",
      inactive_bg = "#1e2030",
      inactive_fg = "#8087a2",
      agent_activity = "#f5a97f",
    },
  },
  ["Catppuccin Mocha"] = {
    colors = {
      red = "#f38ba8",
      purple = "#cba6f7",
      cyan = "#89dceb",
      yellow = "#f9e2af",
      pink = "#f5c2e7",
      white = "#cdd6f4",
    },
    tab_bar = {
      bg = "#1e1e2e",
      active_bg = "#cba6f7",
      active_fg = "#11111b",
      inactive_bg = "#181825",
      inactive_fg = "#7f849c",
      agent_activity = "#fab387",
    },
  },
}

-- Resolve theme key (fallback to Eldritch if unknown)
local function get_theme_key(name)
  if themes[name] then
    return name
  end
  return "Eldritch"
end

local theme_data = themes[get_theme_key(M.name)]
M.colors = theme_data.colors
M.tab_bar = theme_data.tab_bar

-- Agent processes: names that trigger "agent activity" tab coloring
-- Matches against basename of foreground_process_name AND user_vars.WEZTERM_PROG
M.agent_processes = {
  claude = true,
  opencode = true,
  gemini = true,
  aider = true,
  copilot = true,
  pi = true,
}

-- Note: Agent idle/working detection lives in tabs.lua's update-status handler,
-- which uses full Pane API (get_foreground_process_info) for argv inspection.
-- The agent_processes table above is the single source of truth for agent names.

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
  pi = wezterm.nerdfonts.fa_robot,
}

-- Helper: extract file path from CWD URI (handles Url object or string)
function M.get_cwd_path(cwd_uri)
  if not cwd_uri then
    return ""
  end
  if type(cwd_uri) == "userdata" then
    return cwd_uri.file_path or ""
  end
  return tostring(cwd_uri)
end

-- Helper: resolve process icon from title and process name
function M.get_process_icon(title, proc_name, default_icon)
  local title_cmd = title and title:match("^(%S+)")
  return (title_cmd and M.process_icons[title_cmd]) or M.process_icons[proc_name] or default_icon
end

return M
