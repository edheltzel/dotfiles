-- Custom neoEd theme for lualine
-- Based on eldritch theme with custom color modifications

local M = {}

function M.setup()
  -- Start with the base eldritch theme
  local neoEd = require("plugins.themes.lualine.eldritch")

  -- Custom color palette
  local colors = {
    bg = "#212337",
    darkGray = "#323449",
    fg = "#454E7D",
    gray = "#586089",
    green = "#37F499",
    blue = "#04D1F9",
    purple = "#A48CF2",
    red = "#F16d75",
    magenta = "#F265B5",
  }

  -- Apply custom colors to modes
  neoEd.normal.a.fg = colors.fg
  neoEd.normal.a.bg = colors.bg
  neoEd.normal.b.fg = colors.fg
  neoEd.normal.b.bg = colors.fg
  neoEd.normal.c.fg = colors.fg
  neoEd.normal.c.bg = colors.bg

  neoEd.insert.a.bg = colors.magenta
  neoEd.insert.a.fg = colors.bg
  neoEd.insert.b.bg = colors.fg
  neoEd.insert.b.fg = colors.bg

  neoEd.visual.a.bg = colors.purple
  neoEd.visual.a.fg = colors.bg
  neoEd.visual.b.bg = colors.fg
  neoEd.visual.b.fg = colors.bg

  neoEd.replace.a.fg = colors.red
  neoEd.replace.a.bg = colors.bg
  neoEd.replace.b.fg = colors.fg
  neoEd.replace.b.bg = colors.bg

  neoEd.command.a.fg = colors.green
  neoEd.command.a.bg = colors.bg
  neoEd.command.b.fg = colors.fg
  neoEd.command.b.bg = colors.bg

  neoEd.terminal.a.fg = colors.bg
  neoEd.terminal.a.bg = colors.red
  neoEd.terminal.b.fg = colors.bg
  neoEd.terminal.b.bg = colors.red

  neoEd.inactive.b.fg = colors.fg
  neoEd.inactive.b.bg = colors.bg

  -- Add color properties for easy access
  neoEd.fg = colors.fg
  neoEd.gray = colors.gray

  return neoEd
end

return M
