# WezTerm Performance & Lua Code Quality

**Date:** 2026-04-15 (revised 2026-04-16)
**Target:** `config/.config/wezterm/` (7 Lua files, ~550 lines)
**Guiding principle:** Feature preservation > marginal optimization. Optimize the **code**, not the feature set.

## Status Update (What the Measurements Showed)

Before rewriting this plan, we actually measured instead of assuming. Results:

| Process | RSS | Notes |
|---------|-----|-------|
| **WezTerm** (1 proc) | **240.6 MB** | Not the problem |
| **Claude Code** (4 procs) | **1,163 MB** (avg 290 MB each) | The real weight |
| **Orphaned node** (PPID=1) | **0 procs** | Clean — no MCP leak right now |
| All node processes | 335.8 MB (4 procs) | Normal for active MCP servers |

**Verdict:** WezTerm is fine. The memory Ed is seeing is Claude Code sessions doing real work (1M context, MCP servers, hooks). The config isn't broken.

**Revised goal:** Don't remove features for a few percent of RAM. Instead:
- **(A) Apply safe config-only wins** (no feature loss)
- **(B) Improve the Lua code itself** — every handler tick becomes faster without changing behavior
- **(C) Add operational hygiene** for Claude Code to prevent known upstream leaks from compounding

## Research Basis

Three parallel sub-agents researched current (2025–2026) best practices:
1. **Lua 5.4 idioms** (WezTerm uses Lua 5.4 via `mlua`, not LuaJIT — interpreter-focused optimizations apply)
2. **WezTerm Lua API** (what's cheap, what's expensive, idiomatic patterns)
3. **Claude Code resource footprint** (per-session ~290 MB, known MCP orphan bug, no config fix)

Findings in this plan are cross-referenced with official docs (wezterm.org), GitHub issues, and the actual code.

---

## Phase A — Safe Config-Only Wins (No Feature Loss)

Single file: `config/.config/wezterm/configuration.lua`. These are pure knob tweaks, no behavior change beyond what's noted.

### A1. `max_fps = 240` → `120`
**Line:** `configuration.lua:46`
**Why:** Apple ProMotion caps at 120 Hz. 240 is render work for frames that cannot display.
**Feature impact:** None — visible frame rate unchanged.

### A2. `scrollback_lines = 10000` → `5000`
**Line:** `configuration.lua:51`
**Why:** Default is 3500. Ed previously said he understands this one; keeping 5000 preserves deep history while cutting per-tab RAM by half vs 10000.
**Feature impact:** Less scrollback history. If Ed actively uses 10k of history, leave at 10000.

### A3. `macos_window_background_blur = 25` → `0`
**Line:** `configuration.lua:52`
**Why:** `window_background_opacity = 1` makes the blur invisible. Blur pass is computed but never seen.
**Feature impact:** Zero (blur is invisible with opaque window).

### A4. (Optional) `status_update_interval = 1000` → `2000`
**Line:** `configuration.lua:65`
**Why:** Halves all per-tick status bar work. Status bar still updates, just every 2s instead of 1s.
**Feature impact:** Numbers update every 2s. Barely perceptible for tabs/panes/branch which rarely change that fast.

### Deferred (by Ed's feedback)
- **`webgpu_power_preference`** — Apple Silicon has one GPU; the setting is cosmetic. Skip unless Ed wants semantic cleanliness.
- **Cursor blinking** — Keeping `BlinkingBar`; the idle repaint cost is negligible in absolute terms.

---

## Phase B — Lua Code Quality (Feature-Preserving Refactors)

All features stay intact. These make the code run faster per tick without changing what it displays.

### B1. Hoist `wezterm.nerdfonts.*` constants to module scope

**Files:** `statusbar.lua`, `tabs.lua`
**Why:** Lua 5.4 globals/table lookups are ~20x slower than local register access. `wezterm.nerdfonts.md_tab` is a double hash lookup. Since nerdfonts are constants, resolve once at module load.

**Change at top of `statusbar.lua`:**
```lua
local wezterm = require("wezterm")

-- Resolve hot constants once at module load (free after that)
local wz_format   = wezterm.format
local NF_TAB      = wezterm.nerdfonts.md_tab
local NF_PANE     = wezterm.nerdfonts.md_view_split_vertical
local NF_LAYERS   = wezterm.nerdfonts.cod_layers
local NF_FOLDER   = wezterm.nerdfonts.md_folder
local NF_BRANCH   = wezterm.nerdfonts.dev_git_branch
local NF_LIGHTNING = wezterm.nerdfonts.md_lightning_bolt
local NF_CODE     = wezterm.nerdfonts.fa_code
```

