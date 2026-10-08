# NEO.ED Lualine Theme

A colorscheme-adaptive lualine theme that automatically matches your Neovim colorscheme.

## Overview

NEO.ED is a custom lualine theme that detects your current colorscheme and loads matching color palettes, providing a consistent statusline appearance that adapts to your theme preferences.

## Architecture

The theme system consists of three layers:

### 1. Theme Engine (`neoed.lua`)
The core orchestrator that:
- Detects the current colorscheme via `vim.g.colors_name` or `LazyVim.opts("LazyVim").colorscheme` (fallback for startup)
- Routes to the appropriate color palette file
- Builds the lualine theme structure
- Returns both the theme (for mode colors) and helper colors (for custom components)

### 2. Color Palette Files
Separate files that define color palettes for each supported colorscheme:
- `eldritch.lua` - Eldritch theme (default fallback)
- `rose-pine.lua` - Rose Pine variants
- `catppuccin.lua` - Catppuccin flavors
- `vesper.lua` - Vesper theme

Each palette file exports a `get_colors(variant)` function that returns:
1. A standardized color table
2. Optional overrides (via `get_overrides(colors)` function)

### 3. Lualine Configuration (`lualine.lua`)
Uses the NEO.ED theme:
```lua
local neoEdTheme, neoEdColors = require("plugins.ui.lualine.neoed").setup()

-- Use theme for mode colors
options = {
  theme = neoEdTheme,
}

-- Use colors for custom component styling
{ 
  "filename",
  color = { fg = neoEdColors.fg, gui = "BOLD" }
}
```

## Supported Colorschemes

| Colorscheme | Variants |
|------------|----------|
| **eldritch** | `eldritch` |
| **rose-pine** | `rose-pine`, `rose-pine-moon`, `rose-pine-dawn` |
| **catppuccin** | `catppuccin-latte`, `catppuccin-frappe`, `catppuccin-macchiato`, `catppuccin-mocha` |
| **vesper** | `vesper` |
| **dracula** | `dracula` |
| **gruvbox** | `gruvbox` |

## Auto-refresh on Colorscheme Change

An autocmd in `lua/config/autocmds.lua` automatically refreshes lualine when you change colorschemes:

```lua
-- Listens for ColorScheme event
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    -- Clears cached modules
    -- Reloads lualine with new theme
  end,
})
```

**How it works:**
1. You change colorscheme: `:colorscheme tokyonight`
2. Autocmd fires and clears cached NEO.ED modules
3. Lualine reloads with fresh colors from the new colorscheme
4. Your statusline automatically matches the new theme

## Git Branch Dirty Indicator

The branch component changes color based on working tree status:

- **Gray** - Clean working tree
- **Red** - Has uncommitted changes (added, modified, or removed lines)

This uses `gitsigns` to detect changes, so gitsigns must be installed and active.

## Commands

### `:LualineRefresh`
Manually refresh the lualine theme to match the current colorscheme.

**When to use:**
- As a backup if auto-refresh fails
- After manually editing color palette files
- For troubleshooting

**Example:**
```vim
:colorscheme rose-pine-moon
:LualineRefresh
```

## Color Palette Structure

All palette files use a standardized structure with colors and an optional `get_overrides` function:

```lua
M.palettes = {
  ["{colorscheme-name}"] = {
    -- Required: Base color palette
    colors = {
      darker = "#hexcode",   -- Darkest background
      bg = "#hexcode",       -- Main background
      darkGray = "#hexcode", -- Highlight/selection background
      fg = "#hexcode",       -- Primary foreground
      gray = "#hexcode",     -- Secondary foreground
      green = "#hexcode",    -- Command mode accent
      blue = "#hexcode",     -- (Currently unused)
      purple = "#hexcode",   -- Visual mode accent
      red = "#hexcode",      -- Replace/terminal mode accent
      magenta = "#hexcode",  -- Insert mode accent
    },
    -- Optional: Override function that receives colors table
    -- This allows you to reference colors.* values in your overrides
    get_overrides = function(colors)
      return {
        replace = {
          a = { fg = colors.red, bg = colors.darker },
        },
      }
    end,
  },
}
```

## Customizing Colors

NEO.ED supports a three-tier override system for maximum flexibility:

### 1. Base Colors (Palette Files)

The foundation colors used to build the theme. Edit these in the palette files:

```lua
-- In tokyonight.lua
colors = {
  red = "#f7768e",  -- This red is used in replace & terminal modes
  -- ...
}
```

### 2. Per-Colorscheme Overrides (Palette Files)

Override specific theme parts for individual colorschemes using the `get_overrides` function. This function receives the colors table, allowing you to reference palette colors:

```lua
-- In tokyonight.lua
M.palettes = {
  ["tokyonight"] = {
    colors = { ... },
    -- Function receives colors, can reference colors.* values
    get_overrides = function(colors)
      return {
        -- Only for tokyonight: use colors from palette
        replace = {
          a = { fg = colors.red, bg = colors.darker },
        },
        -- Multiple modes can be overridden
        insert = {
          a = { fg = colors.bg, bg = colors.magenta },
        },
        terminal = {
          a = { fg = "#000000", bg = colors.red },
        },
      }
    end,
  },
}
```

**Benefits:**
- Reference colors from the palette (e.g., `colors.bg`, `colors.magenta`)
- Customize per-colorscheme without editing `neoed.lua`
- Supports partial overrides (only change what you need)
- Each variant can have its own overrides

