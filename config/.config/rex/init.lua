local config_dir = debug.getinfo(1, "S").source:gsub("^@", ""):match("(.*/)") or "./"
package.path = config_dir .. "lua/?.lua;" .. package.path

require("workflow")
require("keymaps.workflow")
require("keymaps.tmux")
require("keymaps.herdr")
require("keymaps.ghostty")
require("keymaps.kitty")
