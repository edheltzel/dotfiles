# Plan: Eldritch Dark Variant + Remove No Italics Duplicate

## Context

The Zed Eldritch theme currently has two theme variants: "Eldritch" (with italics) and "Eldritch - No Italics". The official `eldritch.nvim` provides a darker variant (`colorscheme eldritch-dark`) with shifted backgrounds and desaturated accent colors. We want to:

1. **Add an "Eldritch Dark" variant** matching the official Neovim darker palette
2. **Remove the "Eldritch - No Italics" variant** since Zed supports `theme_overrides` in settings.json, which lets users disable italics per-token without a dedicated theme

### Italic Handling Decision

Zed supports `"experimental.theme_overrides"` in `settings.json` to override any theme property per-token. There is no global "disable italics" toggle, but users can override individual syntax tokens with `"font_style": "normal"`. This is sufficient -- a dedicated no-italics variant is unnecessary maintenance burden.

## File to Modify

- `config/.config/zed/themes/eldritch-theme.json`

## Tasks

### Task 1: Remove "Eldritch - No Italics" variant

Delete the entire second theme object (lines 328-650) from the `themes` array. This reduces the file from 2 variants to 1, eliminating ~320 lines of duplicated configuration.

### Task 2: Add "Eldritch Dark" variant

Add a new theme variant named `"Eldritch Dark"` using the official darker palette from `eldritch.nvim`. This variant uses:

**Background shifts (all darker):**

| Token | Default | Dark |
|-------|---------|------|
| `background` (bg) | `#212337` | `#171928` |
| `surface.background` | `#1c1d30` | `#131425` |
| `elevated_surface.background` | `#1c1d30` | `#131425` |
| `element.background` | `#18192b` | `#0f101a` |
| `status_bar.background` | `#18192b` | `#0f101a` |
| `title_bar.background` | `#18192b` | `#0f101a` |
| `tab_bar.background` | `#18192b` | `#0f101a` |
| `tab.inactive_background` | `#0d0e1c` | `#090a14` |
| `tab.active_background` | `#212337` | `#171928` |
| `panel.background` | `#1c1d30` | `#131425` |
| `terminal.background` | `#18192b` | `#0f101a` |
| `editor.background` | `#212337` | `#171928` |
| `editor.gutter.background` | `#212337` | `#171928` |

**Foreground shifts (slightly muted):**

| Token | Default | Dark |
|-------|---------|------|
| `foreground` (fg) | `#ebfafa` | `#d8e6e6` |
| `text` | `#ebfafa` | `#d8e6e6` |
| `text.muted` | `#7081d0` | `#506299` |
| `editor.foreground` | `#ebfafa` | `#d8e6e6` |

**Accent color shifts (desaturated ~15-20%):**

| Color | Default | Dark |
|-------|---------|------|
| cyan | `#04d1f9` | `#0396b3` |
| green | `#37f499` | `#2dcc82` |
| purple/magenta | `#a48cf2` | `#8b75d9` |
| pink | `#f265b5` | `#d154a1` |
| red | `#f16c75` | `#cc5860` |
| yellow | `#f1fc79` | `#ccd663` |
| orange | `#f7c67f` | `#d4a666` |
| comment | `#7081d0` | `#506299` |

**Terminal ANSI colors (darker palette):**

| Color | Default | Dark |
|-------|---------|------|
| black | `#21222c` | `#121420` |
| bright_black | `#7081d0` | `#4a5584` |
| white | `#ebfafa` | `#d8e6e6` |
| red | `#f9515d` | `#cc5860` |
| green | `#37f499` | `#2dcc82` |
| yellow | `#e9f941` | `#ccd663` |
| blue | `#9071f4` | `#7a62d1` |
| magenta | `#f265b5` | `#d154a1` |
| cyan | `#04d1f9` | `#0396b3` |

The dark variant will:
- Copy the full "Eldritch" structure (UI tokens + syntax tokens)
- Replace all background hex values with the darker equivalents
- Replace all accent color hex values with the desaturated equivalents
- Keep the same syntax token structure and italic styling
- Keep the same `font_style` and `font_weight` properties

### Task 3: Update border/UI detail colors for dark variant

Borders and UI details need proportional darkening:

| Token | Default | Dark |
|-------|---------|------|
| `border` | `#323449` | `#252738` |
| `border.variant` | `#a48cf230` | `#8b75d930` |
| `border.focused` | `#04d1f981` | `#0396b381` |
| `editor.line_number` | `#7081d03a` | `#506299a3a` |
| `editor.active_line_number` | `#37f499` | `#2dcc82` |
| `search.match_background` | `#9fa9dd68` | `#7a84b868` |
| `editor.active_line.background` | `#7081d010` | `#50629910` |

### Task 4: Validate final JSON

Run `python3 -c "import json; ..."` to verify:
- Valid JSON syntax
- Exactly 2 themes in array: "Eldritch" and "Eldritch Dark"
- Both themes have matching syntax token keys
- Both have `appearance: "dark"`

## Verification

1. `python3 -c "import json; d=json.load(open('config/.config/zed/themes/eldritch-theme.json')); print(len(d['themes']), 'themes'); [print(f'  {t[\"name\"]}: {len(t[\"style\"][\"syntax\"])} tokens') for t in d['themes']]"`
2. Open Zed, switch between "Eldritch" and "Eldritch Dark" themes
3. Verify the dark variant has noticeably darker backgrounds with muted accents
4. Test syntax highlighting in TypeScript, Python, Rust, and HTML files