Then inside the handler, replace `wezterm.nerdfonts.md_tab` with `NF_TAB`, etc.

**Impact:** ~20 hash lookups per tick become register reads. Measurable but small per call; adds up over a long session.
**Feature impact:** None — same icons, same output.

### B2. Add early-exit discriminator to `update-status`

**File:** `statusbar.lua:14` (handler entry)
**Why:** Most ticks nothing has actually changed. Compute a cheap signature from five values you already read; if unchanged, bail.

```lua
local _last_sig = ""

wezterm.on("update-status", function(window, pane)
  local workspace = window:active_workspace()
  local cwd_path  = theme.get_cwd_path(pane:get_current_working_dir())
  local cmd       = pane:get_foreground_process_name() or ""
  local key_table = window:active_key_table() or ""
  local leader    = window:leader_is_active()

  local sig = workspace .. "|" .. cwd_path .. "|" .. cmd .. "|" .. key_table .. "|" .. tostring(leader)
  if sig == _last_sig then return end
  _last_sig = sig

  -- existing handler body...
end)
```

**Impact:** Turns steady-state ticks into no-ops. Biggest wall-clock win.
**Feature impact:** None — status bar still accurate. Rendering just skipped when there's nothing new.

### B3. Reuse `right_items` table (eliminate per-tick allocations)

**File:** `statusbar.lua:91` (and the 25+ `table.insert` calls after)
**Why:** Currently allocates ~30 sub-tables every tick. All become garbage. Hoist to module scope and overwrite by index.

```lua
-- Module scope
local right_items = {}

-- Inside handler, overwrite by index instead of re-allocating:
local n = 0
local function push(v) n = n + 1; right_items[n] = v end

push({ Foreground = { Color = colors.pink } })
push({ Text = NF_FOLDER .. "  " })
-- ...
-- At the end, truncate any stale entries from a previous longer run:
for i = n + 1, #right_items do right_items[i] = nil end

window:set_right_status(wz_format(right_items))
```

**Impact:** Eliminates 25+ allocations/sec. GC has less to do.
**Feature impact:** None — same content rendered.

### B4. Replace `git branch --show-current` subprocess with `.git/HEAD` read

**File:** `statusbar.lua:35-48`
**Why:** Forking `git` is ~10-20ms per call (fork + exec + process startup). Reading `.git/HEAD` directly is ~10x faster — same data for the common case.

```lua
local function read_git_branch(cwd)
  if cwd == "" then return "" end
  local f = io.open(cwd .. "/.git/HEAD", "r")
  if not f then return "" end
  local line = f:read("*l")
  f:close()
  if not line then return "" end
  local branch = line:match("^ref: refs/heads/(.+)$")
  if branch then return branch end
  -- Detached HEAD: show short hash
  return line:sub(1, 7)
end
```

Then in the handler, replace `wezterm.run_child_process({...})` with `branch = read_git_branch(cwd_path)`.

Bonus: also avoids adding to the upstream WezTerm spawn/terminate leak.

**Impact:** Faster cache-miss path, no subprocess, no leak fuel.
**Feature impact:** None — same branch displayed. Handles detached HEAD gracefully (shows short hash).

### B5. Upgrade `git_cache` to keyed map + `wezterm.GLOBAL` persistence

**File:** `statusbar.lua:11-48`
**Why:** Current single-entry cache thrashes when switching between panes in different directories. Keyed map remembers multiple. Moving to `wezterm.GLOBAL` survives config reloads (module-local tables reset on every save).

```lua
-- Module scope (no longer a plain local table)
local GIT_CACHE_MAX = 32

local function git_branch_for(cwd_path)
  if cwd_path == "" then return "" end
  local g = wezterm.GLOBAL
  g.git_cache = g.git_cache or {}
  g.git_cache_order = g.git_cache_order or {}

  local cached = g.git_cache[cwd_path]
  if cached ~= nil then return cached end

  local branch = read_git_branch(cwd_path)
  g.git_cache[cwd_path] = branch
  table.insert(g.git_cache_order, cwd_path)
  if #g.git_cache_order > GIT_CACHE_MAX then
    local evict = table.remove(g.git_cache_order, 1)
    g.git_cache[evict] = nil
  end
  return branch
end
```

**Impact:** Switching between directories is free after first visit. Survives config hot-reload (no unnecessary re-fork after every save).
**Feature impact:** None — same branch displayed, just faster.

### B6. Cache workspace stats keyed by workspace name

