# WezTerm Agent Activity Tab Coloring

## Context

Ed wants WezTerm tabs to change background color when a coding agent (Claude Code, OpenCode, Gemini CLI, etc.) has activity or needs a response. The current `tabs.lua` already detects `has_unseen_output` and changes **text color** to yellow, but doesn't distinguish agent output from normal shell output, and doesn't change the **background** color.

This enhancement layers agent-aware detection on top of the existing tab system, using WezTerm nightly APIs confirmed via documentation research.

**Bonus fix discovered:** The current `tabs.lua` iterates the `panes` callback parameter (line 23), which is buggy per [GitHub #5499](https://github.com/wezterm/wezterm/issues/5499) — it always returns the *active* tab's panes, not the tab being formatted. Must use `tab.panes` instead.

## Detection Mechanism Trade-offs

### Approach A: Process Name + has_unseen_output (Recommended)
Check `foreground_process_name` on each pane in `tab.panes` for known agent process names. Only trigger when `has_unseen_output` is also true (inactive tab with new output).

- **Pros:** Works today, no agent cooperation needed, simple, fast
- **Cons:** Can't distinguish "streaming output" from "waiting for input" — any unseen agent output triggers it. This is actually fine behavior — if an agent is producing output you haven't seen, you want to know.

### Approach B: User Variables (WEZTERM_PROG)
WezTerm shell integration auto-sets `user_vars["WEZTERM_PROG"]` to the running command name. Could check this instead of/alongside process name.

- **Pros:** More reliable than process path parsing, survives `exec` chains
- **Cons:** Requires WezTerm shell integration to be active. Depends on fish integration being installed. Same "any output" limitation as A.

### Approach C: Custom User Variable (Future Enhancement)
Agent could set a custom user var (e.g., `AGENT_NEEDS_INPUT=1`) via OSC 1337 when it genuinely needs user input.

- **Pros:** Most accurate — only triggers on true "needs attention" state
- **Cons:** Requires each agent to cooperate by emitting OSC sequences. Not available today.

**Decision:** Implement **Approach A** (process name + unseen output) as the primary mechanism, with **Approach B** as a secondary check (check `user_vars["WEZTERM_PROG"]` too). This gives us reliable detection today. The architecture is designed so Approach C can be added later without restructuring.

## Plan

### 1. Add agent detection data to `theme.lua`

Add to the `M` module (after `process_icons`):

```lua
-- Agent processes: names that trigger "agent activity" tab coloring
-- Matches against basename of foreground_process_name AND user_vars.WEZTERM_PROG
M.agent_processes = {
  claude = true,
  opencode = true,
  gemini = true,
  aider = true,
  copilot = true,
}
```

Add `agent_activity` color to each theme's `tab_bar` table:
- Eldritch: `agent_activity = "#F7C67F"` (orange — warm attention color, distinct from green active, purple inactive fg, cyan/pink project colors)
- Other themes: pick a warm/amber tone that works with each palette

This keeps agent names in ONE location (satisfies ISC-A1) and colors in the theme system (satisfies ISC-C4).

### 2. Add agent detection helper to `theme.lua`

```lua
-- Helper: check if a pane is running a known coding agent
function M.is_agent_pane(pane_info)
  -- Check foreground process name
  local proc = pane_info.foreground_process_name or ""
  local proc_base = M.basename(proc)
  if M.agent_processes[proc_base] then return true end

  -- Check user vars (set by WezTerm shell integration)
  local user_prog = pane_info.user_vars and pane_info.user_vars["WEZTERM_PROG"] or ""
  if M.agent_processes[user_prog] then return true end

  return false
end
```

### 3. Modify `tabs.lua` detection logic

**Fix the panes bug:** Change `panes` parameter iteration to `tab.panes`.

**Add agent activity detection** alongside existing unseen output check:

```lua
-- Check for unseen output AND agent activity
local unseen = false
local agent_activity = false
for _, p in ipairs(tab.panes) do  -- FIXED: was using buggy `panes` param
  if p.has_unseen_output then
    unseen = true
    if theme.is_agent_pane(p) then
      agent_activity = true
    end
  end
end
```

**Update the color priority cascade:**

```lua
-- Determine tab colors (priority order)
local bg, fg
if tab.is_active then
  -- 1. Active tab: normal active styling (always wins)
  bg = project_color or tab_bar.active_bg
  fg = tab_bar.active_fg
elseif agent_activity then
  -- 2. Agent with unseen output: distinctive background
  bg = tab_bar.agent_activity
  fg = tab_bar.active_fg  -- dark text on bright bg
elseif unseen then
  -- 3. Generic unseen output: yellow text (existing behavior)
  bg = tab_bar.inactive_bg
  fg = colors.yellow
elseif project_color then
  -- 4. Project color: colored text (existing behavior)
  bg = tab_bar.inactive_bg
  fg = project_color
else
  -- 5. Default inactive
  bg = tab_bar.inactive_bg
  fg = tab_bar.inactive_fg
end
```

### Files Modified

| File | Change |
|------|--------|
| `config/.config/wezterm/theme.lua` | Add `agent_processes` table, `agent_activity` color per theme, `is_agent_pane()` helper |
| `config/.config/wezterm/tabs.lua` | Fix `panes` bug, add agent detection, update color cascade |

### Color Choices Per Theme

| Theme | agent_activity color | Rationale |
|-------|---------------------|-----------|
| Eldritch | `#F7C67F` (orange) | Warm amber, distinct from green active + purple/cyan/pink |
| Aura | `#FFCA85` (warm yellow) | Complements purple-heavy palette |
| rose-pine | `#f6c177` (gold) | Already in RP palette as "gold" |
| rose-pine-dawn | `#ea9d34` (gold) | Dawn's gold accent |
| rose-pine-moon | `#f6c177` (gold) | Moon's gold |
| Tokyo Night | `#E0AF68` (amber) | TN's existing yellow/amber |
| Tokyo Night Moon | `#FFC777` (amber) | TNM's amber |

## Verification

1. **Visual test:** Open WezTerm, run `claude` in one tab, switch to another tab. The claude tab should show orange/amber background pill.
2. **Reset test:** Switch back to the claude tab. Background should return to normal active color.
3. **No false positive:** Run `ls` or `vim` in a tab, switch away. Tab should show yellow text (existing behavior), NOT orange background.
4. **Multi-agent:** Run `opencode` in another tab. Same orange background behavior.
5. **Project color preserved:** Navigate to `.dotfiles` directory in a normal shell tab. Tab should still show cyan project color, not agent color.
