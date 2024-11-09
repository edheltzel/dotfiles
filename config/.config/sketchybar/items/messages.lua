local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local messages = sbar.add("item", "widgets.messages", {
	position = "right",
	icon = {
		font = {
			style = settings.font.style_map["Regular"],
			size = 13.0,
		},
		string = "􀌤",
		padding_left = 8,
	},
	label = {
		font = {
			family = settings.font.numbers
		},
		padding_right = 8,
	},
	background = {
		color = colors.bg2,
		border_color = colors.bg1,
		border_width = 2,
	},
	update_freq = 30,
})

messages:subscribe({ "routine", "front_app_changed", "space_change", "space_windows_change" }, function(env)
	sbar.exec(
	-- requires full disk access
		[[sqlite3 ~/Library/Messages/chat.db "SELECT COUNT(guid) FROM message WHERE NOT(is_read) AND NOT(is_from_me) AND text !=''"]],
		function(newmess)
			local mess = tonumber(newmess)
			local drawing = false
			local string = ""
			local color = colors.green

			if mess > 0 then
				drawing = true
				string = tostring(mess)
			end

			messages:set({
				label = {
					drawing = drawing,
					string = string,
				},
				icon = {
					color = color,
					drawing = drawing,
				},
				background = {
					drawing = drawing,
				},
			})
		end)
end)

messages:subscribe("mouse.clicked", function(env)
	sbar.exec("open -a 'Messages'")
end)
