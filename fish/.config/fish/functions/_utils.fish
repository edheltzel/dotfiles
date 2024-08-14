# Utilities for checking terminal color support, and printing color pallete
function colormap
    $HOME/.config/fish/utils/color-map.sh
end

# Matrix-style screensaver for your terminal - for fun
function matrix
    $HOME/.config/fish/utils/matrix.sh
end

# list all bat themes with a preview
function batthemes
    bat --list-themes | fzf --preview="bat --theme={} --color=always Makefile" | pbcopy
end
