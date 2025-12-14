# cspell: disable
if status is-interactive
    abbr --add atm fastfetch
    abbr --add bi 'brew install '
    abbr --add binfo 'brew info'
    abbr --add brews 'brew list'
    abbr --add casks 'brew list --cask'
    abbr --add bic --set-cursor 'brew install % --cask'
    abbr --add cl clear
    abbr --add cw center_window
    abbr --add cat 'bat -pp'
    abbr --add cmy 'bunx mac-cleaner-cli'
    abbr --add clean 'bunx mac-cleaner-cli'
    # abbr --add cls '$DROPBOX/Clients'

    # Editors & Terminals
    abbr --add ght wezterm
    abbr --add wez wezterm
    abbr --add kit kitten
    abbr --add co code
    abbr --add con 'code -n .'
    abbr --add coo 'code -r .'
    abbr --add ze zed
    abbr --add zz 'zed -n .'
    abbr --add nn nvim
    abbr --add nv nvim
    abbr --add nvv 'nvim .'
    abbr --add vim nvim

    abbr --add cargos 'cargo install --list'
    abbr --add config '~/.config/'
    abbr --add local '~/.local/'
    abbr --add lh 'lighthouse --output=html --output-path ~/Developer/Lighthouse-Audits/ https://'
    abbr --add wp '~/.wallpapers/'
    abbr --add lg lazygit
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
    abbr --add sp 'speedtest -u Gbps'
    abbr --add spp 'speedtest -u Gbps'
    abbr --add grabit 'wget -mkEpnp url_here'
    abbr --add link 'ln -s'
    abbr --add symlink 'ln -s'
    abbr --add wrg wrangler
    abbr --add upp topgrade
    abbr --add psrv 'php -S localhost:8888'
    abbr --add omp oh-my-posh
    abbr --add newcode 'npx --package yo --package generator-code -- yo code'
    abbr --add confi confetti
    abbr --add ax 'tmux at -t base'
    abbr --add amux 'tmux at -t base'
    abbr --add nx 'tmux new -s "base"'
    abbr --add kx 'tmux kill-session -t'
    abbr --add tkill 'tmux kill-session -t'
    abbr --add nmux 'tmux new -s "base"'
    abbr --add yy yazi
    abbr --add zip 'ouch compress -q'
    abbr --add unzip ouch decompress
    abbr --add lzip ouch list
    # AI Agents + Models
    abbr --add ccu 'bunx ccusage'
    abbr --add cc 'claude --dangerously-skip-permissions'
    abbr --add ccd 'claude --dangerously-skip-permissions'
    abbr --add os openspec
    abbr --add oc opencode
    abbr --add gg gemini
end
