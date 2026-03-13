# Zellij integration — push CWD to zjstatus and auto-rename tabs
if status is-interactive; and set -q ZELLIJ
    function __zellij_update_cwd --on-event fish_prompt
        command zellij pipe --plugin zjstatus "zjstatus::pipe::cwd::(basename $PWD)" &
        disown
    end

    function __zellij_update_tabname --on-variable PWD
        set -l tab_name
        if test "$PWD" = "$HOME"
            set tab_name "~"
        else if set -l git_root (git rev-parse --show-toplevel 2>/dev/null)
            set -l repo (basename $git_root)
            if test "$PWD" = "$git_root"
                set tab_name "$repo"
            else
                set tab_name "$repo/"(string replace "$git_root/" "" "$PWD")
            end
        else
            set tab_name (basename $PWD)
        end
        command zellij action rename-tab "$tab_name" 2>/dev/null &
        disown
    end

    # Set tab name on shell startup
    __zellij_update_tabname
end
