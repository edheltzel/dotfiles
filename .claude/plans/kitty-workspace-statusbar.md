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

### Data Access Strategy

Use `get_boss()` from `kitty.boss` to access CWD and process info directly — no IPC or subprocess needed for these:

```python
from kitty.boss import get_boss

def _get_active_window_data():
    boss = get_boss()
    if boss is None:
        return "", ""
    tab = boss.active_tab
    if tab is None:
        return "", ""
    w = tab.active_window
    if w is None:
        return "", ""
    cwd = w.cwd_of_child or ""
    # Get foreground process name from child process info
    procs = w.child.foreground_processes
    exe = procs[0]["cmdline"][0] if procs else ""
    return cwd, os.path.basename(exe)
```

### Git Branch Caching Strategy

**Critical: Never call `subprocess` directly in `draw_tab()`** — it blocks the entire kitty UI.

Two-tier approach:
1. **Module-level cache** keyed by CWD path (same pattern as WezTerm's `statusbar.lua:34-47`)
2. **`subprocess.run` with 100ms timeout** — only called when CWD changes (not every redraw)
3. **`add_timer`** from `kitty.fast_data_types` to periodically mark the tab bar dirty (refresh every 2s)

```python
from kitty.fast_data_types import add_timer

_git_cache = {}  # {cwd_path: branch_name}
_timer_id = None

def _redraw_tab_bar(timer_id):
    for tm in get_boss().os_window_map.values():
        tm.mark_tab_bar_dirty()
```

The cache is only invalidated when CWD changes (detected via `get_boss()` on each draw). This mirrors WezTerm's approach exactly.

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

**Function signature:**
```python
def draw_tab(
    draw_data: DrawData,    # Colors, templates, padding config
    screen: Screen,          # Drawing surface (cursor.x/fg/bg, draw(), columns)
    tab: TabBarData,         # Tab data (title, is_active, num_windows, layout_name, tab_id)
    before: int,             # Cursor x position before this tab
    max_title_length: int,
    index: int,              # 1-based tab index
    is_last: bool,
    extra_data: ExtraData,   # prev_tab, next_tab, layout_only flag
) -> int:                    # Must return ending cursor x position
```

**Key imports:**
```python
from kitty.fast_data_types import Screen, add_timer, get_options
from kitty.tab_bar import DrawData, ExtraData, TabBarData, draw_tab_with_powerline, as_rgb
from kitty.boss import get_boss
from kitty.utils import color_as_int
```

**Drawing pattern:**
- Delegate tab rendering to `draw_tab_with_powerline()` (handles pill shapes natively with `tab_powerline_style round`)
- When `is_last == True`, position cursor to right edge and draw status segments
- Use `screen.cursor.fg = as_rgb(color_as_int(Color(...)))` for setting colors
- `extra_data.layout_only` — when True, skip expensive operations (performance flag)

**Right-aligned status positioning:**
```python
if is_last:
    status_text = " CWD | branch | process "
    screen.cursor.x = screen.columns - len(status_text)
    screen.draw(status_text)
```

### File

`config/.config/kitty/tab_bar.py`

---

## 2. Sessions & Workspaces

### Architecture

Kitty has a full session system that supports both startup layouts AND runtime switching via `goto_session`. This is kitty's native equivalent to WezTerm workspaces.

**Key concepts:**
- Session files use `.kitty-session` extension (also `.kitty_session`, `.session`)
- `startup_session` loads on launch
- `goto_session` switches sessions at runtime (creates new OS window context per session)
- `save_as_session` captures current state to a file
- `tab_bar_filter session:~` scopes the tab bar to the active session only

### Session File Format

18 supported directives. Key ones for workspace layouts:

| Directive | Purpose |
|-----------|---------|
| `new_tab [title]` | Create a new tab |
| `layout <name>` | Set layout (splits, tall, stack, etc.) |
| `enabled_layouts <list>` | Allowed layouts for the tab |
| `cd <path>` | Working directory (env vars expanded: `$HOME`, `${PROJECT}`) |
| `launch [opts] [cmd]` | Create window/pane (`--location=vsplit/hsplit`, `--title`, `--cwd`, `--env`) |
| `focus` | Focus a window |
| `focus_tab <spec>` | Focus tab by index or match expression |

### Session Files

#### Default Startup — `config/.config/kitty/sessions/default.kitty-session`

```
# Default workspace: single tab, fish shell
new_tab
enabled_layouts splits,tall,stack
layout splits
cd ~
launch --cwd=current
```

#### Dotfiles — `config/.config/kitty/sessions/dotfiles.kitty-session`

Matches WezTerm's `workspaces.lua` 3-pane split layout:

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
enabled_layouts splits,tall,stack
layout splits
cd ~/.dotfiles
launch --cwd=current
launch --location=vsplit --cwd=current
launch --location=hsplit --cwd=current
```

#### Combined Startup — `config/.config/kitty/sessions/startup.kitty-session`

```
# Tab 1: Default shell
new_tab
enabled_layouts splits,tall,stack
layout splits
cd ~
launch --cwd=current

# Tab 2: Dotfiles (3-pane split)
new_tab dotfiles
enabled_layouts splits,tall,stack
layout splits
cd ~/.dotfiles
launch --cwd=current
launch --location=vsplit --cwd=current
launch --location=hsplit --cwd=current

# Focus first tab
focus_tab 0
```

### Config Changes

Add to `kitty.conf`:

```conf
startup_session sessions/startup.kitty-session
```

### Runtime Session Switching (WezTerm Workspace Parity)

`goto_session` is the direct equivalent of WezTerm's `SwitchToWorkspace` / `ShowLauncherArgs{WORKSPACES}`:

```conf
# Browse all session files in a directory (fuzzy selection)
map cmd+k>s goto_session ~/.config/kitty/sessions

# Jump to specific sessions directly
map cmd+k>S goto_session ~/.config/kitty/sessions/dotfiles.kitty-session

# Toggle to previous session (like alt-tab for workspaces)
map cmd+ctrl+alt+[ goto_session -1
map cmd+ctrl+alt+] goto_session -1
```

When `goto_session` is called with a directory path, kitty scans for `*.kitty-session` files and presents an interactive selection list — functionally identical to WezTerm's fuzzy workspace switcher.

### Save Current State

```conf
# Save current layout as a session file for future use
map cmd+k>W save_as_session --use-foreground-process --base-dir ~/.config/kitty/sessions
```

### Tab Bar Session Filtering

Scope the tab bar to only show tabs from the active session:

```conf
tab_bar_filter session:~ or session:^$
```

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
| `cmd+k s` | Switch workspace (fuzzy) | Not mapped | **Missing** | Add: `goto_session ~/.config/kitty/sessions` (fuzzy session browser) |
| `cmd+k S` | Create workspace | Not mapped | **Missing** | Add: `goto_session` to a specific session, or `save_as_session` |
| `cmd+k E` | Rename workspace | Not mapped | **N/A** | Kitty sessions don't have a rename action |
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
| `cmd+ctrl+alt+[` | Previous workspace | Not mapped | **Missing** | Add: `goto_session -1` (toggle previous session) |
| `cmd+ctrl+alt+]` | Next workspace | Not mapped | **Missing** | Add: `goto_session -1` (toggle previous session) |

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
| `config/.config/kitty/kitty.conf` | Add `startup_session sessions/startup.kitty-session` |
| `config/.config/kitty/layout.conf` | `tab_bar_edge bottom`, `tab_bar_style custom`, `tab_bar_min_tabs 1` |
| `config/.config/kitty/keymaps.conf` | Add missing bindings, fix mismatches, add `goto_session` mappings |

### New Files

| File | Purpose |
|------|---------|
| `config/.config/kitty/tab_bar.py` | Custom tab bar with status area (CWD, git branch, process) |
| `config/.config/kitty/sessions/startup.kitty-session` | Combined startup layout (default + dotfiles tabs) |
| `config/.config/kitty/sessions/default.kitty-session` | Default single-tab session (for `goto_session`) |
| `config/.config/kitty/sessions/dotfiles.kitty-session` | Dotfiles 3-pane session (for `goto_session`) |

---

## 6. Implementation Order

1. **Tab bar position + style** — `tab_bar_edge bottom`, `tab_bar_style custom`, `tab_bar_min_tabs 1` in `layout.conf`
2. **`tab_bar.py`** — Custom tab bar: pill tabs + right-aligned status (CWD, git branch, process icon)
3. **Session files** — Create `sessions/` directory with startup, default, and dotfiles sessions
4. **Config update** — Add `startup_session` to `kitty.conf`
5. **Keymap audit** — Add missing bindings, fix mismatches, add `goto_session` + `save_as_session` mappings
6. **Test** — Reload config (`cmd+ctrl+alt+,`) and verify all features

---

## 7. Known Limitations vs WezTerm

| Feature | WezTerm | Kitty | Gap |
|---------|---------|-------|-----|
| Workspaces (runtime) | Named workspaces in single OS window | `goto_session` — sessions per OS window | **Parity** — different model, same UX. Kitty also adds `save_as_session` and `goto_session -1` (previous) |
| Leader indicator | Visual feedback in status bar | Not possible | Key table state not exposed to tab bar |
| Modal resize | Key table with h/j/k/l + Escape | Direct keybindings only | Use `cmd+ctrl+alt` modifiers instead |
| Directional splits | Left/Right/Up/Down | vsplit/hsplit only | Splits relative to active pane |
| Copy mode | Built-in Vim-like mode | `show_scrollback` (pager) | Different UX, same goal |
| Zen mode | Custom padding + tab bar hide | Stack layout (zoom only) | No padding control at runtime |
| Tab move mode | Modal h/j/k/l | Direct forward/backward | Simpler but functional |

### Kitty Advantages Over WezTerm

| Feature | Detail |
|---------|--------|
| `save_as_session` | Capture current state (all windows, tabs, processes, SSH) to a session file |
| `goto_session -1` | Toggle to previous session (WezTerm has no built-in equivalent) |
| `tab_bar_filter` | Scope tab bar to active session only |
| Session file directory browsing | `goto_session <dir>` scans for `*.kitty-session` and presents selection |
