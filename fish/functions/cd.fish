function cd --description 'Utility for expanding abbreviations'
    if count $argv > /dev/null
        # prevents recurse infinitely by using built-in cd
        builtin cd "$argv"; and exa -Flah --sort name --group-directories-first
    else
        builtin cd ~; and exa -Flah --sort name --group-directories-first
    end
end
