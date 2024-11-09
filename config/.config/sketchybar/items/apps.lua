local colors = require("colors")
local default = require("default")
local settings = require("settings")

local apps = sbar.add("bracket", "apps", {}, {
	position = "left",
	label = {
		font = {
			style = settings.font.style_map["Black"],
			size = 12.0,
		},
	},
	background = {
		color = colors.bg2,
		border_color = colors.bg1,
		border_width = 2,
	},
})

local function focus_window(env)
	sbar.exec("yabai -m query --windows id,has-focus", function(output)
		for _, line in ipairs(output) do
			sbar.set("apps." .. line.id, {
				label = {
					highlight = line['has-focus'],
				}
			})
		end
	end)
end

local function update_windows(windows)
	-- need to check if exists
	sbar.remove("/apps.\\.*/")
	for _, line in ipairs(windows) do
		width = 655 / #windows
		sbar.add("item", "apps." .. line['id'], {
			label = {
				string = line['app'] .. ": " .. line['title'],
				max_chars = width,
				scroll_duration = 150,
				width = width,
				highlight_color = colors.pink,
				highlight = line['has-focus'],
			},
			padding_right = 2,
			click_script = "yabai -m window --focus " .. line['id'],
		})
	end
end

local function get_apps(env)
	sbar.exec("yabai -m query --windows id,title,app,has-focus --space", update_windows)
end


apps:subscribe("space_change", get_apps)
apps:subscribe("front_app_changed", get_apps)
apps:subscribe("title_change", get_apps)
apps:subscribe("window_focus", get_apps)
apps:subscribe("front_app_switched", focus_window)
