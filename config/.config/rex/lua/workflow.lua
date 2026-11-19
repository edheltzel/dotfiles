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
      rex.session.new_layer({ bounds = { 0.1, 0.1, 0.8, 0.8 }, focus = true, layout = terminal(label, command) })
    end,
  })
end

popup("popup_lazygit", "Lazygit Popup", "lazygit", { "lazygit" })
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

rex.action({
  name = "empryo",
  title = "Open Empryo",
  category = "Workflow",
  run = function(ctx)
    local configHome = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
    local window, err = rex.session.new_window({
      window_label = "🧬 Empryo",
      layout = terminal("🧬 Empryo", { "python3", configHome .. "/rex/empryo.py" }),
    })
    if err ~= nil then
      error(err, 0)
    end
    rex.client.queue("session.select", { session_id = ctx.session_id, window_id = window.window_id })
    return window
  end,
})
