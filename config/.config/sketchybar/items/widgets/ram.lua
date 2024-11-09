local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- RAM Plugin
local ram = sbar.add("item", "widgets.ram1", {
	position = "right",
	padding_left = -5,
	width = 0,
	icon = {
		padding_right = 0,
		padding_left = 0,
		font = {
			style = settings.font.style_map["Bold"],
			size = 9.0,
		},
		string = icons.ramicons.ram,
	},
	label = {
		font = {
			style = settings.font.style_map["Bold"],
			size = 9.0,
		},
		padding_left = 14,
		padding_right = 8,
		color = colors.grey,
		string = "??? %",
	},
	y_offset = 4,
	update_freq = 180,
})

-- SWAP Plugin
local swap = sbar.add("item", "widgets.swap1", {
	position = "right",
	padding_left = -5,
	icon = {
		padding_right = 0,
		padding_left = 0,
		font = {
			style = settings.font.style_map["Bold"],
			size = 9.0,
		},
		string = icons.ramicons.swap,
	},
	label = {
		font = {
			family = "SF Mono",
			style = settings.font.style_map["Bold"],
			size = 9.0,
		},
		color = colors.grey,
		string = "??.? Mb",
	},
	y_offset = -4,
	update_freq = 180,
})

local swapram = sbar.add("item", "widgets.ram.padding", {
	position = "right",
	label = { drawing = false, },
})

local ram_bracket = sbar.add("bracket", "widgets.ram.bracket", {
	swapram.name,
	ram.name,
	swap.name
}, {
	background = {
		color = colors.bg2,
		border_color = colors.bg1,
		border_width = 2,
	}
})


sbar.add("item", { position = "right", width = settings.group_paddings })


ram:subscribe({ "routine", "forced" }, function(env)
	sbar.exec("memory_pressure | grep -o 'System-wide memory free percentage: [0-9]*' | awk '{print $5}'",
		function(freeram)
			local usedram = 100 - tonumber(freeram)
			local Color = colors.grey
			local label = tostring(usedram) .. " %"

			if usedram >= 80 then
				Color = colors.red
				label = "KILL ME"
				Padding_left = 0
			elseif usedram >= 60 then
				Color = colors.red
			elseif usedram >= 30 then
				Color = colors.orange
			elseif usedram >= 20 then
				Color = colors.yellow
			end

			ram:set({
				label = {
					string = label,
					color = Color,
					padding_left = Padding_left,
				},
				icon = {
					color = Color,
				},
			})
		end)
end)




swap:subscribe({ "routine", "forced" }, function(env)
	sbar.exec("sysctl -n vm.swapusage | awk '{print $6}' | sed 's/M//'", function(swapstore_untrimmed)
		if swapstore_untrimmed then
			-- Entferne das Leerzeichen am Ende der Ausgabe
			local swapstore = swapstore_untrimmed:gsub("%s*$", "")
			-- Ersetze das Komma durch einen Punkt
			swapstore = swapstore:gsub(",", ".")
			local swapuse = tonumber(swapstore)

			local function formatSwapUsage(swapuse)
				if swapuse < 1 then
					return "0.00 Mb", colors.grey
				elseif swapuse < 100 then
					return string.format("%03d Mb", math.floor(swapuse)), colors.dirtywhite
				elseif swapuse < 1000 then
					return string.format("%03d Mb", math.floor(swapuse)), colors.yellow
				elseif swapuse < 2000 then
					return string.format("%.2f Gb", swapuse / 1000), colors.orange
				elseif swapuse < 10000 then
					return string.format("%.2f Gb", swapuse / 1000), colors.red
				else
					return string.format("%.1f Gb", swapuse / 1000), colors.red
				end
			end

			local swapLabel, swapColor = formatSwapUsage(swapuse)
			swap:set({
				label = {
					string = swapLabel,
					color = swapColor,
				},
				icon = {
					color = swapColor,
				},
			})
		end
	end)
end)
