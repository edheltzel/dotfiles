---- Vesper color palette for NEO.ED theme
-- https://github.com/datsfilipe/vesper.nvim
--
-- Colors are the resolved values from vesper.nvim's own palette
-- (lua/vesper/colors.lua). The mode overrides mirror vesper's shipped
-- lualine theme (lua/lualine/themes/vesper.lua) so the statusline matches
-- the colorscheme exactly.

local M = {}

M.palettes = {
  ["vesper"] = {
    colors = {
      darker = "#161616",
      bg = "#202020",
      darkGray = "#232323",
      fg = "#CCCCCC",
      gray = "#7D7D7D",
      green = "#82D9C2",
      blue = "#99FFE4",
      purple = "#FFCFA8",
      red = "#FF8080",
      magenta = "#FFCFA8",
    },
    -- Mirror vesper.nvim's own lualine mode colors for a faithful look
    get_overrides = function(colors)
      local orange = "#FFCFA8"
      local primary = "#A0A0A0"
      return {
        normal = {
          a = { fg = colors.bg, bg = orange, gui = "bold" },
          b = { fg = primary, bg = colors.bg },
          c = { fg = primary, bg = colors.bg },
        },
        insert = {
          a = { fg = colors.bg, bg = colors.red, gui = "bold" },
          b = { fg = colors.gray, bg = colors.bg },
        },
        visual = {
          a = { fg = colors.bg, bg = colors.green, gui = "bold" },
          b = { fg = colors.gray, bg = colors.bg },
        },
        replace = {
          a = { fg = colors.bg, bg = orange, gui = "bold" },
          b = { fg = colors.gray, bg = colors.bg },
        },
        command = {
          a = { fg = colors.bg, bg = colors.green, gui = "bold" },
          b = { fg = colors.gray, bg = colors.bg },
        },
        terminal = {
          a = { fg = colors.bg, bg = colors.green, gui = "bold" },
          b = { fg = colors.gray, bg = colors.bg },
        },
        inactive = {
          a = { fg = colors.bg, bg = colors.gray },
          b = { fg = orange, bg = colors.bg, gui = "bold" },
          c = { fg = orange, bg = colors.bg },
        },
      }
    end,
  },
}

function M.get_colors(variant)
  variant = variant or "vesper"
  local palette = M.palettes[variant] or M.palettes["vesper"]
  local overrides = palette.get_overrides and palette.get_overrides(palette.colors) or nil
  return palette.colors, overrides
end

return M
