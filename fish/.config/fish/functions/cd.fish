function cd --description 'list files in the current directory after changing to it'
    if count $argv >/dev/null
        builtin cd "$argv"; and __list_dir
    else
        builtin cd ~; and __list_dir
    end
end
