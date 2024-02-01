# Undo the last Git commit
#
# Usage: git-undo [--hard]
#
# If the optional `--hard` flag is provided, the changes from the last commit will be completely discarded.
# This function checks if the current directory is a Git repository and performs the undo operation accordingly.
# If not in a Git repository, an error message is displayed.
#
# Example usage:
#   git-undo             # Undo the last commit and keep changes
#   git-undo --hard      # Completely discard the changes from the last commit
#
function git-undo
    set_color red
    if test (command -v git); and git rev-parse --is-inside-work-tree >/dev/null 2>&1
        if test "$argv" = --hard
            git reset --hard HEAD~1
        else if test "$argv" = --soft
            git reset --soft HEAD~1
        else
            git reset HEAD~1
        end
    else
        echo -e "\e[31mError: Not a Git repository\e[0m"
    end
    set_color normal
end
