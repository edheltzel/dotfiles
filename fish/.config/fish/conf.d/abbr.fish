# I treat these like aliases
if status is-interactive
    # Window
    abbr --add cw center_window
    abbr --add cl clear

    # Directories
    # abbr --add cls '$DROPBOX/Clients'
    abbr --add atl 'cd ~/Developer/Atlas/Config/'
    abbr --add atlas 'cd ~/Developer/Atlas/'
    abbr --add config '~/.config/'
    abbr --add dev 'cd ~/Developer'
    abbr --add dls '~/Downloads/'
    abbr --add dots 'cd ~/.dotfiles'
    abbr --add fld "cd \"/Users/ed/Library/Mobile Documents/iCloud~md~obsidian/Documents/FieldNotes✱\""
    abbr --add local '~/.local/'
    abbr --add pg 'cd ~/Developer/Playground/'
    abbr --add sb 'cd ~/Developer/Sandboxes/'
    abbr --add sites 'cd ~/Sites'
    abbr --add wall '~/.wallpapers/'

    # Servers/Containers
    abbr --add dc 'docker compose'
    abbr --add dk docker

    # Multiplexers
    abbr --add tkill 'tmux kill-session -t'
    abbr --add tkilla 'tmux kill-server'
    abbr --add has --set-cursor 'herdr session attach sessionName%'
    abbr --add hcs --set-cursor 'herdr --session sessionName%'
    abbr --add hks --set-cursor 'herdr session stop sessionName%'
    abbr --add hds --set-cursor 'herdr session delete sessionName%'
    abbr --add hls 'herdr session list'
    abbr --add hrd herdr
    abbr --add hrr --set-cursor 'herdr --remote sessionName%'
    abbr --add hss 'herdr server stop'
    abbr --add hup 'herdr update'

    # Agent Harnesses
    abbr --add cc claude
    abbr --add co codex
    abbr --add oc opencode
    abbr --add oo omp
    abbr --add ccp --set-cursor 'claude -p "%"'
    abbr --add cop --set-cursor 'codex -p "%"'
    abbr --add ppi --set-cursor 'pi -p "%"'
    abbr --add ooi --set-cursor 'omp, -p "%"'

    # Terminals/Text Editors
    abbr --add zz zed
    abbr --add zzn 'zed -n .'
    abbr --add vim nvim
    abbr --add nv nvim
    abbr --add v nvim
    abbr --add vv 'nvim .'
    abbr --add obs obsidian

    # Updates
    abbr --add upp 'topgrade --yes'
    abbr --add bup 'topgrade --yes --only brew_formula brew_cask'
    function __aup_run --description 'Run one update command and report its result'
        set -l label $argv[1]
        set -e argv[1]

        command $argv
        set -l update_status $status

        if test $update_status -eq 0
            printf '[OK] %s update completed.\n' "$label"
        else
            printf '[FAIL] %s update failed (exit %d).\n' "$label" $update_status
        end

        return $update_status
    end

    function aup --description 'Update agent harnesses and installed extensions'
        set -l failed 0

        __aup_run Claude claude update; or set failed 1
        __aup_run 'Pi core' pi update; or set failed 1
        __aup_run 'Pi extensions' pi update --extensions; or set failed 1
        __aup_run 'OMP core' omp update; or set failed 1
        __aup_run 'OMP plugins' omp update --plugins; or set failed 1
        __aup_run Herdr herdr update; or set failed 1

        return $failed
    end

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
    abbr --add mdt mdterm
    abbr --add rd 'roughdraft open'
    abbr --add cg codegraph
    abbr --add cgs 'codegraph sync'
    abbr --add cgi 'codegraph init'
    abbr --add cgii 'codegraph index'
    abbr --add nm no-mistakes

    # Git
    abbr --add th treehouse
    abbr --add lw lazyworktree
    abbr --add lg lazygit
    abbr --add ghw 'gh repo view --web'
    abbr --add ghd 'gh dash'
    abbr --add ghpr 'gh pr create -a "@me" --fill'
    abbr --add ghmr --set-cursor 'gh pr merge % --merge'
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
    abbr --add bi --set-cursor 'brew isntall %'
    abbr --add bu --set-cursor 'brew unisntall %'
    abbr --add bic --set-cursor 'brew install --cask %'
    abbr --add buc --set-cursor 'brew uninstall --cask %'
    abbr --add bric --set-cursor 'brew reinstall --cask %'
    abbr --add buns 'bun pm ls -g'
    abbr --add cargos 'cargo install --list'
    abbr --add casks 'brew list --cask'
    abbr --add gems 'gem list'
    abbr --add npms 'npm list -g --depth=0'
    abbr --add pn pnpm
    abbr --add pns 'pnpm list -g'
    abbr --add px 'pnpm dlx'
    abbr --add vpi 'vp install'
end
