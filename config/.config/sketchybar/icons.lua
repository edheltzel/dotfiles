local settings = require("settings")

local icons = {
    sf_symbols = {
        plus = "􀅼",
        loading = "􀖇",
        apple = "􀣺", --󱚞
        gear = "􀍟",
        cpu = "󰒆",
        clipboard = "􀉄",

        space_indicator = {
            on = "󰄯",
            off = "󰄰",
        },

        switch = {
            on = "􁏮",
            off = "􁏯",
        },
        volume = {
            _100 = "􀊩",
            _66 = "􀊧",
            _33 = "􀊥",
            _10 = "􀊡",
            _0 = "􀊣",
        },
        battery = {
            _100 = "􀛨",
            _75 = "􀺸",
            _50 = "􀺶",
            _25 = "􀛩",
            _0 = "􀛪",
            charging = "􀢋"
        },
        wifi = {
            upload = "􀄨",
            download = "􀄩",
            connected = "􀙇",
            disconnected = "􀙈",
            router = "􁓤",
            vpn = "󰌾",
            test = "",
        },
        media = {
            back = "􀊊",
            forward = "􀊌",
            play_pause = "􀊈",
        },
        ramicons = {
            swap = "󰁄",
            ram = "󰍛",
        }
    },
}

if not (settings.icons == "NerdFont") then
    return icons.sf_symbols
else
    return icons.nerdfont
end
