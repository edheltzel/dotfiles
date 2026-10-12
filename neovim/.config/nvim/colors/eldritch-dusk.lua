-- Eldritch Dusk (light). eldritch.nvim ships no Dusk palette, so register one.
-- Text accents are the Dusk palette darkened to >= 4.5:1 on #f0f3f4; the
-- official neons are decorative-only on light surfaces (eldritch SPEC.md).
-- Plugin slots map to SPEC Dusk roles: `green` (keywords) -> pink,
-- `yellow` (strings) -> orange, `comment` -> purple.
-- ponytail: rides eldritch.nvim's palette table; drop when upstream ships Dusk.
local util = require("eldritch.util")
local colors = require("eldritch.colors")

local git = { change = "#5b73dc", add = "#007f42", delete = "#df0514" }

colors.dusk = {
  none = "NONE",
  bg_dark = "#e2e6e8",
  bg = "#f0f3f4",
  bg_highlight = "#e2e6e8",
  terminal_black = "#888d91",
  fg = "#1e2029",
  fg_gutter = "#888d91",
  fg_gutter_light = "#888d91",
  dark3 = "#5b73dc",
  comment = "#754ef6",
  dark5 = "#888d91",
  bright_cyan = "#0099b7",
  visual = "#d5d9db",
  bg_visual = "#d5d9db",
  cyan = "#007992",
  dark_cyan = "#007992",
  magenta = "#754ef6",
  magenta2 = "#d5057c",
  magenta3 = "#f3c6dd",
  pink = "#d5057c",
  purple = "#754ef6",
  orange = "#d37400",
  yellow = "#a75c00",
  dark_yellow = "#767200",
  green = "#d5057c",
  bright_green = "#00a153",
  dark_green = "#007f42",
  red = "#df0514",
  bright_red = "#df0514",
  git = git,
  gitSigns = vim.deepcopy(git),
}

vim.o.background = "light"
vim.g.colors_name = "eldritch-dusk"
require("eldritch").load({
  palette = "dusk",
  -- Persists in eldritch's config across loads, so no-op for other palettes.
  on_colors = function(c)
    if require("eldritch.config").options.palette ~= "dusk" then
      return
    end
    c.diff.add = util.darken(git.add, 0.15)
    c.delta.add = util.darken(git.add, 0.45)
    c.todo = c.purple
  end,
})
