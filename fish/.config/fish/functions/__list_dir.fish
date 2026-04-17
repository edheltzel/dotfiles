function __list_dir --description 'shared eza listing used by cd and z'
    eza --long --all --header --git --icons \
        --no-permissions --no-time --no-user --no-filesize \
        --group-directories-first
end
