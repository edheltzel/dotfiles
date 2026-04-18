# Plan: TMUX Statusbar with WezTerm Design Parity

## Context

Ed wants his TMUX statusbar to match his WezTerm design — same Eldritch colors, same data (CWD, git branch, command, session stats), same pill-shaped tabs, same leader indicator.

**Current state:** A `dots/.tmux.conf` already exists using the **gpakosz/.tmux framework**. It has:
- WezTerm-compatible keymaps (prefix `C-k`, splits, pane nav, resize mode, etc.) — lines 57-174
- gpakosz embedded shell script for theming (lines 197+) — this is the framework's theming engine
- Sources `.tmux.conf.local` for overrides (line 192), but no `.local` file exists

**Problem:** The gpakosz framework processes status-left/right through an awk pipeline that adds powerline separators between `|`-delimited segments. This fights against our custom Eldritch format strings.

## Recommended Approach: Replace gpakosz with standalone XDG config

Strip the gpakosz framework entirely. Extract Ed's custom keymaps, add the Eldritch statusbar, and place everything in `config/.config/tmux/tmux.conf` (XDG-compliant). Remove the old `dots/.tmux.conf`.

**Why this approach:**
- XDG compliance (matches repo philosophy — `config/.config/` for app configs)
- No framework fighting — direct tmux format strings, full control
- Modular: statusbar lives alongside other terminal configs (wezterm, ghostty, kitty)
- The gpakosz framework adds ~1500 lines of shell scripting we don't use (battery, uptime, username, hostname display) — dead weight

## What WezTerm Shows (the target)

### Left Status
```
  󱊅  <session_name> ⋮     (normal: purple icon + purple text)
  󱊅  󱐋 󱐋 ⋮               (prefix active: cyan lightning bolts)
  󱊅  resize_pane ⋮        (key table active: purple_alt text)
```

### Right Status (left to right, separated by ⋮)
```
󰉋  <cwd_basename>  ⋮   <git_branch>  ⋮   <command>  ⋮  󰓩 <windows>  󰤼 <panes>  󱊅 <sessions>
pink   white        sep  purple white  sep  cyan white sep  red2 stats...
```

### Tabs (pill-shaped, bottom bar)
```
 1: fish ~ ←active(green bg)   2: nvim project ←inactive(dark bg)
```

### Eldritch Color Palette
| Name | Hex | Usage |
|------|-----|-------|
| black | #171928 | Status bar bg, active tab fg |
| dark | #212337 | Inactive tab bg, pane border |
| red | #F16C75 | — |
| red2 | #AD4E54 | Session stat icons |
| purple | #A48CF2 | Session name, git branch icon |
| purple_alt | #7081D0 | Separators (⋮), inactive tab fg, stat values |
| cyan | #04D1F9 | Leader indicator, command icon |
| green | #37F499 | Active tab bg |
| yellow | #F7F67F | — |
| pink | #F265B5 | CWD folder icon |
| white | #EBFAFA | Text values |
| orange | #F7C67F | — |

## File Structure

```
config/.config/tmux/
├── tmux.conf              # Main config (general + keymaps + statusbar)
└── scripts/
    └── git-branch.sh      # Conditional git branch display (hides when not in repo)
```

**Remove:** `dots/.tmux.conf` (replaced by the XDG config)

## tmux.conf Structure (sections)

### 1. Terminal & Colors
```tmux
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",*256col*:Tc"
set -as terminal-features ",xterm-256color:RGB"
```

### 2. General Settings
Preserved from existing config:
- `base-index 1`, `pane-base-index 1`, `renumber-windows on`
- `escape-time 10`, `repeat-time 600`, `focus-events on`
- `history-limit 5000`, `mouse on`
- `status-interval 5` (git branch refresh)
- Fish shell: `set -g default-shell /opt/homebrew/bin/fish`

### 3. Keymaps (preserved from existing dots/.tmux.conf)
All existing keybindings carried over verbatim:
- Prefix: `C-k`
- Splits: `\`, `-`, `h/j/l/u` (Ghostty-style)
- Pane mgmt: `x` (close), `z/=` (zoom), arrows (navigate)
- Windows: `n/t` (new), `1-9` (jump), `C-h/C-l` (prev/next)
- Sessions: `s` (switch), `S` (create), `e/E` (rename)
- Key tables: `r` (resize_pane), `m` (move_tab)
- Copy mode: `c`, vi bindings, pbcopy

### 4. Status Bar — Left
```tmux
set -g status-left-length 60
set -g status-left " ... "
```
- Layers icon (󱊅) in purple
- Conditional: prefix → cyan lightning bolts; key table → purple_alt table name; default → purple session name
- Trailing ⋮ separator

### 5. Status Bar — Right
```tmux
set -g status-right-length 200
set -g status-right " ... "
```
- CWD basename (pink icon, white text) via `#(basename #{pane_current_path})`
- Git branch (conditional via `scripts/git-branch.sh`) — hidden when not in repo
- Current command (cyan icon, white text) via `#{pane_current_command}`
- Session stats: window count, pane count, session count

### 6. Window Format (pill tabs)
- Active: green bg (#37F499), dark fg — powerline half-circle glyphs
- Inactive: dark bg (#212337), purple_alt fg
- Format: `index: command name`
- Empty separator (pills handle spacing)

### 7. Pane Borders & Messages
- Border: dark (#212337), active border: purple (#A48CF2)
- Message style: dark bg, white fg

## git-branch.sh Script
Outputs ` ⋮ #[fg=#A48CF2] #[fg=#EBFAFA]<branch>` when in a git repo, empty string otherwise. tmux 3.2+ renders `#[...]` style tags from `#()` output.

## Migration Steps
1. Create `config/.config/tmux/` and `config/.config/tmux/scripts/`
2. Write `tmux.conf` with all sections above
3. Write `scripts/git-branch.sh` (make executable)
4. Remove `dots/.tmux.conf`
5. `just stow config` — symlinks `~/.config/tmux/tmux.conf`
6. tmux 3.2+ auto-reads `$XDG_CONFIG_HOME/tmux/tmux.conf` when `~/.tmux.conf` is absent
7. Update justfile `stow_packages` — remove need (config already listed, dots still valid for other files)

## Verification
1. `tmux source ~/.config/tmux/tmux.conf` — no errors
2. Left status shows session name with icon
3. Press prefix (C-k) — left status shows lightning bolts
4. Right status shows CWD basename
5. `cd` to a git repo — git branch appears
6. `cd` to non-git dir — git section hidden
7. Active tab is green pill, inactive is dark pill
8. Session stats (windows, panes, sessions) update correctly
9. All existing keybindings still work
