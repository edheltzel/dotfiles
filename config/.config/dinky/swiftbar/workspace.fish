#!/opt/homebrew/bin/fish
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideDisableMenu>true</swiftbar.hideDisableMenu>

set ws (/Applications/dinky.app/Contents/MacOS/dinky list-workspaces --focused)
set name (string match -rg "^# ws-name $ws = (.+)" < ~/.config/dinky/dinky.toml)
if test -n "$name"
    echo $name
else
    echo $ws
end
