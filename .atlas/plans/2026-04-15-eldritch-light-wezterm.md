# Eldritch Light — WezTerm Variant

**Date:** 2026-04-15
**Scope:** WezTerm only (Neovim + other terminals deferred to a later pass)
**Direction:** Hi-Fi — cool light bg, keep the Eldritch neon pop. Cyberpunk-at-noon.

## Goal

Produce a light sibling of Eldritch that retains ~95% of the original identity:
- Unmistakably related (same hue palette — green/purple/pink/cyan)
- Signature neon green (`#37F499` → `#1FD085`) still pops as the hero accent
- Full ANSI + bright slot coverage, cursor/selection/tab-bar parity with Eldritch dark

## Palette Rationale

### Background layers (cool off-white, matching Eldritch's cool-dark family)

| Slot        | Dark Eldritch | Light Eldritch | Notes                                  |
| ----------- | ------------- | -------------- | -------------------------------------- |
| bg (paper)  | `#171928`     | `#EDEEF5`      | Inverted value, preserved cool hue     |
| bg alt      | `#212337`     | `#DDDFEA`      | Tab bar / pane alt                     |
| split       | `#323449`     | `#C9CCE0`      | Mid-tone divider                       |
| fg primary  | `#EBFAFA`     | `#171928`      | Hardest-contrast text uses Eldritch's own darkest navy |

### Accents (Hi-Fi — punchy, not muted)

| Role   | Dark      | Light     | Adjustment                               |
| ------ | --------- | --------- | ---------------------------------------- |
| red    | `#F16C75` | `#E83D50` | Deeper saturation, higher contrast on white |
| green  | `#37F499` | `#1FD085` | Darkened mint — still reads as "Eldritch green" |
| yellow | `#F7F67F` | `#C8AB00` | Yellow on white is the hardest problem — solved with deep gold |
| purple | `#A48CF2` | `#7A5CF0` | Saturated violet                         |
| cyan   | `#04D1F9` | `#00AEE0` | Ocean teal — keeps the cyan identity     |
| pink   | `#F265B5` | `#E63F9B` | Hot magenta                              |
| orange | `#F7C67F` | `#E88A2C` | Agent-activity indicator, stays warm     |

### ANSI mapping logic

- `ansi[0]` (black) = `#171928` — the dark text color
- `brights[0]` (bright black) = `#5A5D74` — mid-tone gray-navy for comments (lower contrast on purpose)
- `ansi[7]` (white) = `#D5D7E2` — slightly darker than bg for "dim light" text
- `brights[7]` (bright white) = `#171928` — mirrors dark Eldritch's `#FFFFFF` convention

### Cursor + selection

- `cursor_bg` = `#1FD085` (signature green preserved as cursor hero)
- `cursor_border` = `#00AEE0` (cyan outline)
- `cursor_fg` = `#EDEEF5` (bg color → cursor appears to "cut out" text)
- `selection_bg` = `rgba(9% 9.8% 15.7% 20%)` — navy bleed at 20% alpha

## Files Touched

1. **`config/.config/wezterm/colors/eldritch-light.toml`** (new) — full color scheme, `metadata.name = "Eldritch Light"`
2. **`config/.config/wezterm/theme.lua`** — new `["Eldritch Light"]` entry in the `themes` table with the same shape Eldritch dark uses (so `tabs.lua` + `statusbar.lua` render correctly without code changes)
3. **`config/.config/wezterm/configuration.lua`** — font weight bump: refactored single-theme check into a lookup table so future light themes can opt in trivially

## Activation

Flip the active theme in `config/.config/wezterm/theme.lua`:

```lua
M.name = "Eldritch Light"
```

Then restart WezTerm (or `Cmd+Shift+R` to reload).

## Out of Scope (deferred)

- Neovim (needs either a custom lualine palette file or picking an existing light Neovim scheme as proxy)
- Kitty / Ghostty / bat / btop / lazygit / opencode / oh-my-posh
- Integration with `theme-switcher.sh` (would require mapping functions for all targets — defer until the other apps have light Eldritch implementations)

## Contrast Check (informal)

Body text `#171928` on `#EDEEF5`: ratio ≈ 15.8:1 (passes WCAG AAA for all text sizes)
Comment text `#5A5D74` on `#EDEEF5`: ratio ≈ 5.4:1 (passes AA for body text)
Green `#1FD085` on `#EDEEF5`: ratio ≈ 2.4:1 (OK for large/display text only — this is intentional; the green is meant to pop as an accent, not carry body copy)
