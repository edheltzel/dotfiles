# Custom sourcing of colors, exports, paths, grc, multi-function fish files, etc.
source ~/.config/fish/conf.d/colors.fish
source ~/.config/fish/conf.d/exports.fish
source ~/.config/fish/conf.d/paths.fish

# Start Starship Prompt
starship init fish | source

# enable Vi mode
fish_vi_key_bindings
