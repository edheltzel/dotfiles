local colors = require("colors")
local settings = require("settings")

-- Events that get pushed by yabai
sbar.add("event", "window_focus")
sbar.add("event", "title_change")

local front_app = sbar.add("item", "front_app", {
	position = "left",
	display = "active",
	icon = {
		font = {
			style = settings.font.style_map["Black"],
			size = 13.0,
		},
	},
	label = {
		font = {
			style = settings.font.style_map["Black"],
			size = 13.0,
		},
	},
	updates = true,
})

local function set_window_title()
	-- Offloading the "yabai -m query --windows --window" script to an external shell script so that we can determine whether the space has no windows
	sbar.exec("~/.config/scripts/query_window.sh", function(result)
		if result ~= "empty" and type(result) == "table" and result.title then
			local window_title = result.title
			if #window_title > 50 then
				window_title = window_title:sub(1, 50) .. "…"
			end
			front_app:set({ label = { string = window_title } })
		else
			front_app:set({ label = { string = "-" }, icon = { string = "empty" } })
		end
	end)
end

front_app:subscribe("front_app_switched", function()
	set_window_title()
end)

front_app:subscribe("space_change", function()
	set_window_title()
end)

front_app:subscribe("window_focus", function()
	set_window_title()
end)

front_app:subscribe("title_change", function()
	set_window_title()
end)

front_app:subscribe("front_app_switched", function(env)
	front_app:set({ icon = { string = env.INFO .. ":" } })
end)
