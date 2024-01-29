function __zoxide_zi
    set --local result (command zoxide query --interactive -- $argv)
    and __zoxide_cd $result
end
