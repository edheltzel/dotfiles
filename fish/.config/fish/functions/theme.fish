function theme --description 'Switch color theme across all apps'
    set -l themes_dir "$HOME/.config/themes"
    set -l script "$themes_dir/theme-switch.sh"

    # Check if theme-switch.sh exists
    if not test -x "$script"
        echo "Error: Theme switcher script not found at $script" >&2
        return 1
    end

    # Pass all arguments to the script
    if test (count $argv) -eq 0
        # No args - run interactive picker
        $script
    else
        # Pass argument(s) to script
        $script $argv[1]
    end
end
