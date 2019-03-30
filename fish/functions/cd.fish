function cd --description 'Utility for expanding abbreviations'
    if count $argv > /dev/null
        # prevents recurse infinitely by using built-in cd
        builtin cd "$argv"; and ls
    else
        builtin cd ~; and ls
    end
end
