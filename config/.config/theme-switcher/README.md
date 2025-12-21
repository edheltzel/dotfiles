# Theme Switcher

Unified theme switching system for all applications in dotfiles.

> Inspired by [linkarzu's](https://github.com/linkarzu) theme switching approach.

## Supported Themes

- `eldritch` - Eldritch
- `rose-pine` - Rosé Pine
- `rose-pine-moon` - Rosé Pine Moon (default)
- `tokyo-night` - Tokyo Night
- `tokyo-night-moon` - Tokyo Night Moon

## Supported Applications

| Application | Eldritch | Rose Pine | Rose Pine Moon | Tokyo Night | Tokyo Night Moon |
| ----------- | -------- | --------- | -------------- | ----------- | ---------------- |
| Ghostty     | ✓        | ✓         | ✓              | ✓           | ✓                |
| Kitty       | ✓        | ✓         | ✓              | ✗           | ✗                |
| WezTerm     | ✓        | ✓         | ✓              | ✓           | ✓                |
| Neovim      | ✓        | ✓         | ✓              | ✓           | ✓                |
| bat         | ✓        | ✓         | ✓              | ✓           | ✓                |
| btop        | ✓        | ✓         | ✓              | ✗           | ✗                |
| lazygit     | ✓        | ✓         | ✓              | ✓           | ✓                |
| eza         | ✓        | ✓         | ✓              | ✓           | ✗                |
| oh-my-posh  | ✓        | ✓         | ✓              | ✓           | ✓                |
| OpenCode    | ✓\*      | ✓         | ✓\*            | ✓           | ✓\*              |

\*OpenCode uses `system` theme for Eldritch (no native support), and `rosepine`/`tokyonight` for moon variants (single variant only).

**Note:** Starship is not managed by the theme switcher (use oh-my-posh for automatic theme switching).

## Usage

```bash
# Interactive picker with preview (shows current theme with ● indicator)
theme

# Direct switch to a specific theme
theme rose-pine-moon

# Show current theme
theme --current

# List available themes (shows current theme with ● indicator)
theme --list

# Show help
theme --help
```

The interactive picker and `--list` command both show the currently active theme with a ● indicator.

## Files

```
theme-switcher/
├── current                    # Contains current theme name
├── theme-switcher.sh            # Main theme switching script
├── theme-preview.sh                 # Color preview for fzf
├── lazygit/                   # lazygit theme snippets
│   ├── eldritch.yml
│   ├── rose-pine.yml
│   ├── rose-pine-moon.yml
│   ├── tokyo-night.yml
│   └── tokyo-night-moon.yml
└── README.md                  # This file
```

## How It Works

1. **Theme Selection**: The `theme` command (Fish function) calls `theme-switch.sh`
2. **Config Updates**: Script uses `sed` to update each app's config file
3. **Skipped Apps**: Apps without theme support for the selected theme are skipped with a warning
4. **Current Theme**: The selected theme is saved to `current` for reference
5. **Auto Reload**: Ghostty config is automatically reloaded if the app is running

## Reloading Apps

After switching themes:

- **Ghostty**: Automatically reloaded by the theme switcher (triggers `Cmd+Ctrl+Alt+,`)
- **Kitty**: Automatically reloads on config change
- **WezTerm**: Automatically reloads on config change
- **Neovim**: Restart or `:e` to reload
- **bat/btop/eza/lazygit**: Changes apply on next launch
- **oh-my-posh**: Restart shell or `exec fish`
- **OpenCode**: Restart to apply new theme

## Adding New Themes

To add a new theme:

1. Add theme name to `THEMES` array in `theme-switch.sh`
2. Add mapping functions for each app (e.g., `get_ghostty_theme()`)
3. Create lazygit theme snippet in `lazygit/[theme-name].yml`
4. Add palette to `starship-ish.omp.json` if using oh-my-posh
5. Ensure theme files exist for apps that need them

## Troubleshooting

**Theme doesn't apply:**

- Check that the theme file exists for that app
- Verify the config file path in `theme-switch.sh`
- Check for sed errors in terminal output

**Interactive picker not working:**

- Ensure `fzf` is installed: `brew install fzf`
- Make sure scripts are executable: `chmod +x theme-switch.sh preview.sh`

**Colors look wrong:**

- Verify terminal supports true color (24-bit)
- Check terminal's color profile settings
- Ensure theme files are properly formatted
