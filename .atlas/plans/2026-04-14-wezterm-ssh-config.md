# WezTerm SSH Configuration — Modular Lua + Private Override

**Date:** 2026-04-14
**Status:** Plan — awaiting review
**Author:** Atlas (for Ed)

## Goal

Add first-class SSH support to the WezTerm config with:

1. **Modular `ssh.lua`** matching the existing `keymaps.lua` / `theme.lua` / `tabs.lua` pattern.
2. **Zero SSH secrets in the public repo** — no hostnames, IPs, usernames, or key paths committed.
3. **Split-pane SSH workflows** — split the current pane into a remote shell; spawn new tabs on remote domains.
4. **Picker-driven connection** — one leader chord opens a fuzzy picker over all available SSH domains.
5. **Reversible & stow-safe** — deleting `ssh.lua` doesn't break the config; `stow update` ignores local-only files.

## Design Decisions

| Decision | Choice | Rationale |
|---|---|---|
| SSH mode default | **Plain SSH (`multiplexing = 'None'`)** | Works with any host. No wezterm-on-remote requirement. Resilient to version drift. |
| Secret strategy | **`default_ssh_domains()` + optional `ssh_local.lua` override** | Zero data in public `ssh.lua`. `~/.ssh/config` (600-perm) is the canonical secret holder. `ssh_local.lua` is the escape hatch for explicit multiplexed domains. |
| Keybinding style | **Picker + split variants in a dedicated key table** | `cmd+k s` opens picker; `cmd+k s` followed by `h/j/l/u` splits pane in direction before connecting. Mirrors existing `resize_pane` / `move_tab` key-table pattern. |
| Auto-connect | **None by default** | Fast startup, no network dependency. `ssh_local.lua` may opt in per-domain. |
| Private file convention | **`ssh_local.lua` gitignored, `ssh_local.lua.example` committed** | Exactly mirrors `secrets.fish` / `secrets.fish.example` convention already in repo. |

## File Changes

### NEW — `config/.config/wezterm/ssh.lua` (committed)

Public module. Three responsibilities:

1. Build `ssh_domains` from `wezterm.default_ssh_domains()` — downgrading all to `multiplexing = 'None'` unless the private file says otherwise.
2. Attempt `pcall(require, "ssh_local")` — if found, merge its `domains` and `keys` contributions.
3. Export `{ domains, keys, key_table }` for `wezterm.lua` to compose.

**Public API (exports):**

```lua
local M = {}

-- Returns array of ssh_domain tables suitable for config.ssh_domains
function M.domains()
  -- 1. Start with auto-discovery from ~/.ssh/config
  -- 2. Set multiplexing = 'None' + assume_shell = 'Posix' on each
  -- 3. Append any explicit domains from ssh_local.lua
end

-- Returns the SSH entry keybinding { key = 's', mods = 'LEADER', action = ... }
-- plus any per-host bindings contributed by ssh_local.lua
function M.keys()
end

-- Returns the { ssh = { ... } } key_table entry for inclusion in config.key_tables
function M.key_table()
end

return M
```

**Key table design (`cmd+k s` entry):**

| Key (inside ssh table) | Action |
|---|---|
| `c` or `Enter` | Open picker (`InputSelector`) — connect in **current pane** (replaces it) |
| `t` | Open picker — connect in **new tab** |
| `n` | Open picker — connect in **new window** |
| `h` | Open picker — connect in **split-left** pane |
| `l` | Open picker — connect in **split-right** pane |
| `j` | Open picker — connect in **split-down** pane |
| `u` | Open picker — connect in **split-up** pane |
| `Escape` / `q` | Pop key table |

This gives you a mnemonic mini-mode: `cmd+k s` → `l` splits right and drops a picker for the SSH host.

### NEW — `config/.config/wezterm/ssh_local.lua.example` (committed)

Template showing structure for the private override file. Heavily commented. No real hostnames.

```lua
-- ssh_local.lua — Private, machine-specific SSH config.
-- Copy to ssh_local.lua and edit. DO NOT COMMIT ssh_local.lua.
-- This file is loaded via pcall in ssh.lua; missing = no-op.

local M = {}

-- Explicit domains (layered on top of ~/.ssh/config auto-discovery).
-- Use this for multiplexed (WezTerm-on-remote) hosts or custom options.
M.domains = {
  -- {
  --   name = 'prod',
  --   remote_address = 'prod.example.internal:22',
  --   username = 'deploy',
  --   multiplexing = 'WezTerm',   -- or 'None'
  --   remote_wezterm_path = '/home/deploy/.local/bin/wezterm',
  --   connect_automatically = false,
  -- },
}

-- Per-host fast-access keys (added to keymaps.keys).
-- Example: cmd+k 0 to jump to your primary server.
M.keys = {
  -- {
  --   key = '0',
  --   mods = 'LEADER',
  --   action = require('wezterm').action.SpawnCommandInNewTab {
  --     domain = { DomainName = 'SSH:prod' },
  --   },
  --   desc = 'SSH to prod',
  -- },
}

return M
```

### NEW — `.gitignore` entry

Add a reusable pattern, not an ssh-specific one:

```gitignore
### WezTerm local-only files
config/.config/wezterm/*_local.lua
!config/.config/wezterm/*_local.lua.example
```

Double-negation (`!`) preserves the committed `.example` file. Pattern `*_local.lua` is reusable for any future machine-specific WezTerm module.

