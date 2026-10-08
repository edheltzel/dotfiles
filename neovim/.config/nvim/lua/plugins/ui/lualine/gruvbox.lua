---- Gruvbox Dark color palettes for NEO.ED theme
-- https://github.com/morhetz/gruvbox

local M = {}

M.palettes = {
  ["gruvbox"] = {
    colors = {
      darker = "#1d2021", -- bg0_hard (darkest background)
      bg = "#282828", -- bg0 (main background)
      darkGray = "#3c3836", -- bg1 (selection)
      fg = "#ebdbb2", -- fg1 (primary foreground)
      gray = "#928374", -- gray (secondary foreground)
      green = "#b8bb26", -- command mode accent
      blue = "#83a598", -- blue (currently unused)
      purple = "#d3869b", -- visual mode accent
      red = "#fb4934", -- replace / terminal mode accent
      magenta = "#fe8019", -- insert mode accent (orange)
    },
  },
}

function M.get_colors(variant)
  variant = variant or "gruvbox"
  local palette = M.palettes[variant] or M.palettes["gruvbox"]
  local overrides = palette.get_overrides and palette.get_overrides(palette.colors) or nil
  return palette.colors, overrides
end

return M
