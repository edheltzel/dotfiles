-- Workflow tools, matching the herdr popups (herdr-app keys.json, herdr config.toml)
local function focused_cwd()
  local ok, proc = pcall(rex.block.call, "com.superlogical.terminal", "process")
  if ok and type(proc) == "table" and proc.foreground then
    return proc.foreground.cwd
  end
end

local function terminal(label, command)
  local options = { cwd = focused_cwd() }
  if command then
    options.command = command
    options.interactive = true
  end
  return { block = { flavor = "com.superlogical.terminal.shell", label = label, options = options } }
end

local function popup(name, title, label, command)
  rex.action({
    name = name,
    title = title,
    category = "Workflow",
    run = function()
      rex.session.new_layer({ bounds = { 0.05, 0.05, 0.9, 0.9 }, focus = true, layout = terminal(label, command) })
    end,
  })
end

popup("popup_but", "GitButler Popup", "but", { "but", "tui" })
popup("popup_dash", "gh dash Popup", "dash", { "gh", "dash" })
popup("popup_yazi", "Yazi Popup", "yazi", { "yazi" })
popup("popup_tuxedo", "Tuxedo Popup", "tuxedo", { "tuxedo" })
popup("popup_shell", "Scratch Shell Popup", "scratch", nil)

rex.action({
  name = "split_nvim",
  title = "Neovim Split",
  category = "Workflow",
  run = function(ctx)
    rex.session.new_split({
      anchor_id = ctx.block_id,
      direction = "horizontal",
      side = "after",
      focus = true,
      layout = terminal("nvim", { "nvim" }),
    })
  end,
})

for _, leader in ipairs({ "cmd+,", "alt+," }) do
  rex.bind(leader .. ">shift+b", "popup_but")
  rex.bind(leader .. ">shift+d", "popup_dash")
  rex.bind(leader .. ">shift+f", "popup_yazi")
  rex.bind(leader .. ">shift+t", "popup_tuxedo")
  rex.bind(leader .. ">shift+s", "popup_shell")
  rex.bind(leader .. ">shift+v", "split_nvim")
end

-- tmux-style prefix, ctrl+space (Empryo owns ctrl+b and alt+h)
rex.bind("ctrl+space>ctrl+space", "pane.send_key", { key = "ctrl+space" })
rex.bind("ctrl+space>k", "pane.send_key", { key = "ctrl+l" })
rex.bind("ctrl+space>\\", "pane.split", { direction = "right" })
rex.bind("ctrl+space>-", "pane.split", { direction = "down" })
rex.bind("ctrl+space>h", "pane.split", { direction = "left" })
rex.bind("ctrl+space>j", "pane.split", { direction = "down" })
rex.bind("ctrl+space>l", "pane.split", { direction = "right" })
rex.bind("ctrl+space>u", "pane.split", { direction = "up" })
rex.bind("ctrl+space>x", "pane.close")
rex.bind("ctrl+space>z", "pane.zoom")
rex.bind("ctrl+space>=", "pane.zoom")

rex.mode("repeat", { exclusive = true })
rex.bind("ctrl+space>ctrl+r", "client.mode.enter", { name = "repeat" })
rex.bind("repeat/enter", "client.mode.exit")
rex.bind("repeat/escape", "client.mode.exit")

