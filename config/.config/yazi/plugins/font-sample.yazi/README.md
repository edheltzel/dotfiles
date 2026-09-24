Programming font with ligatures and NerdFont icon

<img width="400" alt="JetBrainsMono font preview" src="https://github.com/user-attachments/assets/f5725338-6e37-410d-a290-86fdaec817eb" />

Font with CJK characters

<img width="400" alt="NotoSans CJK font preview" src="https://github.com/user-attachments/assets/8e34bb7f-6004-411b-9e92-6a06e40e5982" />

Font with custom text

<img width="400" alt="GrapeNuts font with lorem ipsum as text" src="https://github.com/user-attachments/assets/d4fd834a-4066-4a3e-9644-388d32cb7d03" />

# Features

- easily check for common font features
  - `oO0`, `1lI` distinctions
  - nerd font icons
  - ligatures
  - diacritics
- check if font has CJK characters
- define custom text to show
- define custom colours

# Installation

```sh
ya pkg add AminurAlam/yazi-plugins:font-sample
```

# Dependencies

- [imagemagick](https://repology.org/project/imagemagick/versions) - for generating images

# Usage

in `~/.config/yazi/yazi.toml`

```toml
plugin.prepend_previewers = [
  { mime = 'font/*', run = 'font-sample' },
  { mime = 'application/ms-opentype', run = 'font-sample' },
  { url = '*.{otf,ttf,woff,woff2}', run = 'font-sample' },
]
plugin.prepend_preloaders = [
  { mime = 'font/*', run = 'font-sample' },
  { mime = 'application/ms-opentype', run = 'font-sample' },
  { url = '*.{otf,ttf,woff,woff2}', run = 'font-sample' },
]
```

in `~/.config/yazi/init.lua`

```lua
-- default config
require('font-sample'):setup {
  text = 'ABCDEF abcdef\n0123456789 \noO08 iIlL1 g9qCGQ\n8%& <([{}])>\n.,;: @#$-_="\n== <= >= != ffi\nâéùïøçÃĒÆœ\n및개요これ直楽糸',
  canvas_size = '750x800',
  font_size = 80,
  -- https://imagemagick.org/script/color.php
  bg = 'white',
  fg = 'black',
}
```
