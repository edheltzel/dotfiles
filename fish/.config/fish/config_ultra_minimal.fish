# Ultra-minimal Fish config for maximum speed
# Only load absolute essentials on startup

# Essential variables and paths
set -gx EDITOR zed
set -gx TERMINAL kitty
set -gx WARP_THEME_DIR "$HOME/.warp/themes"

# Essential paths
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path ~/.local/bin

# Fast prompt
starship init fish | source

# Lazy load everything else only when interactive
if status is-interactive
    # Lazy load fnm/node
    function __lazy_fnm
        functions -e __lazy_fnm node npm
        fnm env --use-on-cd | source
    end
    function node; __lazy_fnm; node $argv; end
    function npm; __lazy_fnm; npm $argv; end
    
    # Lazy load zoxide  
    function __lazy_zoxide
        functions -e __lazy_zoxide z
        zoxide init fish | source
    end
    function z; __lazy_zoxide; z $argv; end
    
    # Load aliases and functions on demand
    function __load_full_config
        functions -e __load_full_config
        source ~/.config/fish/conf.d/abbr.fish 2>/dev/null || true
        source ~/.config/fish/functions/_aliases.fish 2>/dev/null || true
    end
    
    # Auto-load full config after first prompt
    function fish_prompt --on-event fish_prompt
        functions -e fish_prompt
        __load_full_config &
        starship init fish | source
    end
end
