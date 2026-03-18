# cspell: disable
# Abbreviations via zsh-abbr (≈ abbr.fish)
# zsh-abbr persists abbreviations — this file defines them on first load.
# Uses `abbr -S` for session abbreviations (non-persistent, defined every load)
# or just `abbr` for user abbreviations (persistent, stored in zsh-abbr's data file).
#
# We use session abbreviations here since we manage them declaratively in dotfiles.

# Window
abbr -S cw='center_window' 2>/dev/null
abbr -S cl='clear' 2>/dev/null

# AI Agents + Models
abbr -S ccc='claude converse --dangerously-skip-permissions' 2>/dev/null
abbr -S cc='claude --dangerously-skip-permissions' 2>/dev/null
abbr -S ccd='claude --dangerously-skip-permissions' 2>/dev/null
abbr -S os='openspec' 2>/dev/null
abbr -S oc='opencode' 2>/dev/null
abbr -S occ='opencode --continue' 2>/dev/null
abbr -S ocp='opencode --agent plan' 2>/dev/null
abbr -S gg='gemini --yolo' 2>/dev/null
abbr -S ag='antigravity' 2>/dev/null
abbr -S ma='maestro-cli' 2>/dev/null
abbr -S sa='sidecar' 2>/dev/null

# Directories
abbr -S config='~/.config/' 2>/dev/null
abbr -S local='~/.local/' 2>/dev/null
abbr -S wall='~/.wallpapers/' 2>/dev/null
abbr -S dls='~/Downloads/' 2>/dev/null
abbr -S goo='cd ~/.go/' 2>/dev/null

# Editors/Terminals
abbr -S gho='ghostty' 2>/dev/null
abbr -S wez='wezterm' 2>/dev/null
abbr -S kit='kitten' 2>/dev/null
abbr -S zela='zellij a' 2>/dev/null
abbr -S zels='zellij -s' 2>/dev/null
abbr -S zelk='zellij k' 2>/dev/null
abbr -S zelka='zellij ka' 2>/dev/null
abbr -S zeld='zellij d' 2>/dev/null
abbr -S zelda='zellij da' 2>/dev/null
abbr -S zell='zellij ls' 2>/dev/null
abbr -S muxa='tmux attach' 2>/dev/null
abbr -S muxaa='tmux attach -t' 2>/dev/null
abbr -S muxs='tmux new-session -s' 2>/dev/null
abbr -S muxk='tmux kill-session -t' 2>/dev/null
abbr -S muxka='tmux kill-server' 2>/dev/null
abbr -S muxl='tmux list-sessions' 2>/dev/null
abbr -S muxd='tmux detach' 2>/dev/null
# vscode
abbr -S co='code' 2>/dev/null
abbr -S con='code -n .' 2>/dev/null
abbr -S coo='code -r .' 2>/dev/null
# zed
abbr -S ze='zed' 2>/dev/null
abbr -S zz='zed -n .' 2>/dev/null
# neovim
abbr -S vim='nvim' 2>/dev/null
abbr -S nv='nvim' 2>/dev/null
abbr -S v='nvim' 2>/dev/null
abbr -S nn='nvim .' 2>/dev/null
abbr -S vv='nvim .' 2>/dev/null

# Utilities
abbr -S atm='fastfetch' 2>/dev/null
abbr -S cat='bat -pp' 2>/dev/null
abbr -S clean='mac-cleaner-cli' 2>/dev/null
abbr -S link='ln -s' 2>/dev/null
abbr -S symlink='ln -s' 2>/dev/null

# Git
abbr -S lg='lazygit' 2>/dev/null
abbr -S ghw='gh repo view --web' 2>/dev/null
abbr -S ghpr='gh pr create -a "@me" --fill' 2>/dev/null
abbr -S ghm='gh pr merge --merge' 2>/dev/null
abbr -S ghr='gh release create --generate-notes --latest' 2>/dev/null

# Package Managers
abbr -S bi='brew install' 2>/dev/null
abbr -S binfo='brew info' 2>/dev/null
abbr -S brews='brew list' 2>/dev/null
abbr -S casks='brew list --cask' 2>/dev/null
abbr -S bic='brew install --cask' 2>/dev/null
abbr -S cargos='cargo install --list' 2>/dev/null
abbr -S eva='eval "$(ssh-agent -s)" && ssh-add --apple-use-keychain ~/.ssh/id_ed25519' 2>/dev/null
abbr -S gems='gem list' 2>/dev/null
abbr -S npms='npm list -g --depth=0' 2>/dev/null
abbr -S pns='pnpm list -g' 2>/dev/null
abbr -S pnpms='pnpm list -g' 2>/dev/null
abbr -S buns='bun pm ls -g' 2>/dev/null
abbr -S siz='du -khsc' 2>/dev/null
abbr -S sp='speedtest -u Gbps' 2>/dev/null
abbr -S spp='speedtest -u Gbps' 2>/dev/null
abbr -S newcode='bunx --package yo --package generator-code -- yo code' 2>/dev/null
abbr -S yy='yazi' 2>/dev/null
abbr -S wr='wrangler' 2>/dev/null
abbr -S upp='topgrade' 2>/dev/null
abbr -S phps='php -S localhost:8888' 2>/dev/null
abbr -S zip='ouch compress -q' 2>/dev/null
abbr -S unzip='ouch decompress' 2>/dev/null
abbr -S lzip='ouch list' 2>/dev/null

# Migrated from aliases (simple 1:1 mappings)
abbr -S md='mkdir -p' 2>/dev/null
abbr -S cwd='pwd' 2>/dev/null
abbr -S yp='pwd | pbcopy' 2>/dev/null
abbr -S dev='cd ~/Developer' 2>/dev/null
abbr -S work='cd ~/Developer' 2>/dev/null
abbr -S sites='cd ~/Sites' 2>/dev/null
abbr -S dots='cd ~/.dotfiles' 2>/dev/null
abbr -S neoed='cd ~/.dotfiles/neoed/.config/nvim' 2>/dev/null
abbr -S neo='cd ~/.dotfiles/neoed/.config/nvim' 2>/dev/null
abbr -S e='$EDITOR' 2>/dev/null
abbr -S o='open' 2>/dev/null
abbr -S oo='open .' 2>/dev/null
abbr -S oa='open -a' 2>/dev/null
abbr -S del='trash' 2>/dev/null
abbr -S sdel='sudo rm -rf' 2>/dev/null
abbr -S serve='miniserve' 2>/dev/null
abbr -S du='dua' 2>/dev/null
abbr -S wget='wget -c' 2>/dev/null
abbr -S whois='grc whois' 2>/dev/null
abbr -S hostfile='sudo nvim /etc/hosts' 2>/dev/null
abbr -S editssh='nvim ~/.ssh' 2>/dev/null
abbr -S dk='docker' 2>/dev/null
abbr -S dc='docker compose' 2>/dev/null
abbr -S pn='pnpm' 2>/dev/null
abbr -S px='pnpm dlx' 2>/dev/null
