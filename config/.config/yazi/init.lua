-- Git status colors (Tokyo Night palette)
-- Signs use plugin defaults (Nerd Font glyphs)
th.git = th.git or {}
th.git.modified  = ui.Style():fg("#7aa2f7"):bold()   -- blue
th.git.added     = ui.Style():fg("#9ece6a"):bold()   -- green
th.git.untracked = ui.Style():fg("#ff9e64"):bold()   -- orange
th.git.deleted   = ui.Style():fg("#f7768e"):bold()   -- red
th.git.ignored   = ui.Style():fg("#414868")           -- muted gray
th.git.updated   = ui.Style():fg("#e0af68"):bold()   -- yellow (conflict)

require("git"):setup { order = 1500 }
