# cspell: disable
if status is-interactive
    abbr --add atm fastfetch
    abbr --add bi 'brew install '
    abbr --add binfo 'brew info'
    abbr --add brews 'brew list'
    abbr --add casks 'brew list --cask'
    abbr --add bic --set-cursor 'brew install % --cask'
    abbr --add cl clear
    # abbr --add cls '$DROPBOX/Clients'
    # Editors & Terminals
    abbr --add ee 'e -r .'
    abbr --add en 'e -n .'
    abbr --add co code
    abbr --add con 'code -n .'
    abbr --add coo 'code -r .'
    abbr --add ws windsurf
    abbr --add wsn 'windsurf -n .'
    abbr --add wso 'windsurf -r .'
    abbr --add vim nvim
    abbr --add wez wezterm

    abbr --add cargos 'cargo install --list'
    abbr --add config '~/.config/'
    abbr --add local '~/.local/'
    abbr --add lg lazygit
    abbr --add gg lazygit
    abbr --add dls '~/Downloads/'
    abbr --add eva 'eval ssh-agent -s; and ssh-add --apple-use-keychain ~/.ssh/id_ed25519'
    abbr --add gems 'gem list'
    abbr --add ghw 'gh repo view --web'
    abbr --add ghpr 'gh pr create -a "@me" --fill'
    abbr --add ghm --set-cursor 'gh pr merge % --merge'
    abbr --add ghr --set-cursor 'gh release create v% --generate-notes --latest'
    abbr --add ghce 'gh copilot explain %'
    abbr --add ghcs 'gh copilot suggest'
    abbr --add ghcc 'gh copilot config'
    abbr --add ghca 'gh copilot alias'
    abbr --add goo 'cd ~/.go/'
    abbr --add npms 'npm list -g --depth=0'
    abbr --add pns 'pnpm list -g'
    abbr --add pnpms 'pnpm list -g'
    abbr --add buns 'bun pm ls -g'
    abbr --add siz 'du -khsc'
    abbr --add sp speedtest
    abbr --add spp speedtest
    abbr --add grabit 'wget -mkEpnp url_here'
    abbr --add link 'ln -s'
    abbr --add symlink 'ln -s'
    abbr --add wrg wrangler
    abbr --add usebash 'chsh -s $(which bash)'
    abbr --add usezsh 'chsh -s $(which zsh)'
    abbr --add upp topgrade
    abbr --add psrv 'php -S localhost:8888'
    abbr --add omp oh-my-posh
    abbr --add newcode 'npx --package yo --package generator-code -- yo code'
    abbr --add confi confetti
    abbr --add tmux zellij
    abbr --add amux 'tmux at -t base'
    abbr --add tkill 'tmux kill-session -t'
    abbr --add nmux 'tmux new -s "base"'
    abbr --add yy yazi
    abbr --add yz yazi
end
