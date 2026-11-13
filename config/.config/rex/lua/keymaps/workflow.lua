-- Workflow popups on both leaders: cmd+, (herdr-app) and alt+, (herdr TUI)
for _, leader in ipairs({ "cmd+,", "alt+," }) do
  rex.bind(leader .. ">shift+b", "popup_but")
  rex.bind(leader .. ">shift+d", "popup_dash")
  rex.bind(leader .. ">shift+f", "popup_yazi")
  rex.bind(leader .. ">shift+t", "popup_tuxedo")
  rex.bind(leader .. ">shift+s", "popup_shell")
  rex.bind(leader .. ">shift+v", "split_nvim")
end
