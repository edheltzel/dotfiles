-- Git status signs. Colors live in each flavor's [git] section (flavors/*.yazi),
-- so they track the active theme. Signs use the plugin's default Nerd Font glyphs.
require("git"):setup({ order = 1500 })

-- Override btime
function Linemode:btime()
  local time = math.floor(self._file.cha.btime or 0)
  return time == 0 and "" or os.date("%Y-%m-%d %H:%M", time)
end
