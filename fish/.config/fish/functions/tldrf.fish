function tldrf --description 'tldr search and preview with fzf'
    tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr
end
