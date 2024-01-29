if ! status is-interactive ||
        ! command --query zoxide
    exit
end

functions --query __zoxide_cd_internal || functions --copy cd __zoxide_cd_internal

set --query zoxide_hook || set --local zoxide_hook --on-variable PWD
if test -n "$zoxide_hook"
    function __zoxide_hook $zoxide_hook
        test -z "$fish_private_mode"
        and command zoxide add -- (__zoxide_pwd)
    end
end

set --query zoxide_cmd || set --local zoxide_cmd z
if test -n "$zoxide_cmd"
    function $zoxide_cmd
        __zoxide_z $argv
    end
    complete $zoxide_cmd --no-files -a '(__zoxide_z_complete)'

    function "$zoxide_cmd"i
        __zoxide_zi $argv
    end
end
