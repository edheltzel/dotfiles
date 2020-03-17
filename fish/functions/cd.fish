function cd --description 'Utility for expanding abbreviations'
    if count $argv > /dev/null
        # prevents recurse infinitely by using built-in cd
        builtin cd "$argv"; and exa -Flahr --group-directories-first
    else
        builtin cd ~; and exa -Flahr --group-directories-first
    end
end
