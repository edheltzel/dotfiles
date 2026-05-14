# cspell: disable
if status is-interactive
    # Window
    abbr --add cw center_window
    abbr --add cl clear

    # Directories
    # abbr --add cls '$DROPBOX/Clients'
    abbr --add config '~/.config/'
    abbr --add local '~/.local/'
    abbr --add wall '~/.wallpapers/'
    abbr --add dls '~/Downloads/'
    abbr --add goo 'cd ~/.go/'
    abbr --add pg 'cd ~/Developer/_playground/'
    abbr --add sb 'cd ~/Developer/_sandboxes/'
    abbr --add fld "cd \"/Users/ed/Library/Mobile Documents/iCloud~md~obsidian/Documents/FieldNotes✱\""

    # Editors/Terminals
    abbr --add gty ghostty
    abbr --add mux tmux
    abbr --add muxa 'tmux attach'
    abbr --add muxaa 'tmux attach -t'
    abbr --add muxs 'tmux new-session -s'
    abbr --add muxk 'tmux kill-session -t'
    abbr --add muxka 'tmux kill-server'
    abbr --add muxl 'tmux list-sessions'
    abbr --add muxd 'tmux detach'
    abbr --add hss 'herdr server stop'
    abbr --add hrd herdr
    abbr --add hrds --set-cursor 'herdr --remote %'

    # AI Agents + Models
    abbr --add cc claude
    abbr --add ccd 'claude --dangerously-skip-permissions'
    abbr --add co codex
    abbr --add coo 'codex --yolo'
    abbr --add ccp --set-cursor 'claude -p "%"'
    abbr --add cop --set-cursor 'codex -p "%"'
    abbr --add ppi --set-cursor 'pi -p "%"'

    # text editors
    abbr --add con 'code -n .'
    abbr --add coo 'code -r .'
    abbr --add zz zed
    abbr --add zzn 'zed -n .'
    abbr --add vim nvim
    abbr --add nv nvim
    abbr --add v nvim
    abbr --add vv 'nvim .'
    abbr --add obs obsidian

    # Utilities
    abbr --add atm fastfetch
    abbr --add cat 'bat -pp'
    abbr --add link 'ln -s'
    abbr --add symlink 'ln -s'

    # Git
    abbr --add lg lazygit
    abbr --add ghw 'gh repo view --web'
    abbr --add ghd 'gh dash'
    abbr --add ghpr 'gh pr create -a "@me" --fill'
    abbr --add ghm --set-cursor 'gh pr merge % --merge'
    abbr --add ghr --set-cursor 'gh release create v% --generate-notes --latest'

    # Package Managers 
    abbr --add brews 'brew list'
    abbr --add casks 'brew list --cask'
    abbr --add cargos 'cargo install --list'
    abbr --add gems 'gem list'
    abbr --add npms 'npm list -g --depth=0'
    abbr --add pns 'pnpm list -g'
    abbr --add pnpms 'pnpm list -g'
    abbr --add buns 'bun pm ls -g'
    abbr --add siz 'du -khsc'
    abbr --add sp 'speedtest -u Gbps'
    abbr --add spp 'speedtest -u Gbps'
    abbr --add newcode 'bunx --package yo --package generator-code -- yo code'
    abbr --add yy yazi
    abbr --add wr wrangler
    abbr --add upp 'topgrade --yes'
    abbr --add phps 'php -S localhost:8888'
    abbr --add zip 'ouch compress -q'
    abbr --add unzip ouch decompress
    abbr --add lzip ouch ligst

    # Migrated from aliases (simple 1:1 mappings)
    abbr --add md 'mkdir -p'
    abbr --add cwd pwd
    abbr --add yp 'pwd | pbcopy'
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
