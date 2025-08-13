# Utilities for checking terminal color support, and printing color pallete
function colormap
    $HOME/.config/fish/utils/color-map.sh
end

# Matrix-style screensaver for your terminal - for fun
function matrix
    $HOME/.config/fish/utils/matrix.sh
end

# Terminal Doom
function doom --description 'Terminal Doom'
    cd $HOME/Developer/games/terminal-doom; and zig-out/bin/terminal-doom
end
