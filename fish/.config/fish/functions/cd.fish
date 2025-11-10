function cd --description 'list all files after cd into a direcotry'
    if test (count $argv) -gt 0
        # open yazi with cd into a directory
        builtin cd "$argv"; and yazi
    else
        # No arguments - go to home directory
        builtin cd ~; and yazi
    end
end
