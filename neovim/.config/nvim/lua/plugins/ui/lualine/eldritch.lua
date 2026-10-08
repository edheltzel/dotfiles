---- Eldritch color palettes for NEO.ED theme
-- https://github.com/eldritch-theme/eldritch.nvim

local M = {}

M.palettes = {
  ["eldritch"] = {
    colors = {
      darker = "#171928",
      bg = "#212337",
      darkGray = "#323449",
      fg = "#454E7D",
      gray = "#586089",
      green = "#37F499",
      blue = "#04D1F9",
      purple = "#A48CF2",
      red = "#F16d75",
      magenta = "#F265B5",
    },
    -- Override function receives colors table, return overrides
    -- Example: Custom color for replace mode
    -- get_overrides = function(colors)
    --   return {
    --     replace = {
    --       a = { fg = colors.red, bg = colors.darker },
    --     },
    --   }
    -- end,
  },
}

function M.get_colors(variant)
  variant = variant or "eldritch"
  local palette = M.palettes[variant] or M.palettes["eldritch"]
  local overrides = palette.get_overrides and palette.get_overrides(palette.colors) or nil
  return palette.colors, overrides
end

return M
