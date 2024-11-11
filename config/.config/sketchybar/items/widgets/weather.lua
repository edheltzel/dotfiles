local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local popup_width = 300

local weather_icon = sbar.add("item", "widgets.weather.icon", {
	position = "right",
	icon = {
		font = {
			family = settings.font.weather,
			size = 16.0,
		},
		string = "􀌏",
	},
	label = {
		font = {
			family = settings.font.numbers,
		},
		string = "...°",
	},
	update_freq = 180,
})

local weather_info = sbar.add("bracket", "widgets.weather.info", {
	weather_icon.name,
}, {
	background = {
		color = colors.bg2,
		border_color = colors.bg1,
		border_width = 2,
	},
	popup = { align = "center", height = 30 }
})

local function get_icon(icon_url)
	-- Map weather.gov icon URLs to our icon set
	local icons_map = {
		["skc"] = "􀆮", -- Clear sky
		["few"] = "􀇂", -- Few clouds
		["sct"] = "􀇕", -- Scattered clouds
		["bkn"] = "􀇂", -- Broken clouds
		["ovc"] = "􀇕", -- Overcast
		["wind_skc"] = "􀇤", -- Wind
		["wind_few"] = "􀇕", -- Wind, few clouds
		["wind_sct"] = "􀇂", -- Wind, scattered clouds
		["wind_bkn"] = "􀇔", -- Wind, broken clouds
		["wind_ovc"] = "􀇤", -- Wind, overcast
		["rain_showers"] = "􀇇", -- Rain showers
		["rain"] = "􀇆", -- Rain
		["tsra"] = "􀇞", -- Thunderstorm
		["tsra_sct"] = "􀇗", -- Scattered thunderstorms
		["tsra_hi"] = "􀇟", -- Heavy thunderstorms
		["snow"] = "􀇎", -- Snow
    ["rain_snow"] = "􀇑", -- Rain and snow
		["fzra"] = "􀇑", -- Freezing rain
		["fog"] = "􀇋", -- Fog
	}

	-- Extract the icon code from the URL, handling day/night prefix and removing any additional parameters
	local icon_code = string.match(icon_url or "", "/land/[^/]+/([^,?]+)")
	print("Extracted icon code: " .. (icon_code or "nil")) -- Debug print
	return icons_map[icon_code] or "􀇈" -- Default to a generic weather icon if no match
end

local function fetch_weather_data(callback)
	local command = "~/.config/scripts/weather.sh"
	sbar.exec(command, function(output)
		local temperature = string.match(output, "Temperature:%s*(%d+%.?%d*)°F")
		local icon = string.match(output, "Icon:%s*([^\n]+)")

		if temperature and icon then
			callback(temperature, icon)
		else
			print("Weather data extraction failed")
		end
	end)
end

weather_icon:subscribe({ "routine", "forced", "system_woke" }, function(env)
	fetch_weather_data(function(temperature, icon)
		if temperature and icon then
			weather_icon:set({
				label = {
					string = temperature .. "°",
					color = colors.dirty_white,
				},
				icon = {
					string = get_icon(icon),
					color = colors.dirty_white,
				},
			})
		end
	end)
end)

sbar.add("item", "widgets.weather_icon.padding", {
	position = "right",
	width = settings.group_paddings
})

local station_name = sbar.add("item", {
	position = "popup." .. weather_info.name,
	icon = {
		font = {
			style = settings.font.style_map["Bold"]
		},
		string = "􀌏",
	},
	width = popup_width,
	align = "center",
	label = {
		font = {
			size = 15,
			style = settings.font.style_map["Bold"]
		},
		max_chars = 30,
		string = "????????????",
	},
	background = {
		height = 2,
		color = colors.grey,
		y_offset = -15
	}
})

local temperature = sbar.add("item", {
	position = "popup." .. weather_info.name,
	icon = {
		align = "left",
		string = "Temperature:",
		width = popup_width / 2,
	},
	label = {
		string = "???",
		width = popup_width / 2,
		align = "right",
	}
})

local condition = sbar.add("item", {
	position = "popup." .. weather_info.name,
	icon = {
		align = "left",
		string = "Conditions:",
		width = popup_width / 2,
	},
	label = {
		string = "???",
		width = popup_width / 2,
		align = "right",
	}
})

local windspeed = sbar.add("item", {
	position = "popup." .. weather_info.name,
	icon = {
		align = "left",
		string = "Wind speed:",
		width = popup_width / 2,
	},
	label = {
		string = "???",
		width = popup_width / 2,
		align = "right",
	}
})

local function hide_details()
	weather_info:set({ popup = { drawing = false } })
end

local function toggle_details(env)
	local should_draw = weather_info:query().popup.drawing == "off"
	if should_draw then
		weather_info:set({ popup = { drawing = true } })
		sbar.exec("~/.config/scripts/weather.sh", function(result)
			local popup_temperature = string.match(result, "Temperature:%s*(%d+%.?%d*)°F")
			local popup_station_name = string.match(result, "Station Name:%s*(.-)\n")
			local popup_condition = string.match(result, "Condition:%s*(.-)\n")
			local popup_icon = string.match(result, "Icon:%s*(.-)\n")
			local popup_wind_speed = string.match(result, "Wind Speed:%s*(.-)\n")

			station_name:set({
				label = popup_station_name,
				icon = {
					string = get_icon(popup_icon),
					font = {
						family = settings.font.weather,
						size = 16.0,
					},
				}
			})

			temperature:set({ label = popup_temperature .. " °F" })
			condition:set({ label = popup_condition })
			windspeed:set({ label = popup_wind_speed })
		end)
	else
		hide_details()
	end

	if env.BUTTON == "right" then
		sbar.exec("open -a Weather")
	end
end

weather_icon:subscribe("mouse.clicked", toggle_details)
weather_info:subscribe("mouse.clicked", toggle_details)
