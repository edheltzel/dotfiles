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
	padding_left = 10,
	padding_right = 10,
})

-- Initialize the items field as an empty table
container_bracket.items = {}

for i = 1, 10, 1 do
	local space = sbar.add("space", "space." .. i, {
		position = "left",
		space = i,
		icon = {
			font = { family = settings.font.numbers },
			padding_left = 8,
			padding_right = 0,
			color = colors.grey,
			string = icons.space_indicator.off,
		},
		label = {
			padding_right = 15,
			padding_left = 8,
			color = colors.grey,
			highlight_color = colors.white,
			font = "sketchybar-app-font:Regular:16.0",
			y_offset = -1,
		},
		padding_right = 2,
		padding_left = 2,
		background = {
			color = colors.bg2,
			border_color = colors.bg1,
			border_width = 2,
		},
		popup = { background = { border_width = 5, border_color = colors.black } }
	})

	table.insert(container_bracket.items, space.name)
	spaces[i] = space

	-- Single item bracket for space items to achieve double border on highlight
	local space_bracket = sbar.add("bracket", { space.name }, {
		background = {
			color = colors.transparent,
			border_color = colors.bg2,
			height = 26,
			border_width = 2
		}
	})

	-- Padding space
	sbar.add("space", "space.padding." .. i, {
		space = i,
		width = settings.group_paddings,
	})

	local space_popup = sbar.add("item", {
		position = "popup." .. space.name,
		padding_left = 5,
		padding_right = 0,
		background = {
			drawing = true,
			image = {
				corner_radius = 9,
				scale = 0.2
			}
		}
	})

	space:subscribe("space_change", function(env)
		local selected = env.SELECTED == "true"
		space:set({
			icon = { string = selected and icons.space_indicator.on or icons.space_indicator.off, color = selected and colors.red or colors.dirty_white },
			label = { highlight = selected },
			background = { border_color = selected and colors.blue or colors.bg2 },
		})
	end)


	space:subscribe("mouse.clicked", function(env)
		if env.BUTTON == "other" then
			space_popup:set({ background = { image = "space." .. env.SID } })
			space:set({ popup = { drawing = "toggle" } })
		else
			local op = (env.BUTTON == "right") and "--destroy" or "--focus"
			sbar.exec("yabai -m space " .. op .. " " .. env.SID)
		end
	end)

	space:subscribe("mouse.exited", function(_)
		space:set({ popup = { drawing = false } })
	end)
end

-- Add the container bracket to include all spaces
sbar.add("bracket", container_bracket.items, {
	background = {
		color = colors.bg2,
		border_color = colors.bg1,
		border_width = 2,
		height = 28,
	},
})

local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

space_window_observer:subscribe("space_windows_change", "front_app_switched", function(env)
	local icon_line = ""
	local no_app = true
	for app, count in pairs(env.INFO.apps) do
		no_app = false
		local lookup = app_icons[app]
		local icon = ((lookup == nil) and app_icons["default"] or lookup)
		icon_line = icon_line .. icon
	end

	if (no_app) then
		icon_line = " 􀍠"
	end
	sbar.animate("tanh", 10, function()
		spaces[env.INFO.space]:set({ label = icon_line })
	end)
end)



-- Uncomment and complete the following block if needed for "swap_menus_and_spaces" functionality
--[[
local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = 0,
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
    string = "Spaces",
    color = colors.bg1,
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
  }
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on
  })
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.bg1 },
      label = { width = "dynamic" }
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.grey },
      label = { width = 0, }
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
]]--
