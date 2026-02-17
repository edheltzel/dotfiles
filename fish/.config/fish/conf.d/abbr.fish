# cspell: disable
if status is-interactive
    # Window
    abbr --add cw center_window
    abbr --add cl clear

    # AI Agents + Models
    abbr --add ccu 'bunx ccusage'
    abbr --add ccc 'claude converse --dangerously-skip-permissions'
    abbr --add cc 'claude --dangerously-skip-permissions'
    abbr --add ccd 'claude --dangerously-skip-permissions'
    abbr --add os openspec
    abbr --add oc opencode
    abbr --add occ 'opencode --continue'
    abbr --add ocp 'opencode --agent plan'
    abbr --add gg 'gemini --yolo'
    abbr --add ag antigravity
    abbr --add ma maestro-cli
    
    # Directories
    # abbr --add cls '$DROPBOX/Clients'
    abbr --add config '~/.config/'
    abbr --add local '~/.local/'
    abbr --add wall '~/.wallpapers/'
    abbr --add dls '~/Downloads/'
    abbr --add goo 'cd ~/.go/'

    # Editors/Terminals
    abbr --add ght wezterm
    abbr --add wez wezterm
    abbr --add kit kitten
    # vscode
    abbr --add co code
    abbr --add con 'code -n .'
    abbr --add coo 'code -r .'
    # zed
    abbr --add ze zed
    abbr --add zz 'zed -n .'
    # neovim 
    abbr --add vim nvim
    abbr --add nv nvim
    abbr --add v nvim
    abbr --add nn 'nvim .'
    abbr --add vv 'nvim .'

    # Utilities
    abbr --add atm fastfetch
    abbr --add cat 'bat -pp'
    abbr --add clean mac-cleaner-cli
    abbr --add link 'ln -s'
    abbr --add symlink 'ln -s'

    # Git
    abbr --add lg lazygit
    abbr --add ghw 'gh repo view --web'
    abbr --add ghpr 'gh pr create -a "@me" --fill'
    abbr --add ghm --set-cursor 'gh pr merge % --merge'
    abbr --add ghr --set-cursor 'gh release create v% --generate-notes --latest'

    # Package Managers 
    abbr --add bi 'brew install '
    abbr --add binfo 'brew info'
    abbr --add brews 'brew list'
    abbr --add casks 'brew list --cask'
    abbr --add bic --set-cursor 'brew install % --cask'
    abbr --add cargos 'cargo install --list'
    abbr --add eval 'eval ssh-agent -s; and ssh-add --apple-use-keychain ~/.ssh/id_ed25519'
    abbr --add gems 'gem list'
    abbr --add npms 'npm list -g --depth=0'
    abbr --add pns 'pnpm list -g'
    abbr --add pnpms 'pnpm list -g'
    abbr --add buns 'bun pm ls -g'
    abbr --add siz 'du -khsc'
    abbr --add sp 'speedtest -u Gbps'
    abbr --add spp 'speedtest -u Gbps'
    abbr --add newcode 'npx --package yo --package generator-code -- yo code'
    abbr --add omp oh-my-posh
    abbr --add yy yazi
    abbr --add wrg wrangler
    abbr --add upp topgrade
    abbr --add psrv 'php -S localhost:8888'
    abbr --add zip 'ouch compress -q'
    abbr --add unzip ouch decompress
    abbr --add lzip ouch list
    # Tmux
    abbr --add ax 'tmux at -t base'
    abbr --add amux 'tmux at -t base'
    abbr --add nx 'tmux new -s "base"'
    abbr --add kx 'tmux kill-session -t'
    abbr --add tkill 'tmux kill-session -t'
    abbr --add nmux 'tmux new -s "base"'

    # Migrated from aliases (simple 1:1 mappings)
    abbr --add md 'mkdir -p'
    abbr --add cwd pwd
    abbr --add dev 'cd ~/Developer'
    abbr --add work 'cd ~/Developer'
    abbr --add sites 'cd ~/Sites'
    abbr --add dots 'cd ~/.dotfiles'
    abbr --add neoed 'cd ~/.dotfiles/neoed/.config/nvim'
    abbr --add neo 'cd ~/.dotfiles/neoed/.config/nvim'
    abbr --add e '$EDITOR'
    abbr --add o open
    abbr --add oo 'open .'
    abbr --add oa 'open -a'
    abbr --add del trash
    abbr --add sdel 'sudo rm -rf'
    abbr --add serve miniserve
    abbr --add du dua
    abbr --add wget 'wget -c'
    abbr --add whois 'grc whois'
    abbr --add hostfile 'sudo nvim /etc/hosts'
    abbr --add editssh 'nvim ~/.ssh'
    abbr --add dk docker
    abbr --add dc 'docker compose'
    abbr --add pn pnpm
    abbr --add px 'pnpm dlx'

end
