# Eldritch — Yazi flavor

A cosmic-horror dark flavor for [Yazi](https://github.com/sxyazi/yazi), ported from
[Eldritch](https://github.com/eldritch-theme/eldritch.nvim) and matched to Ed's
terminal palette (Ghostty / Kitty eldritch).

## Palette

| Role       | Hex       | Role       | Hex       |
| ---------- | --------- | ---------- | --------- |
| Background | `#171928` | Foreground | `#ebfafa` |
| Surface-1  | `#212337` | Surface-2  | `#323449` |
| Comment    | `#7081d0` | Border     | `#565f89` |
| Cyan       | `#04d1f9` | Green      | `#37f499` |
| Purple     | `#a48cf2` | Pink       | `#f265b5` |
| Yellow     | `#f1fc79` | Orange     | `#f7c67f` |
| Red        | `#f16c75` |            |           |

The signature look: deep blue-black background, glacial cyan as the hero accent, toxic
green as the cool counterpoint, and purple/pink highlights for markers and selections.

## Install

This flavor lives in `~/.config/yazi/flavors/eldritch.yazi/`. Activate it in `~/.config/yazi/theme.toml`:

```toml
[flavor]
dark = "eldritch"
```

Or switch the whole machine with the dotfiles theme switcher: `theme eldritch`.

## Files

- `flavor.toml` — Yazi UI theme (manager, tabs, mode, status, pickers, filetypes). The
  `[icon]` block follows the terminal's ANSI palette, so icons adapt to the active terminal theme.
- `tmtheme.xml` — TextMate theme used by syntect for code-preview syntax highlighting
  (the same Eldritch tmTheme used by `bat`).
