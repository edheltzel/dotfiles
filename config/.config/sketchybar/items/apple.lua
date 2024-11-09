local colors = require("colors")
local icons = require("icons")
local settings = require("settings")


local apple = sbar.add("item", {
	icon = {
		font = { size = 20.0 },
		string = icons.apple,
		padding_right = 10,
		padding_left = 10,
		color = colors.purple,
		y_offset = 1,
	},
	label = { drawing = false },
	padding_left = 1,
	padding_right = 1,
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0"
})
