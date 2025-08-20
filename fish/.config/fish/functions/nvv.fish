function nvv --description 'Open a new file in neovim from clipboard contents'
    nvim -c 'enew | put +' -c startinsert
end
