# I treat these like aliases 
if status is-interactive
    # Window
    abbr --add cw center_window
    abbr --add cl clear

    # Directories
    # abbr --add cls '$DROPBOX/Clients'
    abbr --add atl 'cd ~/Developer/atlas-config/'
    abbr --add atlas 'cd ~/Developer/atlas-config/'
    abbr --add config '~/.config/'
    abbr --add dev 'cd ~/Developer'
    abbr --add dls '~/Downloads/'
    abbr --add dots 'cd ~/.dotfiles'
    abbr --add fld "cd \"/Users/ed/Library/Mobile Documents/iCloud~md~obsidian/Documents/FieldNotes✱\""
    abbr --add goo 'cd ~/.go/'
    abbr --add local '~/.local/'
    abbr --add neo 'cd ~/.dotfiles/neoed/.config/nvim'
    abbr --add neoed 'cd ~/.dotfiles/neoed/.config/nvim'
    abbr --add pg 'cd ~/Developer/_playground/'
    abbr --add sb 'cd ~/Developer/_sandboxes/'
    abbr --add sites 'cd ~/Sites'
    abbr --add wall '~/.wallpapers/'
    abbr --add work 'cd ~/Developer'

    # servers/containers
    abbr --add dc 'docker compose'
    abbr --add dk docker

    # multiplex/terminals
    abbr --add gty ghostty
    abbr --add mux tmux
    abbr --add muxa 'tmux attach'
    abbr --add muxaa 'tmux attach -t'
    abbr --add muxd 'tmux detach'
    abbr --add muxk 'tmux kill-session -t'
    abbr --add muxka 'tmux kill-server'
    abbr --add muxl 'tmux list-sessions'
    abbr --add muxs 'tmux new-session -s'

    # herdr 
    abbr --add hsa --set-cursor 'herdr session attach %'
    abbr --add hhs --set-cursor 'herdr --session %'
    abbr --add hks --set-cursor 'herdr session stop %'
    abbr --add hls 'herdr session list'
    abbr --add hrd herdr
    abbr --add hrr --set-cursor 'herdr --remote %'
    abbr --add hss 'herdr server stop'
    abbr --add hup 'herdr update'

    # AI Harness
    abbr --add cc claude
    abbr --add co codex
    abbr --add oc opencode
    abbr --add oo omp
    abbr --add ccp --set-cursor 'claude -p "%"'
    abbr --add cop --set-cursor 'codex -p "%"'
    abbr --add ppi --set-cursor 'pi -p "%"'
    abbr --add ooi --set-cursor 'omp, -p "%"'

    # text editors
    abbr --add zz zed
    abbr --add zzn 'zed -n .'
    abbr --add vim nvim
    abbr --add nv nvim
    abbr --add v nvim
    abbr --add vv 'nvim .'
    abbr --add obs obsidian
    abbr --add rd 'roughdraft open'
    abbr --add cg codegraph
    abbr --add cgi 'codegraph init'

    # updates
    abbr --add upp 'topgrade --yes'
    abbr --add bup 'topgrade --yes --only brew_formula brew_cask'
    abbr --add aup 'claude update; codex update; pi update; omp update; herdr update'

    # Utilities
    abbr --add editssh 'nvim ~/.ssh'
    abbr --add hostfile 'sudo nvim /etc/hosts'
    abbr --add atm fastfetch
    abbr --add cat 'bat -p'
    abbr --add link 'ln -s'
    abbr --add symlink 'ln -s'
    abbr --add siz 'du -khsc'
    abbr --add sp 'speedtest -u Gbps'
    abbr --add spp 'speedtest -u Gbps'
    abbr --add yy yazi
    abbr --add wr wrangler
    abbr --add zip 'ouch compress -q'
    abbr --add unzip ouch decompress
    abbr --add lzip ouch ligst
    abbr --add phps 'php -S localhost:8888'
    abbr --add md 'mkdir -p'
    abbr --add cwd pwd
    abbr --add e '$EDITOR'
    abbr --add o open
    abbr --add oh 'open .'
    abbr --add oa 'open -a'
    abbr --add del trash
    abbr --add sdel 'sudo rm -rf'
    abbr --add serve miniserve
    abbr --add du dua
    abbr --add wget 'wget -c'
    abbr --add whois 'grc whois'

    # Git
    abbr --add lg lazygit
    abbr --add lj lazyjj
    abbr --add ghw 'gh repo view --web'
    abbr --add ghd 'gh dash'
    abbr --add ghpr 'gh pr create -a "@me" --fill'
    abbr --add ghm --set-cursor 'gh pr merge % --merge'
    abbr --add ghr --set-cursor 'gh release create v% --generate-notes --latest'

    #JuJitsu (jj) - bookmarks = branch workspace = worktrees (sort-of)
    abbr --add jjc --set-cursor 'jj commit -m "%"'
    abbr --add jje --set-cursor 'jj edit %' #like git checkout
    abbr --add jjn --set-cursor 'jj new %' #like git stash
    abbr --add jjb --set-cursor 'jj bookmark create % -r @' #like git checkout -b
    abbr --add jjs --set-cursor 'jj squash %'
    abbr --add jju --set-cursor 'jj undo %'

    # Package Managers 
    abbr --add brews 'brew list'
    abbr --add buns 'bun pm ls -g'
    abbr --add cargos 'cargo install --list'
    abbr --add casks 'brew list --cask'
    abbr --add gems 'gem list'
    abbr --add npms 'npm list -g --depth=0'
    abbr --add pn pnpm
    abbr --add pns 'pnpm list -g'
    abbr --add px 'pnpm dlx'
    abbr --add vps 'vp list -g'
    abbr --add vpi 'vp install'
    abbr --add vpg 'vp install -g '
    abbr --add vup 'vp update -g '
end
