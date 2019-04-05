function cd --description 'Utility for expanding abbreviations'
    if count $argv > /dev/null
        # prevents recurse infinitely by using built-in cd
        builtin cd "$argv"; and exa -Falh
    else
        builtin cd ~; and exa -Falh
    end
end
