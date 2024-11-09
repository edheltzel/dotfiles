local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}

-- Create the container bracket
local container_bracket = sbar.add("bracket", {}, {
	background = {
		color = colors.bg2,
		border_color = colors.bg1,
		border_width = 2,
	},
})

-- Initialize the items field as an empty table
container_bracket.items = {}

local kanji_numbers = { "㆒", "二", "三", "四", "五", "六", "七", "八", "九", "十" }

for i = 1, 10, 1 do
	local space = sbar.add("space", "space." .. i, {
		position = "left",
		space = i,
		icon = { drawing = false },
		label = {
			font = {
				style = settings.font.style_map["Bold"],
			},
			padding_left = 6,
			padding_right = 6,
			color = colors.grey,
			string = kanji_numbers[i],
		},
		padding_right = 2,
		padding_left = 2,
	})

	table.insert(container_bracket.items, space.name)
	spaces[i] = space


	-- Padding space
	sbar.add("space", "space.padding." .. i, {
		space = i,
		width = settings.group_paddings,
	})

	space:subscribe("space_change", function(env)
		local selected = env.SELECTED == "true"
		space:set({
			label = { string = kanji_numbers[i], color = selected and colors.yellow or colors.dirty_white },

		})
	end)
end

-- Add the container bracket to include all spaces
sbar.add("bracket", container_bracket.items, {
	background = {
		color = colors.bg2,
		border_color = colors.bg1,
		border_width = 2,
		height = 28,
		corner_radius = 9,
	},
})
