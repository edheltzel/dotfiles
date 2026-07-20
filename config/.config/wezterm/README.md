# WezTerm Configuration

Modular WezTerm config using the (Eldritch)[https://github.com/eldritch-theme/eldritch] color scheme with pill-shaped tabs, process icons, project-based tab colors, and a git-aware status bar.

## File Structure

| File                | Purpose                                                                         |
| ------------------- | ------------------------------------------------------------------------------- |
| `wezterm.lua`       | Orchestrator — wires all modules together                                       |
| `theme.lua`         | Color palette, tab bar colors, process icons, shared `basename()` helper        |
| `configuration.lua` | Config settings: shell, font, rendering, window, panes, tab bar                 |
| `keymaps.lua`       | Leader key, key bindings, key tables                                            |
| `tabs.lua`          | Pill-shaped tabs, project colors, unseen output                                 |
| `statusbar.lua`     | Left/right status bar: workspace, CWD, git branch, command (dynamic icon), time |
| `workspaces.lua`    | Startup workspace layouts via `gui-startup` event                               |

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

Leader key: **Cmd+K** (1.5s timeout). `LDR` = the leader chord.

### Panes

| Keys                  | Action                                        |
| --------------------- | --------------------------------------------- |
| `LDR -`               | Split down (vertical split)                   |
| `LDR \`               | Split right (horizontal split)                |
| `LDR h/j/l/u`         | Split left / down / right / up                |
| `LDR x`               | Close pane                                    |
| `LDR =`               | Maximize / toggle pane zoom                   |
| `LDR r`               | Resize mode (`h/j/k/l`, `Esc`/`Enter` to exit) |
| `LDR d`               | Detach domain (tmux -CC)                       |
| `Cmd+]` / `Cmd+[`     | Next / previous pane                          |
| `Cmd+Ctrl+=`          | Close pane                                    |
| `Cmd+Ctrl+Alt+\` / `-`| Split right / down (Ghostty-style)            |
| `Cmd+Ctrl+Alt+z`      | Toggle pane zoom                              |

### Tabs

| Keys                  | Action                                  |
| --------------------- | --------------------------------------- |
| `LDR t`               | New tab                                 |
| `Cmd+K 1-9` / `Cmd+1-9` | Jump to tab                           |
| `LDR e`               | Rename tab                              |
| `LDR T`               | Tab navigator                          |
| `LDR m`               | Move-tab mode (`h/l`, `Esc`/`Enter`)   |
| `Cmd+Ctrl+Alt+h` / `l`| Previous / next tab                    |
| `Cmd+Shift+[` / `]`   | Previous / next tab (WezTerm default)  |

### Workspaces

| Keys             | Action                            |
| ---------------- | --------------------------------- |
| `LDR w`          | Switch workspace (fuzzy launcher) |
| `LDR W`          | Create workspace (prompt)         |
| `LDR E`          | Rename workspace                  |
| `Cmd+Ctrl+Alt+j` | Next workspace                    |
| `Cmd+Ctrl+Alt+k` | Previous workspace                |

### Zen Mode

| Keys     | Action                              |
| -------- | ----------------------------------- |
| `LDR z`  | Toggle zen mode (current window)    |
| `LDR Z`  | Spawn dedicated zen window          |

### fzf.fish Integration

| Keys         | Action            |
| ------------ | ----------------- |
| `Cmd+Ctrl+F` | Search directory  |
| `Cmd+Ctrl+L` | Search git log    |
| `Cmd+Ctrl+S` | Search git status |
| `Cmd+Ctrl+R` | Search history    |
| `Cmd+Ctrl+P` | Search processes  |
| `Cmd+Ctrl+V` | Search variables  |

### AI Agent Toggles

Sent as `Ctrl+Alt` chords (survive tmux). Bound to `Cmd+Ctrl+Alt`:

| Keys             | Action             |
| ---------------- | ------------------ |
| `Cmd+Ctrl+Alt+C` | Toggle Claude Code |
| `Cmd+Ctrl+Alt+O` | Toggle OpenCode    |
| `Cmd+Ctrl+Alt+P` | Toggle Pi          |

### Other

| Keys                  | Action                               |
| --------------------- | ------------------------------------ |
| `LDR p` / `LDR Space` | Command palette                      |
| `LDR k`               | Clear screen / scrollback            |
| `LDR n`               | New window                           |
| `LDR c`               | Copy mode                            |
| `LDR B`               | Debug overlay                        |
| `Cmd+Shift+W`         | Quit application                     |
| `Cmd+Ctrl+Alt+,`      | Reload configuration                 |

## Status Bar

**Left:** Active workspace name (or active key table / leader indicator)

**Right:** CWD folder, git branch (cached per directory), running command,
and tab/pane/workspace totals

When `herdr` is the active foreground process, the status bar uses a cached
`herdr api snapshot` instead of WezTerm's native topology. The left side shows
the active Herdr workspace; the right side shows the active Herdr pane's current
directory and git branch, plus the active tab and pane labels with totals. Native
WezTerm state returns automatically when Herdr exits or its API is unavailable.
