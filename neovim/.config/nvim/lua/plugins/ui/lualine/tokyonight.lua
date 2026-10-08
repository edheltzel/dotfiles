---- Tokyo Night color palettes for NEO.ED theme
-- https://github.com/folke/tokyonight.nvim

local M = {}

M.palettes = {
  ["tokyonight"] = {
    colors = {
      darker = "#16161e",
      bg = "#1a1b26",
      darkGray = "#283457",
      fg = "#c0caf5",
      gray = "#565f89",
      green = "#9ece6a",
      blue = "#7aa2f7",
      purple = "#bb9af7",
      red = "#f7768e",
      magenta = "#bb9af7",
    },
  },
}

function M.get_colors(variant)
  variant = variant or "tokyonight"
  local palette = M.palettes[variant] or M.palettes["tokyonight"]
  local overrides = palette.get_overrides and palette.get_overrides(palette.colors) or nil
  return palette.colors, overrides
end

return M
