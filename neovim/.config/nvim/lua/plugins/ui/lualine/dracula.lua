---- Dracula color palettes for NEO.ED theme
-- https://draculatheme.com/

local M = {}

M.palettes = {
  ["dracula"] = {
    colors = {
      darker = "#21222c", -- darkest background (ansi black)
      bg = "#282a36", -- main background
      darkGray = "#44475a", -- selection / current line
      fg = "#f8f8f2", -- primary foreground
      gray = "#6272a4", -- secondary foreground (comment)
      green = "#50fa7b", -- command mode accent
      blue = "#8be9fd", -- cyan (currently unused)
      purple = "#bd93f9", -- visual mode accent
      red = "#ff5555", -- replace / terminal mode accent
      magenta = "#ff79c6", -- insert mode accent (pink)
    },
  },
  ["alucard"] = {
    colors = {
      darker = "#ECE9DF", -- bglighter (inactive)
      bg = "#FFFBEB", -- paper background
      darkGray = "#CFCFDE", -- selection
      fg = "#1F1F1F",
      gray = "#6C664B", -- comment
      green = "#14710A",
      blue = "#036A96", -- cyan
      purple = "#644AC9",
      red = "#CB3A2A",
      magenta = "#A3144D", -- pink
    },
  },
}

function M.get_colors(variant)
  variant = variant or "dracula"
  local palette = M.palettes[variant] or M.palettes["dracula"]
  local overrides = palette.get_overrides and palette.get_overrides(palette.colors) or nil
  return palette.colors, overrides
end

return M
