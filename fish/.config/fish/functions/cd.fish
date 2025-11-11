function cd --description 'list files in the current directory after changing to it'
    if count $argv >/dev/null
        # prevents recurse infinitely by using built-in cd
        builtin cd "$argv"; and eza --long --all --header --git --icons --no-permissions --no-time --no-user --no-filesize --group-directories-first
        # builtin cd "$argv"; and yazi
    else
        # builtin cd ~; and eza -lagh --icons --group-directories-first
        builtin cd ~; and eza --long --all --header --git --icons --no-permissions --no-time --no-user --no-filesize --group-directories-first
        # builtin cd "$argv"; and yazi
    end
end
