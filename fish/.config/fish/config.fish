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
