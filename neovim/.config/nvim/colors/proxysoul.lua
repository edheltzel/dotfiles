-- ProxySoul (dark). eldritch.nvim ships no ProxySoul palette, so register one.
-- Colors from proxySoul's kitty theme (deep purple with hot pink accents):
-- https://github.com/proxysoul/dotfiles/blob/master/kitty/proxysoul-main.conf
-- ponytail: rides eldritch.nvim's palette table, like colors/eldritch-dusk.lua.
local util = require("eldritch.util")
local colors = require("eldritch.colors")

local git = { change = "#00a2ce", add = "#0b8b00", delete = "#ee0b2a" }

colors.proxysoul = {
  none = "NONE",
  bg_dark = "#120e22",
  bg = "#020204",
  bg_highlight = "#1a1830",
  terminal_black = "#3d3b50",
  fg = "#e7e7ee",
  fg_dark = "#8e8ca1",
  fg_gutter = "#3d3b50",
  fg_gutter_light = "#726e88",
  dark3 = "#726e88",
  comment = "#726e88",
  dark5 = "#524d68",
  bright_cyan = "#3bb8d8",
  visual = "#241c3d",
  bg_visual = "#241c3d",
  cyan = "#00a2ce",
  dark_cyan = "#009a8b",
  magenta = "#9b6af5",
  magenta2 = "#ff0059",
  magenta3 = "#3a0f1a",
  pink = "#ff0059",
  purple = "#9b6af5",
  orange = "#e65f2a",
  yellow = "#de7c00",
  dark_yellow = "#b06200",
  green = "#ff3d7f",
  bright_green = "#3fc85a",
  dark_green = "#0b8b00",
  red = "#ee0b2a",
  bright_red = "#ff0059",
  git = git,
  gitSigns = vim.deepcopy(git),
}

vim.o.background = "dark"
vim.g.colors_name = "proxysoul"
require("eldritch").load({
  palette = "proxysoul",
  -- Persists in eldritch's config across loads, so no-op for other palettes.
  on_colors = function(c)
    if require("eldritch.config").options.palette ~= "proxysoul" then
      return
    end
    c.diff.add = util.darken(git.add, 0.15)
    c.delta.add = util.darken(git.add, 0.45)
    c.todo = c.purple
  end,
})
