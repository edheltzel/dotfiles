function theme --description 'Switch color theme across all apps'
    set -l themes_dir "$HOME/.config/theme-switcher"
    set -l script "$themes_dir/theme-switcher.sh"

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

    # Re-initialize oh-my-posh with new palette if it's the active prompt
    if test "$FISH_PROMPT" = "oh-my-posh"
        oh-my-posh init fish --config ~/.config/starship-ish.omp.json | source
        echo ""
        echo -e "\033[0;32m✓\033[0m Prompt refreshed with new theme"
    end
end