### MODIFIED — `config/.config/wezterm/wezterm.lua`

Three changes:

1. `local ssh = require("ssh")` near the other `require`s.
2. Call `ssh.contribute(keymaps)` BEFORE `configuration.setup(theme, keymaps)` so SSH keys land in `keymaps.keys` / `keymaps.key_tables`.
3. After `config` is built: `config.ssh_domains = ssh.domains()`.

**Diff (conceptual):**

```lua
 local keymaps = require("keymaps")
+local ssh = require("ssh")
 local configuration = require("configuration")
 ...
+ssh.contribute(keymaps)                       -- mutates keymaps.keys / key_tables
 local config = configuration.setup(theme, keymaps)
+config.ssh_domains = ssh.domains()
```

Alternative (cleaner but touches more files): extend `configuration.setup(theme, keymaps, ssh)` signature and have it merge internally. Prefer the minimal option above unless you want the explicit signature.

### MODIFIED — `config/.config/wezterm/keymaps.lua`

**No changes.** All SSH bindings land via `ssh.contribute(keymaps)` at runtime. Keeps `keymaps.lua` focused on "keybindings Ed always wants" and `ssh.lua` focused on "SSH-specific bindings."

Rationale for NOT touching `keymaps.lua`: if you delete `ssh.lua` later, `keymaps.lua` stays intact. No orphan references.

## Integration Flow (runtime)

```
wezterm.lua
  ├─ require("theme")      → theme data
  ├─ require("keymaps")    → base keys / key_tables
  ├─ require("ssh")        → ssh module
  │   └─ pcall(require, "ssh_local")  → optional private overrides
  │
  ├─ ssh.contribute(keymaps)          → inserts SSH entry + key table
  ├─ config = configuration.setup(theme, keymaps)
  ├─ config.ssh_domains = ssh.domains()
  ├─ tabs.setup(theme)
  ├─ statusbar.setup(theme)
  ├─ workspaces.setup()
  └─ return config
```

## Picker Implementation Sketch

The SSH picker is `wezterm.action.InputSelector` populated from `ssh.domains()`:

```lua
local function build_picker(spawn_target)
  -- spawn_target: 'pane' | 'tab' | 'window' | 'split-left' | 'split-right' | 'split-up' | 'split-down'
  local choices = {}
  for _, d in ipairs(ssh.domains()) do
    table.insert(choices, { label = d.name, id = d.name })
  end

  return act.InputSelector {
    title = 'SSH →',
    choices = choices,
    action = wezterm.action_callback(function(window, pane, id, label)
      if not id then return end
      local cmd = { domain = { DomainName = id } }

      if spawn_target == 'tab' then
        window:perform_action(act.SpawnCommandInNewTab(cmd), pane)
      elseif spawn_target == 'window' then
        window:perform_action(act.SpawnCommandInNewWindow(cmd), pane)
      elseif spawn_target:match('^split%-') then
        local dir = spawn_target:gsub('split%-', '')
        window:perform_action(act.SplitPane {
          direction = dir:sub(1,1):upper() .. dir:sub(2),
          command = cmd,
        }, pane)
      else
        -- current pane: replace via new tab + close current (wezterm has no "replace pane" action)
        window:perform_action(act.SpawnCommandInNewTab(cmd), pane)
      end
    end),
  }
end
```

## Validation / Testing Checklist

- [ ] `wezterm start` boots without errors with ssh_local.lua **absent**.
- [ ] `wezterm start` boots without errors with a valid ssh_local.lua.
- [ ] `wezterm start` shows a clear error (not a hang) if ssh_local.lua has a syntax error.
- [ ] `cmd+k s` enters the ssh key table (status bar shows mode indicator if desired).
- [ ] Picker lists every host from `~/.ssh/config`.
- [ ] `cmd+k s` → `l` splits right and picker prompts; selection spawns remote shell in new pane.
- [ ] `cmd+k s` → `t` spawns remote shell in new tab.
- [ ] Tab title shows the remote hostname (theme.lua ssh icon already mapped).
- [ ] `git status` in repo root shows `ssh.lua` and `ssh_local.lua.example` as tracked; `ssh_local.lua` (if created) is gitignored.
- [ ] `just update` / `stow` does not choke on gitignored `ssh_local.lua`.
- [ ] Removing `ssh.lua` and reloading: wezterm.lua still boots (pcall guard on require).

## Open Questions / Future Work

1. **Per-domain visual theming** — should hosts get a colored tab indicator (prod=red, staging=yellow)? Could live in `ssh_local.lua` via a `theme` field per domain and hook into `tabs.lua`. Deferred.
2. **Workspace templates** — `workspaces.lua` already spawns predefined layouts. A future `ssh.lua` extension could define "open `prod` + `staging` panes in a named workspace on startup." Deferred.
3. **SSHMUX opt-in** — if Ed installs wezterm on any remote, flipping a single `multiplexing = 'WezTerm'` line in `ssh_local.lua` for that host upgrades it. No `ssh.lua` changes required.
4. **`wezterm connect` from CLI** — once ssh_domains exist, `wezterm connect <name>` works shell-side too. Optional abbr in fish: `abbr wssh 'wezterm connect'`.

## Rollback

1. Delete `config/.config/wezterm/ssh.lua`.
2. Revert the three lines added to `wezterm.lua`.
3. (Optional) Delete `ssh_local.lua.example` and the gitignore block.

Everything else is untouched.
