local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	topmost = "window",
	height = 35,
	color = colors.bar.bg,
	padding_right = 2,
	padding_left = 2,
	margin = 10,
	corner_radius = 12,
	y_offset = 2,
	border_color = colors.transparent,
	border_width = 2,
	blur_radius = 10,
})
