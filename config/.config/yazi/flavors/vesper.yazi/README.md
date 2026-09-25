# Vesper — Yazi flavor

A peppermint & orange dark flavor for [Yazi](https://github.com/sxyazi/yazi), ported from
[Vesper](https://github.com/raunofreiberg/vesper) by Rauno Freiberg.

## Palette

| Role      | Hex       | Role       | Hex       |
| --------- | --------- | ---------- | --------- |
| Background | `#101010` | Foreground | `#FFFFFF` |
| Surface-1  | `#161616` | Surface-2  | `#232323` |
| Surface-3  | `#282828` | Surface-4  | `#343434` |
| Orange     | `#FFC799` | Peach      | `#FFCFA8` |
| Mint       | `#99FFE4` | Red        | `#FF8080` |
| Slate      | `#65737E` | Gray       | `#A0A0A0` |
| Border     | `#505050` |            |           |

The signature look: near-black background, orange as the hero accent, mint as the cool
counterpoint, and deliberately de-emphasized (gray) keywords in code previews.

## Install

This flavor lives in `~/.config/yazi/flavors/vesper.yazi/`. Activate it in `~/.config/yazi/theme.toml`:

```toml
[flavor]
dark = "vesper"
```

## Files

- `flavor.toml` — Yazi UI theme (manager, tabs, mode, status, pickers, filetypes)
- `tmtheme.xml` — TextMate theme used by syntect for code-preview syntax highlighting
