# Custom sourcing of colors, exports, paths, grc, multi-function fish files, etc.
source ~/.config/fish/conf.d/variables.fish
source ~/.config/fish/conf.d/keys.fish
source ~/.config/fish/conf.d/exports.fish
source ~/.config/fish/conf.d/paths.fish
source ~/.config/fish/conf.d/abbr.fish
source ~/.config/fish/conf.d/colors.fish # this could be obsolete by starship & eza

fnm env --use-on-cd | source
# Prompts - Starship & Oh My Posh
starship init fish | source
# oh-my-posh init fish --config ~/.config/default.omp.json | source
