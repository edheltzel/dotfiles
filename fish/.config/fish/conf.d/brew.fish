# Fast brew detection - check most likely path first
if test -f /opt/homebrew/bin/brew
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin
else if test -f /usr/local/bin/brew
    fish_add_path /usr/local/bin
    fish_add_path /usr/local/sbin
end