rex.bind("ctrl+space>left", "pane.focus", { direction = "left" })
rex.bind("repeat/left", "pane.focus", { direction = "left" })
rex.bind("ctrl+space>down", "pane.focus", { direction = "down" })
rex.bind("repeat/down", "pane.focus", { direction = "down" })
rex.bind("ctrl+space>up", "pane.focus", { direction = "up" })
rex.bind("repeat/up", "pane.focus", { direction = "up" })
rex.bind("ctrl+space>right", "pane.focus", { direction = "right" })
rex.bind("repeat/right", "pane.focus", { direction = "right" })
rex.bind("ctrl+space>shift+.", "pane.move", { direction = "down" })
rex.bind("ctrl+space>shift+,", "pane.move", { direction = "up" })
rex.bind("ctrl+space>n", "client.tab.new")
rex.bind("ctrl+space>t", "client.tab.new")
rex.bind("ctrl+space>shift+t", "session.switch")
rex.bind("ctrl+space>ctrl+h", "client.tab.previous")
rex.bind("repeat/ctrl+h", "client.tab.previous")
rex.bind("ctrl+space>ctrl+l", "client.tab.next")
rex.bind("repeat/ctrl+l", "client.tab.next")
rex.bind("ctrl+space>1", "client.tab.goto", { index = 1 })
rex.bind("ctrl+space>2", "client.tab.goto", { index = 2 })
rex.bind("ctrl+space>3", "client.tab.goto", { index = 3 })
rex.bind("ctrl+space>4", "client.tab.goto", { index = 4 })
rex.bind("ctrl+space>5", "client.tab.goto", { index = 5 })
rex.bind("ctrl+space>6", "client.tab.goto", { index = 6 })
rex.bind("ctrl+space>7", "client.tab.goto", { index = 7 })
rex.bind("ctrl+space>8", "client.tab.goto", { index = 8 })
rex.bind("ctrl+space>9", "client.tab.goto", { index = 9 })
rex.bind("ctrl+space>s", "session.switch")
rex.bind("ctrl+space>w", "session.switch")
rex.bind("ctrl+space>e", "client.tab.rename")
rex.bind("ctrl+space>shift+e", "session.rename")

rex.mode("resize_pane", { exclusive = true })
rex.bind("resize_pane/escape", "client.mode.exit")
rex.bind("ctrl+space>r", "client.mode.enter", { name = "resize_pane" })
rex.bind("resize_pane/h", "pane.resize", { amount = 2, direction = "left" })
rex.bind("resize_pane/j", "pane.resize", { amount = 2, direction = "down" })
rex.bind("resize_pane/k", "pane.resize", { amount = 2, direction = "up" })
rex.bind("resize_pane/l", "pane.resize", { amount = 2, direction = "right" })
rex.bind("resize_pane/shift+h", "pane.resize", { amount = 10, direction = "left" })
rex.bind("resize_pane/shift+j", "pane.resize", { amount = 10, direction = "down" })
rex.bind("resize_pane/shift+k", "pane.resize", { amount = 10, direction = "up" })
rex.bind("resize_pane/shift+l", "pane.resize", { amount = 10, direction = "right" })
rex.bind("resize_pane/enter", "client.mode.exit")

rex.mode("move_tab", { exclusive = true })
rex.bind("move_tab/escape", "client.mode.exit")
rex.bind("ctrl+space>m", "client.mode.enter", { name = "move_tab" })
rex.bind("move_tab/enter", "client.mode.exit")

-- Herdr (~/.config/herdr/config.toml), prefix alt+,
rex.bind("alt+,>alt+,", "pane.send_key", { key = "alt+," })
rex.bind("alt+,>g", "session.switch")
rex.bind("alt+,>shift+w", "session.close")
rex.bind("alt+,>shift+e", "session.rename")
rex.bind("alt+,>e", "client.tab.rename")
rex.bind("alt+,>p", "pane.rename")
rex.bind("alt+,>n", "session.new")
rex.bind("alt+,>t", "client.tab.new")
rex.bind("alt+,>\\", "pane.split", { direction = "right" })
rex.bind("alt+i", "session.next")
rex.bind("alt+u", "session.previous")
rex.bind("alt+shift+l", "client.tab.next")
rex.bind("alt+shift+h", "client.tab.previous")
rex.bind("alt+1", "client.tab.goto", { index = 1 })
rex.bind("alt+2", "client.tab.goto", { index = 2 })
rex.bind("alt+3", "client.tab.goto", { index = 3 })
rex.bind("alt+4", "client.tab.goto", { index = 4 })
rex.bind("alt+5", "client.tab.goto", { index = 5 })
rex.bind("alt+6", "client.tab.goto", { index = 6 })
rex.bind("alt+7", "client.tab.goto", { index = 7 })
rex.bind("alt+8", "client.tab.goto", { index = 8 })
rex.bind("alt+9", "client.tab.goto", { index = 9 })
rex.bind("alt+]", "pane.focus_next")
rex.bind("alt+[", "pane.focus_previous")

