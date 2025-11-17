# Lazy-load zoxide on first use
function z --description "Jump to a directory using zoxide"
    # Initialize zoxide (only runs once)
    zoxide init fish | source

    # Redefine z to use the zoxide-provided function
    functions --erase z

    # Call the real z function
    z $argv
end