**File:** `statusbar.lua:55-80`
**Why:** The `all_windows()` traversal is preserved (keeping Ed's accurate cross-window tab/pane count), but only recomputed when the workspace actually changes. Tab/pane counts don't change every second — they change when you split or close panes.

```lua
-- Module scope (survives reloads via GLOBAL)
local function get_workspace_stats(window)
  local g = wezterm.GLOBAL
  g.ws_stats = g.ws_stats or {}

  local ws = window:active_workspace()
  local cached = g.ws_stats[ws]
  -- Cheap change detection: check local window tab count vs cached
  local current_win_tabs = #window:mux_window():tabs()
  if cached and cached.local_tabs == current_win_tabs then
    return cached.tabs, cached.panes
  end

  local total_tabs, total_panes = 0, 0
  local ok, all_wins = pcall(function() return wezterm.mux.all_windows() end)
  if ok and all_wins then
    for _, mux_win in ipairs(all_wins) do
      if mux_win:get_workspace() == ws then
        local tabs = mux_win:tabs()
        total_tabs = total_tabs + #tabs
        for _, tab in ipairs(tabs) do
          total_panes = total_panes + #tab:panes()
        end
      end
    end
  end

  g.ws_stats[ws] = { tabs = total_tabs, panes = total_panes, local_tabs = current_win_tabs }
  return total_tabs, total_panes
end
```

Then in the handler:
```lua
local total_tabs, total_panes = get_workspace_stats(window)
```

**Impact:** Full mux traversal happens only when tab count changes, not every tick.
**Feature impact:** **Zero — this was the concern. Count stays accurate across multiple windows in a workspace.** This is the refactor that respects Ed's feedback.

### B7. Add early exit to zen-state polling in `wezterm.lua`

**File:** `wezterm.lua:95-105` (the zen `update-status` handler)
**Why:** Fires on every window every tick. The work is tiny but gated on `zen_state.pending_zen`. Check it first and bail.

```lua
wezterm.on("update-status", function(window, pane)
  if not zen_state.pending_zen then return end  -- early exit
  -- existing zen detection logic
end)
```

Bonus: also add `window-destroyed` hook to prevent orphan accumulation in `zen_state.zen_windows`:
```lua
wezterm.on("window-destroyed", function(window)
  local id = tostring(window:window_id())
  if zen_state.zen_windows then zen_state.zen_windows[id] = nil end
end)
```

**Impact:** Near-zero cost when not zen-pending (99% of the time).
**Feature impact:** None.

### B8. (Optional) OSC 7 for free CWD lookups

**Location:** Fish config (`fish/.config/fish/conf.d/`), not WezTerm itself
**Why:** If Fish emits OSC 7 on every prompt, `pane:get_current_working_dir()` returns the pre-stored value instead of doing a live syscall. Documented as the recommended pattern in WezTerm's shell-integration guide.

Add to Fish:
```fish
function __wezterm_osc7 --on-variable PWD
  printf '\e]7;file://%s%s\e\\' (hostname) (string escape --style=url "$PWD")
end
```
(Verify Fish doesn't already emit this — modern Fish versions may.)

**Impact:** CWD lookups become free pre-computed reads.
**Feature impact:** None — same CWD displayed, just cheaper.

---

## Phase C — Operational Hygiene (Claude Code)

These are not WezTerm config changes — they prevent the *real* memory drivers from compounding.

### C1. Periodic orphan MCP process sweep

**Why:** Known Claude Code bug (issue #33947): on macOS, MCP server child processes orphan to `PPID=1` when a session ends. Reported accumulations of 100+ node processes consuming 7+ GB. You're clean right now; this prevents silent accumulation later.

Add to `fish/.config/fish/functions/`:
```fish
function claude-reap --description "Kill orphaned Claude Code MCP server node processes"
  set -l orphans (ps -eo pid,ppid,comm | awk '$2==1 && $3~/node/{print $1}')
  if test (count $orphans) -gt 0
    echo "Killing "(count $orphans)" orphaned node processes..."
    kill $orphans 2>/dev/null
  else
    echo "No orphaned node processes."
  end
end
```

Run manually as `claude-reap` when memory feels heavy, or wire into a daily cron.

### C2. Session restart cadence

**Why:** Claude Code has open unbounded-heap bugs (#22188, #28731, #32752). No config fix. Restarting sessions periodically resets the heap.

Practical: don't keep a single Claude Code session running for more than a workday. Start fresh when context feels stale or memory grows.

### C3. Keep `compactionThreshold: 83` in `settings.json`

Already set. Autocompaction reduces token count and keeps context lean. Doesn't fix the heap leak but reduces pressure.

### C4. Audit MCP server count

You have many MCP servers configured. Each session spawns 2 node processes per MCP server (wrapper + child). Removing rarely-used servers is the single biggest lever for reducing per-session footprint.

---

## Dropped From Original Plan (With Reasoning)

These were in the first draft and are now removed because they would reduce features:

| Original proposal | Why dropped |
|---|---|
| Remove `wezterm.mux.all_windows()` traversal | Ed uses the cross-window tab/pane count; B6 preserves it via caching |
| `HighPerformance` → `LowPower` GPU | Cosmetic on Apple Silicon; not worth touching |
| Disable cursor blink | Feature preference; keep if Ed likes the blink |
| Merge both `update-status` handlers into one | Higher refactor risk; B2 early-exit captures most of the win without restructuring |

---

## Rollout Order

1. **Phase A** (config knobs) — one commit. Immediate, zero-risk. Dogfood for a day.
2. **Phase B1 + B2 + B7** (localize constants, early-exit, zen bail) — one commit. Pure code quality, no behavior change.
3. **Phase B4 + B5** (`.git/HEAD` read + `wezterm.GLOBAL` map cache) — one commit. Removes subprocess, preserves branch display.
4. **Phase B3** (reuse `right_items`) — one commit. Slightly higher surgical complexity.
5. **Phase B6** (workspace stats cache) — one commit. The feature-preserving answer to the original #7.
6. **Phase B8** (OSC 7 for Fish) — separate concern; only if CWD lookups show up in profiling.
7. **Phase C1** (`claude-reap` function) — add anytime. Preventive.

## Verification Plan

Before and after each commit:

```bash
# Baseline WezTerm RSS
ps -axo rss,command | awk '/[Ww]ez[Tt]erm-gui/ {sum+=$1} END {print sum/1024 " MB"}'

# Claude Code total
ps -axo rss,command | awk '/claude/ && !/awk/ {sum+=$1; c++} END {printf "%d procs, %.1f MB total\n", c, sum/1024}'

# Orphan count (should stay at 0)
ps -eo pid,ppid,comm | awk '$2==1 && $3~/node/' | wc -l

# Reload WezTerm config (cmd+shift+r in WezTerm) — no errors in:
tail -f ~/.local/share/wezterm/log/*.log
```

Success criteria:
- [ ] All status bar content unchanged (workspace, cwd, branch, cmd, tabs, panes, workspace count)
- [ ] All keymaps work
- [ ] No errors in WezTerm logs after reload
- [ ] Git branch still shows on all repos (including detached HEAD)
- [ ] Tab/pane counts stay accurate across multiple windows in a workspace
- [ ] Zen mode still works
- [ ] No regression in CPU usage (should go down or stay flat)

## Open Questions for Ed

- **Phase A4** (`status_update_interval = 2000`)? Halves work, updates 1s slower. Keep 1000 if sub-second freshness matters.
- **Phase B8** (OSC 7)? Only worth doing if Phase B profiling shows CWD as a hot spot.
- **Phase C1** (`claude-reap` function)? Even though you're clean now, do you want the safety net?

## References

- [WezTerm Lua 5.4 confirmation — issue #4917](https://github.com/wezterm/wezterm/issues/4917)
- [mlua (Rust ↔ Lua binding used by WezTerm)](https://github.com/mlua-rs/mlua)
- [wezterm.GLOBAL docs](https://wezterm.org/config/lua/wezterm/GLOBAL.html)
- [PaneInformation cheap vs expensive](https://wezterm.org/config/lua/PaneInformation.html)
- [status_update_interval docs](https://wezterm.org/config/lua/config/status_update_interval.html)
- [OSC 7 / passing data from pane](https://wezterm.org/recipes/passing-data.html)
- [Lua optimization coding tips](http://lua-users.org/wiki/OptimisationCodingTips)
- [Lua local variable optimization](http://lua-users.org/wiki/OptimisingUsingLocalVariables)
- [Roberto Ierusalimschy — Lua Performance Tips (PDF)](https://www.lua.org/gems/sample.pdf)
- [Claude Code MCP orphan bug — issue #33947](https://github.com/anthropics/claude-code/issues/33947)
- [Claude Code heap growth — issue #22188](https://github.com/anthropics/claude-code/issues/22188)
- [WezTerm spawn/terminate leak — issue #6116](https://github.com/wezterm/wezterm/issues/6116)
- [WezTerm update-status blocking — issue #5939](https://github.com/wezterm/wezterm/issues/5939)
