# Lazy-load zoxide interactive on first use
function zi --description "Jump to a directory using zoxide (interactive)"
    # Initialize zoxide (only runs once)
    zoxide init fish | source

    # Redefine zi to use the zoxide-provided function
    functions --erase zi

    # Call the real zi function
    zi $argv
end
