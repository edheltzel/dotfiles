local settings = require("settings")

-- Equivalent to the --bar domain
sbar.bar({
    topmost = "window",
    height = settings.bar.height,
    color = settings.bar.background,
    padding_right = settings.bar.padding.x,
    padding_left = settings.bar.padding.x,
    -- padding_top = settings.bar.padding.y,
    -- padding_bottom = settings.bar.padding.y,
    sticky = true,
    position = "bottom",
    shadow = false
})
