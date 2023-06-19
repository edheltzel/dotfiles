# Custom sourcing of colors, exports, paths, grc, multi-function fish files, etc.
source ~/.config/fish/conf.d/colors.fish
source ~/.config/fish/conf.d/variables.fish
source ~/.config/fish/conf.d/exports.fish
source ~/.config/fish/conf.d/paths.fish
source ~/.config/fish/conf.d/abbr.fish

# Prompt - Starship
starship init fish | source
