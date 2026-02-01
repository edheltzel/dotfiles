# WezTerm Configuration

Modular WezTerm config using the Eldritch color scheme with pill-shaped tabs, process icons, project-based tab colors, and a git-aware status bar.

## File Structure

| File | Purpose |
|------|---------|
| `wezterm.lua` | Orchestrator — wires all modules together |
| `theme.lua` | Color palette, tab bar colors, process icons, shared `basename()` helper |
| `configuration.lua` | Config settings: shell, font, rendering, window, panes, tab bar |
| `keymaps.lua` | Leader key, key bindings, key tables |
| `tabs.lua` | Pill-shaped tabs, project colors, unseen output |
| `statusbar.lua` | Left/right status bar: workspace, CWD, git branch, command (dynamic icon), time |
| `workspaces.lua` | Startup workspace layouts via `gui-startup` event |

## Customization

### Switching Themes

Edit `theme.lua` and change `M.name`:

```lua
M.name = "Eldritch"        -- default
M.name = "rose-pine"       -- dark
M.name = "rose-pine-moon"  -- dark variant
M.name = "rose-pine-dawn"  -- light
```

All accent colors and tab bar colors update automatically.

### Project Tab Colors

Tabs are colored by directory name. Edit the `project_colors` table in `tabs.lua`:

```lua
local project_colors = {
  [".dotfiles"] = colors.cyan,
  neoed = colors.purple,
  atlas = colors.red,
  -- ["my-project"] = colors.pink,
}
```

Active project tabs use the color as background; inactive ones use it as text color.

### Process Icons

Tabs and the status bar command section both show icons for recognized processes. Add entries to `M.process_icons` in `theme.lua`:

```lua
M.process_icons = {
  nvim   = wezterm.nerdfonts.custom_vim,
  claude = wezterm.nerdfonts.fa_robot,
  -- ["my-tool"] = wezterm.nerdfonts.md_wrench,
}
```

> Node.js-based CLIs (e.g. `opencode`, `gemini`) are detected via pane title since `foreground_process_name` returns `node`.

## Key Bindings

Leader key: **Cmd+K** (1.5s timeout)

### Panes

| Keys | Action |
|------|--------|
| `LDR -` | Split down |
| `LDR \` | Split right |
| `LDR h/j/k/l/u` | Split left/down/clear/right/up |
| `LDR x` | Close pane |
| `LDR z` | Toggle zoom |
| `LDR r` | Resize mode (`h/j/k/l`, `Esc` to exit) |
| `Cmd+]` / `Cmd+[` | Next / previous pane |
| `Cmd+Ctrl+=` | Close pane |

### Tabs

| Keys | Action |
|------|--------|
| `LDR t` | New tab |
| `LDR 1-9` | Jump to tab |
| `LDR e` | Rename tab |
| `LDR T` | Tab navigator |
| `LDR m` | Move tab mode (`h/l`, `Esc` to exit) |
| `Cmd+Shift+]` / `[` | Next / previous tab |

### Workspaces

| Keys | Action |
|------|--------|
| `LDR s` | Switch workspace (fuzzy) |
| `LDR S` | Create workspace |
| `LDR E` | Rename workspace |
| `Ctrl+Cmd+N` | Next workspace |
| `Ctrl+Cmd+Alt+P` | Previous workspace |

### fzf.fish Integration

| Keys | Action |
|------|--------|
| `Cmd+Ctrl+F` | Search directory |
| `Cmd+Ctrl+L` | Search git log |
| `Cmd+Ctrl+S` | Search git status |
| `Cmd+Ctrl+R` | Search history |
| `Cmd+Ctrl+P` | Search processes |
| `Cmd+Ctrl+V` | Search variables |

### Other

| Keys | Action |
|------|--------|
| `LDR p` / `LDR Space` | Command palette |
| `LDR k` | Clear screen |
| `LDR n` | New window |
| `LDR c` | Copy mode |
| `LDR B` | Debug overlay |
| `Cmd+Shift+W` | Quit application (with confirmation) |
| `Cmd+Ctrl+F` | Toggle fullscreen |

## Status Bar

**Left:** Workspace name (or active key table / leader indicator)

**Right:** CWD folder, git branch (cached per directory), running command, clock
