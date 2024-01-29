function __zoxide_z_complete
    set --local tokens (commandline --current-process --tokenize)
    set --local curr_tokens (commandline --cut-at-cursor --current-process --tokenize)

    if test (count $tokens) -le 2 -a (count $curr_tokens) -eq 1
        # If there are < 2 arguments, use `cd` completions.
        __fish_complete_directories "$tokens[2]" ''
    else if test (count $tokens) -eq (count $curr_tokens)
        # If the last argument is empty, use interactive selection.
        set --local query $tokens[2..-1]
        set --local result (zoxide query --interactive -- $query)
        commandline --current-process "$tokens[1] "(string escape $result)
        commandline --function repaint
    end
end
