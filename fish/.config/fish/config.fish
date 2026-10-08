# Fish config — prompt + interactive lazy-loaders
# Paths, exports, variables handled by conf.d/ (loaded before this file)

# Prompt engine
set -g FISH_PROMPT starship

if status is-interactive
    # Initialize prompt (once — do NOT reinitialize on events)
    switch $FISH_PROMPT
        case starship
            starship init fish | source
    end

    # Lazy-load rbenv — only inits when ruby/gem/bundle first called
    function __lazy_rbenv
        functions -e __lazy_rbenv ruby gem bundle rake irb
        source (rbenv init -|psub)
    end
    function ruby
        __lazy_rbenv
        command ruby $argv
    end
    function gem
        __lazy_rbenv
        command gem $argv
    end
    function bundle
        __lazy_rbenv
        command bundle $argv
    end
    function rake
        __lazy_rbenv
        command rake $argv
    end
    function irb
        __lazy_rbenv
        command irb $argv
    end
end

# pnpm
set -gx PNPM_HOME /Users/ed/Library/pnpm
if not string match -q -- "$PNPM_HOME/bin" $PATH
    set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end

# Hermes Agent — ensure ~/.local/bin is on PATH
fish_add_path "$HOME/.local/bin"

# Added by codebase-memory-mcp install
fish_add_path /Users/ed/.local/bin

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# >>> grok installer >>>
fish_add_path $HOME/.grok/bin
# <<< grok installer <<<

# Added by GitButler installer
but completions fish | source


# Added by Antigravity CLI installer
set -gx PATH "/Users/ed/.local/bin" $PATH

# Empryo
set -gx PATH $HOME/.empryo/bin $PATH

eval (/opt/homebrew/bin/brew shellenv fish)

# Vite+ shims must beat Homebrew's node (brew shellenv above prepends /opt/homebrew/bin)
fish_add_path -gm $HOME/.vite-plus/bin