### 3. Global Overrides (neoed.lua)

Apply overrides to ALL colorschemes. Edit `global_overrides` in `neoed.lua`:

```lua
-- In neoed.lua
local global_overrides = {
  terminal = {
    a = { fg = "#000000", bg = "#E50A69" },
  },
}
```

**When to use:**
- Force the same color across all colorschemes
- Quick global customization without editing every palette file
- Testing changes before committing to per-colorscheme overrides

### Override Priority (lowest to highest)

1. **Base colors** → Build initial theme
2. **Palette overrides** → Merge colorscheme-specific changes
3. **Global overrides** → Final layer, applies to everything

### Examples

**Example 1: Change tokyonight's replace mode using palette colors**

```lua
-- In tokyonight.lua
["tokyonight"] = {
  colors = { ... },
  get_overrides = function(colors)
    return {
      replace = { a = { fg = colors.bg, bg = colors.red } },
    }
  end,
}
```

**Example 2: Make all themes use the same terminal color**

```lua
-- In neoed.lua
local global_overrides = {
  terminal = {
    a = { bg = "#FF0000" },
  },
}
```

**Example 3: Mix palette colors and hex values**

```lua
get_overrides = function(colors)
  return {
    command = { a = { fg = "#00FF00", bg = colors.darker } },
    insert = { a = { fg = colors.bg, bg = colors.magenta } },
  }
end
```

## Adding a New Colorscheme

### Step 1: Create Color Palette File

Create `lua/plugins/ui/lualine/{colorscheme-name}.lua`:

```lua
---- {Colorscheme Name} color palettes for NEO.ED theme
-- {URL to colorscheme repo}

local M = {}

M.palettes = {
  ["{colorscheme-name}"] = {
    colors = {
      darker = "#hexcode",
      bg = "#hexcode",
      darkGray = "#hexcode",
      fg = "#hexcode",
      gray = "#hexcode",
      green = "#hexcode",
      blue = "#hexcode",
      purple = "#hexcode",
      red = "#hexcode",
      magenta = "#hexcode",
    },
    -- Optional: Add theme-specific overrides using palette colors
    -- get_overrides = function(colors)
    --   return {
    --     replace = { a = { fg = colors.red, bg = colors.darker } },
    --   }
    -- end,
  },
  -- Add variants if needed:
  ["{colorscheme-name}-variant"] = {
    colors = { ... },
  },
}

function M.get_colors(variant)
  variant = variant or "{colorscheme-name}"
  local palette = M.palettes[variant] or M.palettes["{colorscheme-name}"]
  local overrides = palette.get_overrides and palette.get_overrides(palette.colors) or nil
  return palette.colors, overrides
end

return M
```

### Step 2: Update Detection Logic

Edit `lua/plugins/ui/lualine/neoed.lua`:

```lua
-- In get_colors() function, add:
elseif colorscheme:match("^{colorscheme%-name}") then
  local new_scheme = require("plugins.ui.lualine.{colorscheme-name}")
  return new_scheme.get_colors(colorscheme)
```

### Step 3: Update Auto-refresh Autocmd

Edit `lua/config/autocmds.lua`:

```lua
-- In ColorScheme autocmd callback, add:
package.loaded["plugins.ui.lualine.{colorscheme-name}"] = nil
```

And in the `:LualineRefresh` command:

```lua
-- Add to cache clearing section:
package.loaded["plugins.ui.lualine.{colorscheme-name}"] = nil
```

### Step 4: Test

```vim
:colorscheme {colorscheme-name}
" Statusline should automatically adapt
" If not, try: :LualineRefresh
```

### Step 5: Update Documentation

Add the new colorscheme to:
- This README's "Supported Colorschemes" table
- `neoed.lua` header comment's "SUPPORTED COLORSCHEMES" list
- `CLAUDE.md` lualine theme section

## Troubleshooting

### Statusline doesn't update after changing colorscheme
1. Try `:LualineRefresh`
2. Check if autocmd exists: `:autocmd ColorScheme`
3. Check for errors: `:messages`

### Wrong colors showing
1. Verify colorscheme name matches: `:echo vim.g.colors_name`
2. Check if palette file exists for that colorscheme
3. Use `:LualineRefresh` to force reload

### Lualine uses wrong theme on startup
The theme engine checks colorscheme in this order:
1. `vim.g.colors_name` (set after colorscheme loads)
2. `LazyVim.opts("LazyVim").colorscheme` (from your config)
3. Falls back to `eldritch`

If startup detection fails, ensure your colorscheme is set in `lua/plugins/ui/colorscheme.lua`.

### Custom component colors not working
Ensure you're using `neoEdColors` not `neoEdTheme`:
```lua
-- Correct:
color = { fg = neoEdColors.fg }

-- Wrong:
color = { fg = neoEdTheme.fg }  -- neoEdTheme doesn't have .fg
```

## File Reference

```
lua/plugins/ui/lualine/
├── README.md              ← You are here
├── neoed.lua              ← Theme engine (main orchestrator)
├── eldritch.lua           ← Eldritch color palettes
├── rose-pine.lua          ← Rose Pine color palettes
├── catppuccin.lua         ← Catppuccin color palettes
├── vesper.lua             ← Vesper color palettes
├── dracula.lua            ← Dracula color palettes
└── gruvbox.lua            ← Gruvbox Dark color palettes
```

## Credits

Inspired by the modular theming approach and built for the NOE.ED Neovim configuration.
