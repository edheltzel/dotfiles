require("items.widgets.weather")

-- Check for battery existence before loading battery module
sbar.exec("ioreg -r -c AppleSmartBattery | grep BatteryInstalled", function(battery_info)
    if battery_info and battery_info:match("Yes") then
        require("items.widgets.battery")
    end
end)

require("items.widgets.volume")
require("items.widgets.wifi")
require("items.widgets.cpu")
require("items.widgets.ram")
require("items.widgets.ssd")
