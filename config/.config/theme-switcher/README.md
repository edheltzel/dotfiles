# Theme Switcher

Unified theme switching system for all applications in dotfiles.

> Inspired by [linkarzu's](https://github.com/linkarzu) theme switching approach.

## Supported Themes

- `eldritch` - Eldritch
- `tokyonight` - Tokyo Night
- `rose-pine` - Rosé Pine
- `rose-pine-dawn` - Rosé Pine Dawn (light theme)
- `rose-pine-moon` - Rosé Pine Moon (default)
- `vesper` - Vesper
- `catppuccin-latte` - Catppuccin Latte (light theme)
- `catppuccin-frappe` - Catppuccin Frappé
- `catppuccin-macchiato` - Catppuccin Macchiato
- `catppuccin-mocha` - Catppuccin Mocha
- `dracula` - Dracula
- `gruvbox` - Gruvbox Dark

## Supported Applications

| Application  | Eldritch | Tokyo Night | Rose Pine | Rose Pine Dawn | Rose Pine Moon | Vesper | Catppuccin† | Dracula | Gruvbox |
| ------------ | -------- | ----------- | --------- | -------------- | -------------- | ------ | ----------- | ------- | ------- |
| Ghostty      | ✓        | ✓           | ✓         | ✓              | ✓              | ✓      | ✓           | ✓       | ✓       |
| Kitty        | ✓        | ✓           | ✓         | ✓              | ✓              | ✓      | ✓           | ✓       | ✓       |
| WezTerm      | ✓        | ✓           | ✓         | ✓              | ✓              | ✓      | ✓           | ✓       | ✓       |
| Neovim       | ✓        | ✓           | ✓         | ✓              | ✓              | ✓      | ✓           | ✓       | ✓       |
| bat          | ✓        | ✓           | ✓         | ✓              | ✓              | ✓      | ✓           | ✓       | ✓       |
| btop         | ✓        | ✓           | ✓         | ✓              | ✓              | ✓      | ✓           | ✓       | ✓       |
| lazygit      | ✓        | ✓           | ✓         | ✓              | ✓              | ✓      | ✓           | ✓       | ✓       |
| oh-my-posh   | ✓        | ✓           | ✓         | ✓              | ✓              | ✓      | ✓           | ✓       | ✓       |
| Claude Code  | ✓        | ✓           | ✓         | ✓              | ✓              | ✓      | ✓           | ✓       | ✓       |
| Yazi         | ✓        | ✓           | –         | –              | –              | ✓      | –           | –       | –       |
| herdr‡       | ✓        | ✓           | ✓         | ✓              | ✓              | ✓      | ✓           | ✓       | ✓       |
| gh-dash§     | ✓        | ✓           | ✓         | ✓              | ✓              | ✓      | ✓           | ✓       | ✓       |

† All four Catppuccin flavors (Latte, Frappé, Macchiato, Mocha) are supported identically. Terminals (Ghostty, WezTerm) and bat use built-in Catppuccin themes; Neovim uses the `catppuccin/nvim` plugin; Kitty and btop use the official port theme files; oh-my-posh and lazygit use generated palettes from the official Catppuccin color spec.

‡ Yazi switches the `dark` flavor in `yazi/theme.toml`; it only ships flavors for Eldritch, Tokyo Night, and Vesper, so other themes are skipped. herdr switches `name` under `[theme]` in `herdr/config.toml` and reloads the running server live — themes without a herdr built-in (Eldritch, Rose Pine Moon, Catppuccin Frappé/Macchiato) use herdr's `terminal` theme, which follows the host terminal palette this switcher just set.

§ gh-dash (`gh dash`) has no external theme-file support — colors are an inline `theme.colors` key-value block in `gh-dash/config.yml`. Like lazygit, the switcher keeps a per-theme snippet in `gh-dash/[theme].yml` and injects it, replacing only `theme.colors` and leaving `theme.ui` and every other config section untouched. gh-dash validates strictly, so each snippet carries the full color set. Palettes are derived from the matching Kitty theme for cross-app consistency.

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
│   ├── tokyonight.yml
│   ├── rose-pine.yml
│   ├── rose-pine-dawn.yml
│   ├── rose-pine-moon.yml
│   ├── vesper.yml
│   ├── catppuccin-latte.yml
│   ├── catppuccin-frappe.yml
│   ├── catppuccin-macchiato.yml
│   ├── catppuccin-mocha.yml
│   ├── dracula.yml
│   └── gruvbox.yml
├── gh-dash/                   # gh-dash inline-color snippets (theme.colors block)
│   ├── eldritch.yml
│   ├── tokyonight.yml
│   ├── rose-pine.yml
│   ├── rose-pine-dawn.yml
│   ├── rose-pine-moon.yml
│   ├── vesper.yml
│   ├── catppuccin-latte.yml
│   ├── catppuccin-frappe.yml
│   ├── catppuccin-macchiato.yml
│   ├── catppuccin-mocha.yml
│   ├── dracula.yml
│   └── gruvbox.yml
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
- **bat/btop/lazygit**: Changes apply on next launch
- **Claude Code**: Restart to apply new theme
- **gh-dash**: Reads config only at launch — quit and relaunch `gh dash` to apply

## Adding New Themes

To add a new theme:

1. Add theme name to `THEMES` array in `theme-switch.sh`
2. Add mapping functions for each app (e.g., `get_ghostty_theme()`)
3. Create lazygit theme snippet in `lazygit/[theme-name].yml`
4. Create gh-dash color snippet in `gh-dash/[theme-name].yml` (full `theme.colors` block)
5. Add palette to `starship-ish.omp.json` if using oh-my-posh
6. Ensure theme files exist for apps that need them

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
