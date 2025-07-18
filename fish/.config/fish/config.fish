# Custom sourcing of colors, exports, paths, grc, multi-function fish files, etc.
source ~/.config/fish/conf.d/variables.fish
source ~/.config/fish/conf.d/keys.fish
source ~/.config/fish/conf.d/exports.fish
source ~/.config/fish/conf.d/paths.fish
source ~/.config/fish/conf.d/abbr.fish
source ~/.config/fish/conf.d/colors.fish # this could be obsolete by starship & eza

fnm env --use-on-cd | source

### start Prompt ###
# Starship Prompt
function starship_transient_prompt_func
    starship module character
end
starship init fish | source
enable_transience

# OH My Posh Prompt
# oh-my-posh init fish --config ~/.config/starship-ish.omp.json | source

# Added by Windsurf
fish_add_path /Users/ed/.codeium/windsurf/bin

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

string match -q "$TERM_PROGRAM" "kiro" and . (kiro --locate-shell-integration-path fish)
