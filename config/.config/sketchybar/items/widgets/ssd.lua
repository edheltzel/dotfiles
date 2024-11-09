local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local ssd = sbar.add("item", "widgets.ssd", {
	position = "right",
	width = 0,
	icon = {
		drawing = false,
	},
	label = {
		font = {
			style = settings.font.style_map["Bold"],
			size = 6.0,
		},
		padding_left = 0,
		padding_right = 13,
		color = colors.grey,
		string = "SSD",
		y_offset = 6,
	},
})


local ssd_volume = sbar.add("item", "widgets.ssd.volume", {
	position = "right",
	icon = {
		font = {
			size = 16.0,
		},
		string = "󰅚",
	},
	label = {
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 12.0,
		},
		string = "...%",
		y_offset = -2
	},
	update_freq = 180,
})


local ssd_padding = sbar.add("item", "widgets.ssd.padding", {
	position = "right",
	width = settings.group_paddings
})


local ssd_bracket = sbar.add("bracket", "widgets.ssd.bracket", {
	ssd.name,
	ssd_volume.name,
}, {
	background = {
		color = colors.bg2,
		border_color = colors.bg1,
		border_width = 2,
	},
	popup = { align = "center", height = 30 }
})

ssd_volume:subscribe({ "routine", "forced" }, function(env)
	sbar.exec("df -H /System/Volumes/Data | awk 'END {print $5}' | sed 's/%//'", function(usedstorage)
		if usedstorage then
			local storage = tonumber(usedstorage)
			if storage >= 98 then
				Label = storage .. "%"
				Icon = "󰪥"
				Color = colors.red
			elseif storage >= 88 then
				Label = storage .. "%"
				Icon = "󰪤"
				Color = colors.orange
			elseif storage >= 76 then
				Label = storage .. "%"
				Icon = "󰪣"
				Color = colors.yellow
			elseif storage >= 64 then
				Icon = "󰪢"
				Label = storage .. "%"
			elseif storage >= 52 then
				Icon = "󰪡"
				Label = storage .. "%"
			elseif storage >= 40 then
				Icon = "󰪠"
				Label = storage .. "%"
			elseif storage >= 28 then
				Icon = "󰪟"
				Label = storage .. "%"
			elseif storage >= 16 then
				Icon = "󰪞"
				Label = storage .. "%"
			elseif storage >= 1 then
				Icon = "󰝦"
				Label = storage .. "%"
			else
				Icon = "󰅚"
				Label = "whut"
			end

			ssd_volume:set({
				label = {
					string = Label,
					color = Color,
				},
				icon = {
					string = Icon,
					color = Color,
				},
			})
		end
	end)
end)

ssd_volume:subscribe("mouse.clicked", function(env)
	sbar.exec("open -a 'DaisyDisk'")
end)



local system_indicator = sbar.add("item", {
	position = "right",
	padding_left = 0,
	padding_right = -3,
	icon = {
		padding_left = 8,
		padding_right = 9,
		color = colors.grey,
		string = icons.switch.on,
	},
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		string = "sys",
		color = colors.bg1,
	},
	background = {
		color = colors.with_alpha(colors.grey, 0.0),
		border_color = colors.with_alpha(colors.bg1, 0.0),
	}
})


system_indicator:subscribe("swap_system_info", function(env)
	local currently_on = system_indicator:query().icon.value == icons.switch.on
	system_indicator:set({
		icon = currently_on and icons.switch.off or icons.switch.on
	})
end)

system_indicator:subscribe("mouse.entered", function(env)
	sbar.animate("tanh", 30, function()
		system_indicator:set({
			background = {
				color = { alpha = 1.0 },
				border_color = { alpha = 1.0 },
			},
			icon = { color = colors.bg1 },
			label = { width = "dynamic" }
		})
	end)
end)

system_indicator:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 30, function()
		system_indicator:set({
			background = {
				color = { alpha = 0.0 },
				border_color = { alpha = 0.0 },
			},
			icon = { color = colors.grey },
			label = { width = 0, }
		})
	end)
end)

system_indicator:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_system_info")
end)

local system_info_swap = sbar.add("item", {
	drawing = false,
	updates = true,
})

system_info_swap:subscribe("swap_system_info", function(env)
	local drawing = ssd:query().geometry.drawing == "on"
	if drawing then
		sbar.set("widgets.wifi1", { drawing = false })
		sbar.set("widgets.wifi2", { drawing = false })
		sbar.set("/ram\\.*/", { drawing = false })
		sbar.set("/swap\\.*/", { drawing = false })
		sbar.set("/cpu\\.*/", { drawing = false })
		sbar.set("/ssd\\.*/", { drawing = false })
		system_indicator:set({
			padding_right = -8,
		})
	else
		sbar.set("widgets.wifi1", { drawing = true })
		sbar.set("widgets.wifi2", { drawing = true })
		sbar.set("/ram\\.*/", { drawing = true })
		sbar.set("/swap\\.*/", { drawing = true })
		sbar.set("/cpu\\.*/", { drawing = true })
		sbar.set("/ssd\\.*/", { drawing = true })
		system_indicator:set({
			padding_right = -3,
		})
	end
end)
