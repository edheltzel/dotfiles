function batthemes --description 'list all bat themes with a preview'
    bat --list-themes | fzf --preview="bat --theme={} --color=always Makefile" | pbcopy
end
