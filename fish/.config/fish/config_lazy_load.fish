# Minimal Fish config optimized for fast startup
# Essential sourcing only
source ~/.config/fish/conf.d/variables.fish
source ~/.config/fish/conf.d/exports.fish
source ~/.config/fish/conf.d/paths.fish

# Fast prompt setup
starship init fish | source

# Fast command integrations
set -gx WARP_THEME_DIR "$HOME/.warp/themes"

# Lazy load expensive tools
if status is-interactive
    # Load on first use
    function __load_fnm
        functions -e __load_fnm
        fnm env --use-on-cd | source
    end
    
    function node --wraps node
        __load_fnm
        command node $argv
    end
    
    function npm --wraps npm  
        __load_fnm
        command npm $argv
    end
    
    function __load_zoxide
        functions -e __load_zoxide
        zoxide init fish | source
    end
    
    function z --wraps z
        __load_zoxide
        z $argv
    end
end
