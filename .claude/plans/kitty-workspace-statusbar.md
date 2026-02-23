# PRD: Kitty Workspace, Statusbar & Keymap Parity

## Goal

Bring kitty's configuration to feature parity with the existing WezTerm setup in three areas:

1. **Custom status bar** — CWD, git branch, and process name/icon in the tab bar
2. **Startup sessions** — Named workspace-style layouts (matching WezTerm's `workspaces.lua`)
3. **Keymap parity** — Match WezTerm's `cmd+k` leader key bindings
4. **Tab bar position** — Move to bottom

---

## Scope

### In Scope

- Custom `tab_bar.py` with status area (CWD, git branch, process icon)
- Startup session file with default + dotfiles workspace layouts
- Full keymap audit and alignment with WezTerm bindings
- Tab bar moved to bottom
- Eldritch theme colors in the custom tab bar

### Out of Scope (per user request)

- Workspace/tab/pane counts in the status bar
- Runtime workspace switching (kitty has no native workspace concept)
- Leader key active indicator (kitty doesn't expose key table state to tab bar)
- Zen mode (would require a separate kitten — defer to future work)
- Copy mode (kitty has `scrollback_pager` instead — different paradigm)

---

## 1. Custom Status Bar (`tab_bar.py`)

### Architecture

Create `config/.config/kitty/tab_bar.py` using `tab_bar_style custom`.

Kitty's custom tab bar API calls `draw_tab()` for each tab. We override this to:
- Draw tabs in the center/left area (pill-shaped, matching WezTerm's `tabs.lua`)
- Draw a **right-aligned status area** after the last tab with: CWD, git branch, process name

### Status Bar Content (matches WezTerm's `statusbar.lua` minus counts)

| Segment | Data Source | Color (Eldritch) | Icon |
|---------|-------------|-------------------|------|
| CWD (basename) | `tab.active_wd` | pink `#F265B5` | `  ` (folder) |
| Git branch | `subprocess.run(["git", ...])` cached | purple `#A48CF2` | ` ` (git branch) |
| Process name | `tab.active_exe` via `foreground_processes` | cyan `#04D1F9` | dynamic per-process |

### Git Branch Caching Strategy

- Cache git branch per CWD path (same pattern as WezTerm's `statusbar.lua:34-47`)
- Only re-query `git -C <path> branch --show-current` when CWD changes
- Use module-level dict: `_git_cache = {"cwd": "", "branch": ""}`

### Process Icon Mapping

Port WezTerm's `theme.lua` `process_icons` table to Python dict using the same Nerd Font codepoints:

```python
PROCESS_ICONS = {
    "nvim": "\ue62b",    # custom_vim
    "fish": "\U000f0f31", # md_fish
    "git": "\ue725",      # dev_git
    "node": "\U000f0399", # md_nodejs
    "python": "\ue73c",   # dev_python
    # ... etc
}
```

### Tab Rendering

- Pill-shaped tabs (left/right half-circle using Nerd Font `ple_left_half_circle_thick` / `ple_right_half_circle_thick`)
- Active tab: green bg `#37F499`, dark fg `#171928`
- Inactive tab: dark bg `#212337`, muted fg `#7081D0`
- Unseen output indicator: yellow fg `#F7F67F`

### Implementation Notes

- `draw_tab()` signature: `draw_tab(draw_data, screen, tab, before, max_title_length, index, is_last, extra_data)`
- `extra_data` dict contains: `next_tab`, `prev_tab`, `num_tabs`, `max_title_length`
- Use `screen.cursor.x`, `screen.cursor.fg`, `screen.cursor.bg` for drawing
- Right-align status by calculating: `screen.columns - status_length` on the last tab
- `tab.active_wd` gives CWD, `tab.active_exe` gives the foreground process

### File

`config/.config/kitty/tab_bar.py`

---

## 2. Startup Sessions

### Architecture

Create session files that kitty loads via `startup_session` config option.

### Session: Default

File: `config/.config/kitty/sessions/default.session`

```
# Default workspace: single tab, fish shell
new_tab default
layout splits
cd ~
launch --cwd=current
focus
```

### Session: Dotfiles (matches WezTerm's `workspaces.lua` layout)

```
# Dotfiles workspace: 3-pane split layout
#   ┌────────────┬────────────┐
#   │            │   right    │
#   │   main     │    top     │
#   │            ├────────────┤
#   │            │   right    │
#   │            │   bottom   │
#   └────────────┴────────────┘

new_tab dotfiles
layout splits
cd ~/.dotfiles
launch --cwd=current
launch --location=vsplit --cwd=current
launch --location=hsplit --cwd=current
# Focus back to the main (left) pane
focus_matching_window id:0
```

### Session: Combined Startup

File: `config/.config/kitty/sessions/startup.session`

Combines both layouts into a single session file (kitty supports multiple `new_tab` directives):

```
# Tab 1: Default shell
new_tab
layout splits
cd ~
launch --cwd=current

# Tab 2: Dotfiles (3-pane split)
new_tab dotfiles
layout splits
cd ~/.dotfiles
launch --cwd=current
launch --location=vsplit --cwd=current
launch --location=hsplit --cwd=current
```

### Config Change

Add to `kitty.conf`:

```conf
startup_session sessions/startup.session
```

### Runtime Session Loading

Kitty doesn't have WezTerm-style runtime workspace switching, but sessions can be loaded into a running instance via:

```bash
kitty @ launch --type=tab --tab-title="dotfiles" --cwd=~/.dotfiles
```

A fish function or kitten could provide fuzzy session selection (future enhancement).

---

## 3. Keymap Parity Audit

### WezTerm → Kitty Mapping

Below is a complete audit of WezTerm's `keymaps.lua` vs kitty's `keymaps.conf`.

#### Leader Key Bindings (`cmd+k > ...`)

| Binding | WezTerm Action | Kitty Current | Status | Notes |
|---------|---------------|---------------|--------|-------|
| `cmd+k k` | Clear screen (Ctrl+C, Ctrl+L) | `clear_terminal scroll active` | **Match** | Slightly different (kitty clears scrollback only) |
| `cmd+k n` | New OS window | `new_window_with_cwd` | **Mismatch** | Kitty creates a pane, not OS window. Change to `new_os_window_with_cwd` |
| `cmd+k t` | New tab (current domain) | `new_tab_with_cwd` | **Match** | |
| `cmd+k x` | Close pane/tab (no confirm) | `close_window` | **Match** | Kitty `close_window` = close pane |
| `cmd+k -` | Split vertical (hsplit) | `launch --location=hsplit --cwd=current` | **Match** | |
| `cmd+k \` | Split horizontal (vsplit) | `launch --location=vsplit --cwd=current` | **Match** | |
| `cmd+k z` | Toggle zen mode | `toggle_layout stack` | **Approximate** | Stack layout = zoom; no padding. Acceptable |
| `cmd+k =` | Toggle pane zoom | `resize_window reset` | **Mismatch** | Should be `toggle_layout stack` for zoom parity |
| `cmd+k h` | Split left | Not mapped | **Missing** | Add: `launch --location=vsplit --cwd=current` (kitty splits relative to active) |
| `cmd+k l` | Split right | Not mapped | **Missing** | Add: `launch --location=vsplit --cwd=current` |
| `cmd+k j` | Split down | Not mapped | **Missing** | Add: `launch --location=hsplit --cwd=current` |
| `cmd+k u` | Split up | Not mapped | **Missing** | Add: `launch --location=hsplit --cwd=current` (limited — kitty splits don't support directional) |
| `cmd+k c` | Copy mode | Not mapped | **Missing** | Add: `show_scrollback` (kitty's equivalent — opens scrollback in pager) |
| `cmd+k r` | Resize mode (h/j/k/l) | Not mapped | **Missing** | Kitty has no modal resize. Map individual resize keys |
| `cmd+k m` | Move tab mode | Not mapped | **Missing** | Add: `move_tab_forward` / `move_tab_backward` individual bindings |
| `cmd+k e` | Rename tab | `set_tab_title` | **Match** | |
| `cmd+k s` | Switch workspace (fuzzy) | Not mapped | **N/A** | No workspace concept. Could map to tab switcher |
| `cmd+k S` | Create workspace | Not mapped | **N/A** | No workspace concept |
| `cmd+k E` | Rename workspace | Not mapped | **N/A** | No workspace concept |
| `cmd+k p` | Command palette | `kitty_shell window` | **Match** | Kitty shell serves as command palette |
| `cmd+k space` | Command palette | Not mapped | **Missing** | Add as alias for `kitty_shell window` |
| `cmd+k B` | Debug overlay | Not mapped | **Missing** | Add: `debug_config` or skip |
| `cmd+k 1-9` | Jump to tab N | `goto_tab N` | **Match** | |

#### Non-Leader Bindings

| Binding | WezTerm Action | Kitty Current | Status | Notes |
|---------|---------------|---------------|--------|-------|
| `cmd+]` | Next pane | `next_window` | **Match** | |
| `cmd+[` | Previous pane | `previous_window` | **Match** | |
| `cmd+n` | New OS window | `new_os_window` | **Match** | |
| `cmd+t` | New tab | `new_tab` | **Match** (system default) | |
| `cmd+w` | Close tab | `close_tab` | **Match** | |
| `cmd+ctrl+alt+h` | Previous tab | `kitty_mod+]` → `next_tab` | **Mismatch** | Remap to match |
| `cmd+ctrl+alt+l` | Next tab | `kitty_mod+[` → `prev_tab` | **Mismatch** | Remap to match |
| `cmd+ctrl+alt+\` | Split right | Not mapped | **Missing** | Add |
| `cmd+ctrl+alt+-` | Split down | Not mapped | **Missing** | Add |
| `cmd+ctrl+alt+z` | Toggle zoom | Not mapped | **Missing** | Add: `toggle_layout stack` |
| `cmd+ctrl+alt+,` | Reload config | Not mapped | **Missing** | Add: `load_config_file` |
| `cmd+ctrl+f` | fzf: Directory | Mapped | **Match** | |
| `cmd+ctrl+l` | fzf: Git Log | Mapped | **Match** | |
| `cmd+ctrl+s` | fzf: Git Status | Mapped | **Match** | |
| `cmd+ctrl+r` | fzf: History | Mapped | **Match** | |
| `cmd+ctrl+p` | fzf: Processes | Mapped | **Match** | |
| `cmd+ctrl+v` | fzf: Variables | Mapped | **Match** | |
| `cmd+shift+=` | Increase font | Mapped | **Match** | |
| `cmd+shift+-` | Decrease font | Mapped | **Match** | |
| `ctrl+shift+L/U` | Disabled (Neovim passthrough) | Not disabled | **Missing** | Add `no_op` |

### Resize Keybindings

Kitty doesn't have modal key tables like WezTerm's `resize_pane` mode. Two options:

**Option A: Direct bindings (recommended)**
Map resize to `cmd+ctrl+alt+{h,j,k,l}` since they're currently commented out in WezTerm:
```conf
map cmd+ctrl+alt+h resize_window wider 5
map cmd+ctrl+alt+j resize_window shorter 3
map cmd+ctrl+alt+k resize_window taller 3
map cmd+ctrl+alt+l resize_window narrower 5
```

**Option B: Resize via kitty_mod** (already partially present)
Already mapped at `keymaps.conf:42-45`. Keep as-is.

### Split Direction Limitations

Kitty's `splits` layout supports `--location=vsplit` and `--location=hsplit` but does NOT support directional splits (left, right, up, down) like WezTerm. The split always occurs relative to the active pane:
- `vsplit` = split to the right
- `hsplit` = split below

For `cmd+k h` (split left) and `cmd+k u` (split up), the closest approximation is:
- Split, then move focus — but kitty doesn't have `move_window` to swap positions easily
- Recommended: map `h` and `l` both to `vsplit`, `j` and `u` both to `hsplit`, and document the limitation

---

## 4. Tab Bar Position

### Change

In `layout.conf`, change:

```conf
tab_bar_edge top
```

to:

```conf
tab_bar_edge bottom
```

This matches WezTerm's `tab_bar_at_bottom = true` from `configuration.lua:64`.

---

## 5. Config Changes Summary

### Modified Files

| File | Changes |
|------|---------|
| `config/.config/kitty/kitty.conf` | Add `startup_session sessions/startup.session` |
| `config/.config/kitty/layout.conf` | `tab_bar_edge bottom`, `tab_bar_style custom` |
| `config/.config/kitty/keymaps.conf` | Add missing bindings, fix mismatches per audit above |

### New Files

| File | Purpose |
|------|---------|
| `config/.config/kitty/tab_bar.py` | Custom tab bar with status area (CWD, git branch, process) |
| `config/.config/kitty/sessions/startup.session` | Multi-tab startup layout |

---

## 6. Implementation Order

1. **Tab bar position** — Move to bottom in `layout.conf` (trivial)
2. **Tab bar style** — Switch to `tab_bar_style custom` in `layout.conf`
3. **`tab_bar.py`** — Custom tab bar with pill tabs + right-aligned status (CWD, git, process)
4. **Startup session** — Create session file + add `startup_session` to config
5. **Keymap audit** — Add missing bindings, fix mismatches in `keymaps.conf`
6. **Test** — Verify with `kitty --config` or reload

---

## 7. Known Limitations vs WezTerm

| Feature | WezTerm | Kitty | Gap |
|---------|---------|-------|-----|
| Workspaces (runtime) | Full fuzzy switching | No equivalent | Sessions are startup-only |
| Leader indicator | Visual feedback in status bar | Not possible | Key table state not exposed to tab bar |
| Modal resize | Key table with h/j/k/l + Escape | Direct keybindings only | Use `cmd+ctrl+alt` modifiers instead |
| Directional splits | Left/Right/Up/Down | vsplit/hsplit only | Splits relative to active pane |
| Copy mode | Built-in Vim-like mode | `show_scrollback` (pager) | Different UX, same goal |
| Zen mode | Custom padding + tab bar hide | Stack layout (zoom only) | No padding control at runtime |
| Tab move mode | Modal h/j/k/l | Direct forward/backward | Simpler but functional |
