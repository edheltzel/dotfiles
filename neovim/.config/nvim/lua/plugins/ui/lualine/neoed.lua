---- NEO.ED - A colorscheme-adaptive lualine theme
--
-- This theme automatically adapts to your current Neovim colorscheme by loading
-- matching color palettes from separate palette files.
--
-- SUPPORTED COLORSCHEMES:
--   - eldritch
--   - tokyonight
--   - rose-pine, rose-pine-moon, rose-pine-dawn
--   - catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
--   - vesper
--   - dracula, alucard
--   - gruvbox
--
-- HOW IT WORKS:
--   1. Detects current colorscheme via vim.g.colors_name
--   2. Loads matching color palette from lua/plugins/ui/lualine/{colorscheme}.lua
--   3. Builds a lualine theme using build_lualine_theme()
--   4. Applies palette-specific overrides (if defined in palette file)
--   5. Applies global overrides (if defined below)
--   6. Returns theme (for lualine mode colors) + colors (for custom components)
--
-- AUTO-REFRESH:
--   An autocmd in lua/config/autocmds.lua automatically refreshes lualine when
--   you change colorschemes. Manual refresh: :LualineRefresh
--
-- CUSTOMIZATION:
--   - Per-colorscheme: Edit palette files and add 'overrides' table
--   - Global: Edit 'global_overrides' table below (applies to ALL colorschemes)
--   See lua/plugins/ui/lualine/README.md for detailed instructions
--
local M = {}

-- Global overrides applied to ALL colorschemes (optional)
-- These override both base colors and palette-specific overrides
-- Example: Force all themes to use a specific terminal mode color
local global_overrides = {
  -- Uncomment and customize as needed:
  -- terminal = {
  --   a = { fg = "#000000", bg = "#E50A69" },
  -- },
}

-- Build the lualine theme (only mode definitions)
local function build_lualine_theme(colors)
  return {
    normal = {
      a = { fg = colors.fg, bg = colors.bg },
      b = { fg = colors.fg, bg = colors.fg },
      c = { fg = colors.fg, bg = colors.bg },
    },
    insert = {
      a = { fg = colors.bg, bg = colors.magenta },
      b = { fg = colors.bg, bg = colors.fg },
    },
    visual = {
      a = { fg = colors.bg, bg = colors.purple },
      b = { fg = colors.bg, bg = colors.fg },
    },
    replace = {
      a = { fg = colors.red, bg = colors.bg },
      b = { fg = colors.fg, bg = colors.bg },
    },
    command = {
      a = { fg = colors.green, bg = colors.bg },
      b = { fg = colors.fg, bg = colors.bg },
    },
    terminal = {
      a = { fg = colors.bg, bg = colors.red },
      b = { fg = colors.bg, bg = colors.red },
    },
    inactive = {
      a = { fg = colors.fg, bg = colors.darker },
      b = { fg = colors.fg, bg = colors.bg, gui = "bold" },
      c = { fg = colors.fg, bg = colors.darker },
    },
  }
end

-- Get colors and overrides for current colorscheme
local function get_colors(colorscheme)
  if colorscheme:match("^rose%-pine") then
    local rose_pine = require("plugins.ui.lualine.rose-pine")
    return rose_pine.get_colors(colorscheme)
  elseif colorscheme == "eldritch" then
    local eldritch = require("plugins.ui.lualine.eldritch")
    return eldritch.get_colors(colorscheme)
  elseif colorscheme == "tokyonight" or colorscheme:match("^tokyonight") then
    local tokyonight = require("plugins.ui.lualine.tokyonight")
    return tokyonight.get_colors("tokyonight")
  elseif colorscheme:match("^catppuccin") then
    local catppuccin = require("plugins.ui.lualine.catppuccin")
    return catppuccin.get_colors(colorscheme)
  elseif colorscheme == "vesper" then
    local vesper = require("plugins.ui.lualine.vesper")
    return vesper.get_colors(colorscheme)
  elseif colorscheme == "dracula" or colorscheme == "alucard" then
    local dracula = require("plugins.ui.lualine.dracula")
    return dracula.get_colors(colorscheme)
  elseif colorscheme == "gruvbox" then
    local gruvbox = require("plugins.ui.lualine.gruvbox")
    return gruvbox.get_colors(colorscheme)
  else
    -- Fallback for unknown colorschemes: use eldritch colors
    -- vim.notify("NEO.ED: Unknown colorscheme, using eldritch fallback", vim.log.levels.WARN)
    local eldritch = require("plugins.ui.lualine.eldritch")
    return eldritch.get_colors("eldritch")
  end
end

-- Returns: theme (for lualine), colors (for component styling)
-- @param colorscheme_override: Optional colorscheme name (used by autocmd when vim.g.colors_name isn't set yet)
function M.setup(colorscheme_override)
  -- Priority: override > vim.g.colors_name > LazyVim config > fallback
  local colorscheme = colorscheme_override or vim.g.colors_name

  -- If vim.g.colors_name is nil (early load), try to get from LazyVim config
  if not colorscheme then
    local ok, lazyvim_colorscheme = pcall(function()
      return LazyVim.opts("LazyVim").colorscheme
    end)
    if ok and lazyvim_colorscheme then
      colorscheme = lazyvim_colorscheme
    end
  end

  -- Final fallback
  colorscheme = colorscheme or "eldritch"
  local colors, palette_overrides = get_colors(colorscheme)

  -- Build base theme from colors
  local theme = build_lualine_theme(colors)

  -- Apply palette-specific overrides (if any)
  if palette_overrides then
    theme = vim.tbl_deep_extend("force", theme, palette_overrides)
  end

  -- Apply global overrides (if any)
  if global_overrides and next(global_overrides) then
    theme = vim.tbl_deep_extend("force", theme, global_overrides)
  end

  return theme, {
    fg = colors.fg,
    gray = colors.gray,
    dark = colors.darker,
    red = colors.red,
  }
end

return M
