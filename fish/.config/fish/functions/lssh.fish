function lssh --description 'list ssh hosts'
    grep -w -i Host ~/.ssh/config | sed s/Host//
end
