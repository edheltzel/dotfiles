# Custom sourcing of colors, exports, paths, grc, multi-function fish files, etc.
source ~/.config/fish/conf.d/colors.fish # this could be obsoleted by starship & eza
source ~/.config/fish/conf.d/variables.fish
source ~/.config/fish/conf.d/exports.fish
source ~/.config/fish/conf.d/paths.fish
source ~/.config/fish/conf.d/abbr.fish

# Prompt - Starship or Oh My Posh
starship init fish | source
# oh-my-posh init fish --config 'https://raw.githubusercontent.com/JanDeDobbeleer/dotfiles/main/dot_jandedobbeleer.omp.json' | source

# tabtab source for packages – to uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true
