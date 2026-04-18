# Fix WezTerm Theme Switcher Crash

## Context

Running `theme` crashes WezTerm with `tabs.lua:13: attempt to index a nil value (local 'colors')`. Root cause: **type mismatch** — `wezterm.lua` passes a string to modules that expect the `theme.lua` table. Additionally, `theme.lua` only has color data for 3 of 7 supported themes, and the theme-switcher updates the wrong file.

## Changes (3 files)

### 1. `config/.config/wezterm/wezterm.lua` — Line 12

Replace the string with a module require:

```lua
-- BEFORE:
local theme = "rose-pine-dawn"

-- AFTER:
local theme = require("theme")
```

No other lines change. `tabs.setup(theme)`, `statusbar.setup(theme)`, and `configuration.setup(theme, keymaps)` all already expect the table API.

### 2. `config/.config/wezterm/theme.lua` — Lines 12-36

**a) Fix `M.name` to match current active theme** (line 13):
```lua
M.name = "rose-pine-dawn"
```

**b) Add all 7 theme entries** with colors sourced from `.toml` files and `theme-preview.sh`:

| Theme | Key | Color Source |
|-------|-----|-------------|
| Aura | `"Aura"` | `theme-preview.sh` lines 15-25 |
| Eldritch | `"Eldritch"` | `colors/eldritch.toml` (existing `default` entry) |
| rose-pine | `"rose-pine"` | Existing entry (unchanged) |
| rose-pine-dawn | `"rose-pine-dawn"` | Existing entry (unchanged) |
| rose-pine-moon | `"rose-pine-moon"` | `colors/rose-pine-moon.toml` |
| Tokyo Night | `"Tokyo Night"` | `theme-preview.sh` lines 75-85 |
| Tokyo Night Moon | `"Tokyo Night Moon"` | `theme-preview.sh` lines 87-97 |

Note: Theme keys use WezTerm `color_scheme` names (e.g., `"Eldritch"` not `"eldritch"`) because `M.name` feeds directly into `config.color_scheme`.

**c) Simplify `get_theme_key` fallback** to return `"Eldritch"` instead of `"default"`. Remove the rose-pine pattern matching since all variants now have explicit entries.

### 3. `config/.config/theme-switcher/theme-switcher.sh` — Lines 184-191

Retarget `update_wezterm()` to sed `theme.lua` instead of `wezterm.lua`:

```bash
# BEFORE:
local config_file="$CONFIG/wezterm/wezterm.lua"
sed -i '' "s/^local theme = .*/local theme = \"$wezterm_theme\"/" "$config_file"

# AFTER:
local config_file="$CONFIG/wezterm/theme.lua"
sed -i '' "s/^M\.name = .*/M.name = \"$wezterm_theme\"/" "$config_file"
```

### No changes needed

- `tabs.lua` — already expects table, will work once it gets one
- `statusbar.lua` — same
- `configuration.lua` — `config.color_scheme = theme.name` already works with the table

## Implementation Order

1. `theme.lua` first (add themes + fix M.name)
2. `wezterm.lua` (change string to require)
3. `theme-switcher.sh` (retarget sed)

Step 1 before 2 ensures WezTerm doesn't load with wrong theme during the transition.

## Verification

1. Open WezTerm after changes — should load without crash, show rose-pine-dawn colors
2. Run `theme eldritch` — WezTerm hot-reloads, tabs/statusbar use Eldritch colors
3. Cycle all 7 themes: `theme aura`, `theme eldritch`, `theme rose-pine`, `theme rose-pine-dawn`, `theme rose-pine-moon`, `theme tokyo-night`, `theme tokyo-night-moon`
4. Edge case: manually set `M.name` to garbage string — should fall back to Eldritch, no crash
