# Fish config — prompt + interactive lazy-loaders
# Paths, exports, variables handled by conf.d/ (loaded before this file)

# Prompt engine (change to swap: "starship" or "oh-my-posh")
set -g FISH_PROMPT starship

if status is-interactive
    # Initialize prompt (once — do NOT reinitialize on events)
    switch $FISH_PROMPT
        case starship
            starship init fish | source
        case oh-my-posh
            oh-my-posh init fish --config ~/.config/starship-ish.omp.json | source
    end

    # Lazy-load FNM/Node — only inits when node/npm/npx first called
    function __lazy_fnm
        functions -e __lazy_fnm node npm npx
        fnm env --use-on-cd | source
    end
    function node; __lazy_fnm; command node $argv; end
    function npm; __lazy_fnm; command npm $argv; end
    function npx; __lazy_fnm; command npx $argv; end

    # Lazy-load rbenv — only inits when ruby/gem/bundle first called
    function __lazy_rbenv
        functions -e __lazy_rbenv ruby gem bundle rake irb
        source (rbenv init -|psub)
    end
    function ruby; __lazy_rbenv; command ruby $argv; end
    function gem; __lazy_rbenv; command gem $argv; end
    function bundle; __lazy_rbenv; command bundle $argv; end
    function rake; __lazy_rbenv; command rake $argv; end
    function irb; __lazy_rbenv; command irb $argv; end
end
