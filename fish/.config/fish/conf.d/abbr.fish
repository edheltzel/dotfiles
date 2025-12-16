# cspell: disable
if status is-interactive
    # Window
    abbr --add cw center_window
    abbr --add cl clear

    # AI Agents + Models
    abbr --add ccu 'bunx ccusage'
    abbr --add cc 'claude --dangerously-skip-permissions'
    abbr --add ccd 'claude --dangerously-skip-permissions'
    abbr --add os openspec
    abbr --add oc opencode
    abbr --add gg gemini

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
    abbr --add cmy 'bunx mac-cleaner-cli'
    abbr --add clean 'bunx mac-cleaner-cli'

    # Package Managers 
    abbr --add bi 'brew install '
    abbr --add binfo 'brew info'
    abbr --add brews 'brew list'
    abbr --add casks 'brew list --cask'
    abbr --add bic --set-cursor 'brew install % --cask'
    abbr --add cargos 'cargo install --list'
    abbr --add lg lazygit
    abbr --add eval 'eval ssh-agent -s; and ssh-add --apple-use-keychain ~/.ssh/id_ed25519'
    abbr --add gems 'gem list'
    abbr --add ghw 'gh repo view --web'
    abbr --add ghpr 'gh pr create -a "@me" --fill'
    abbr --add ghm --set-cursor 'gh pr merge % --merge'
    abbr --add ghr --set-cursor 'gh release create v% --generate-notes --latest'
    abbr --add npms 'npm list -g --depth=0'
    abbr --add pns 'pnpm list -g'
    abbr --add pnpms 'pnpm list -g'
    abbr --add buns 'bun pm ls -g'
    abbr --add siz 'du -khsc'
    abbr --add sp 'speedtest -u Gbps'
    abbr --add spp 'speedtest -u Gbps'
    abbr --add grabit 'wget -mkEpnp url_here'
    abbr --add link 'ln -s'
    abbr --add symlink 'ln -s'
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

end