-- Ghostty (~/.config/ghostty/config)
rex.bind("ctrl+cmd+,", "client.config.reload")
rex.bind("ctrl+alt+cmd+=", "pane.close")
rex.bind("cmd+,>k", "com.superlogical.terminal.clear")
rex.bind("cmd+,>n", "client.window.new")
rex.bind("cmd+,>x", "pane.close")
rex.bind("cmd+,>h", "pane.split", { direction = "left" })
rex.bind("cmd+,>l", "pane.split", { direction = "right" })
rex.bind("cmd+,>\\", "pane.split", { direction = "right" })
rex.bind("cmd+,>-", "pane.split", { direction = "down" })
rex.bind("cmd+,>j", "pane.split", { direction = "down" })
rex.bind("cmd+,>u", "pane.split", { direction = "up" })
rex.bind("cmd+,>z", "pane.zoom")
rex.bind("cmd+,>=", "pane.balance")
rex.bind("ctrl+alt+cmd+\\", "pane.split", { direction = "right" })
rex.bind("ctrl+alt+cmd+-", "pane.split", { direction = "down" })
rex.bind("ctrl+alt+cmd+z", "pane.zoom")
rex.bind("cmd+,>t", "client.tab.new")
rex.bind("cmd+,>1", "client.tab.goto", { index = 1 })
rex.bind("cmd+,>2", "client.tab.goto", { index = 2 })
rex.bind("cmd+,>3", "client.tab.goto", { index = 3 })
rex.bind("cmd+,>4", "client.tab.goto", { index = 4 })
rex.bind("cmd+,>5", "client.tab.goto", { index = 5 })
rex.bind("cmd+,>6", "client.tab.goto", { index = 6 })
rex.bind("cmd+,>7", "client.tab.goto", { index = 7 })
rex.bind("cmd+,>8", "client.tab.goto", { index = 8 })
rex.bind("ctrl+alt+shift+[", "client.tab.move", { direction = "backward" })
rex.bind("ctrl+alt+shift+]", "client.tab.move", { direction = "forward" })

-- kitty (~/.config/kitty/keymaps.conf), kitty_mod = ctrl+cmd
rex.bind("cmd+right", "pane.send_key", { key = "ctrl+e" })
rex.bind("cmd+left", "pane.send_key", { key = "ctrl+a" })
rex.bind("cmd+backspace", "pane.send_key", { key = "ctrl+u" })
rex.bind("cmd+z", "pane.send_key", { key = "ctrl+/" })
rex.bind("cmd+w", "client.tab.close")
rex.bind("cmd+9", "client.tab.goto", { index = 9 })
rex.bind("ctrl+cmd+right", "pane.resize", { direction = "left" })
rex.bind("ctrl+cmd+left", "pane.resize", { direction = "right" })
rex.bind("ctrl+cmd+up", "pane.resize", { direction = "up" })
rex.bind("ctrl+cmd+down", "pane.resize", { amount = 3, direction = "down" })
rex.bind("shift+cmd+-", "client.font.decrease")
rex.bind("shift+cmd+0", "client.font.reset")
rex.bind("shift+cmd+f", "client.window.fullscreen.toggle")
rex.bind("ctrl+cmd+h", "client.tab.previous")
rex.bind("ctrl+cmd+]", "client.tab.move", { direction = "backward" })
rex.bind("ctrl+cmd+[", "client.tab.move", { direction = "forward" })
rex.bind("ctrl+cmd+\\", "pane.split", { direction = "right" })
rex.bind("ctrl+cmd+-", "pane.split", { direction = "down" })
rex.bind("ctrl+cmd+z", "pane.zoom")
rex.bind("ctrl+cmd+=", "pane.close")
rex.bind("cmd+,>f", "client.find.open")
rex.bind("cmd+,>g", "session.switch")
rex.bind("cmd+,>9", "client.tab.goto", { index = 9 })
rex.bind("cmd+,>,", "client.tab.move", { direction = "backward" })
rex.bind("cmd+,>.", "client.tab.move", { direction = "forward" })
