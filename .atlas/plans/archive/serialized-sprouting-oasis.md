# Fish Shell Cleanup — Round 2 (10 Research Findings + Future Improvements)

## Context

After the main optimization (PATH consolidation, Fisher cleanup, config restructure), the research team flagged 10 additional findings plus several items in `_aliases.fish` that emerged during deeper inspection. This plan addresses all of them.

**Scope**: Low-risk cleanups. Every change is independently revertible.

---

## Item 1 — Delete `lazy_load.fish` (dead code)

**File**: `fish/.config/fish/functions/lazy_load.fish`

Generic lazy-load helper that nothing uses. Config.fish has purpose-built lazy-loaders for FNM and rbenv. Delete it.

**Risk**: Zero — nothing calls it.

---

## Item 2 — `cd.fish` (no change)

**Decision**: Keep as-is. Ed likes seeing files after every cd.

---

## Item 3 — Remove iTerm2 shell integration

**File**: `fish/.config/fish/conf.d/exports.fish` (line 35), `fish/.config/fish/utils/iterm2_shell_integration.fish`

The iTerm2 integration is sourced on every interactive shell. Ed uses WezTerm. The integration script has its own guard (`if ... not functions -q -- iterm2_status`) and checks for iTerm2-specific TERM values, so it's mostly a no-op on WezTerm — but it still defines ~10 functions and hooks that never fire.

**Fix**: Remove the source line from exports.fish. Keep the file in `utils/` (no harm, just not loaded).

**New exports.fish interactive block**:
```fish
if status is-interactive
    set -g fish_key_bindings fish_default_key_bindings

    source ~/.config/fish/functions/_aliases.fish
    source ~/.config/fish/functions/_utils.fish
    source ~/.config/fish/functions/_backup_restore.fish
end
```

---

## Item 4 — Convert `_utils.fish` to standalone functions

**File**: `fish/.config/fish/functions/_utils.fish`

Contains 3 functions (`colormap`, `matrix`, `doom`) defined inside a sourced file. Fish's autoloading convention is one function per file in `functions/`. These should be standalone files — they'll load on-demand (only when called) instead of on every interactive shell startup.

**Fix**:
1. Create `fish/.config/fish/functions/colormap.fish`
2. Create `fish/.config/fish/functions/matrix.fish`
3. Create `fish/.config/fish/functions/doom.fish`
4. Delete `fish/.config/fish/functions/_utils.fish`
5. Remove `source ~/.config/fish/functions/_utils.fish` from exports.fish

**Note**: The `doom` function has a hardcoded path `$HOME/Developer/games/terminal-doom`. Keep as-is (it's Ed's personal path).

---

## Item 5 — `keys.fish` cleanup

**File**: `fish/.config/fish/conf.d/keys.fish`

The `fzf_configure_bindings` call with no arguments is a no-op (fzf.fish already sets defaults). The comment block is the real value — it documents the Cmd+Ctrl keybinding mappings.

**Fix**: Convert to a pure comment file (remove the redundant function call):
```fish
# fzf.fish keybindings reference (defaults — set by patrickf1/fzf.fish)
# Terminal emulators remap Cmd+Ctrl -> Ctrl+Alt
# Cmd+Ctrl+F = Search Directory
# Cmd+Ctrl+L = Search Git Log
# Cmd+Ctrl+S = Search Git Status
# Cmd+Ctrl+R = Search History
# Cmd+Ctrl+P = Search Processes
# Cmd+Ctrl+V = Search Variables
#
# To customize: uncomment and modify
# fzf_configure_bindings --directory=\ct --git_log=\cg --git_status=\cs --history=\cr --processes=\cp --variables=\cv
```

---

## Item 6 — Fisher/Stow architectural note

This is documentation, not code. The tension is: Fisher writes files directly into `~/.config/fish/` while stow manages symlinks. They can overwrite each other.

**Fix**: Add a comment to `fish_plugins` documenting the stow-first workflow:
```fish
# Fisher plugins — managed by Fisher, symlinked by Stow
# IMPORTANT: After `fisher install/remove`, always run `make stow pkg=fish`
# to restore any stow symlinks that Fisher may have overwritten.
```

---

## Item 7 — Migrate appropriate aliases to abbreviations

**File**: `fish/.config/fish/functions/_aliases.fish` → `fish/.config/fish/conf.d/abbr.fish`

Fish abbreviations expand in-line and show the full command in history. Better for simple 1:1 mappings. Aliases are better for commands with complex quoting, pipes, or builtin wrappers.

**Keep as aliases** (complex quoting, builtin wrappers, or flags):
- `grep/egrep/fgrep --color=auto` — builtin wrapping
- `cp -Ri`, `mv -i`, `rm -i` — safety wrappers
- `cma commit-all`, `cm commit`, `gs state` — gitnow (alias wrapping is fine)
- `l`, `ll`, `la`, `cll`, `tree`, `ltd` — complex eza flags
- `ips`, `sniff`, `httpdump` — pipes and complex quoting
- `fld` — path with spaces and special characters

**Migrate to abbreviations** (simple 1:1 or short command substitutions):
```fish
# Move from _aliases.fish to abbr.fish
abbr --add md 'mkdir -p'
abbr --add cwd pwd
abbr --add dev 'cd ~/Developer'
abbr --add work 'cd ~/Developer'
abbr --add sites 'cd ~/Sites'
abbr --add dots 'cd ~/.dotfiles'
abbr --add neoed 'cd ~/.dotfiles/neoed/.config/nvim'
abbr --add neo 'cd ~/.dotfiles/neoed/.config/nvim'
abbr --add e '$EDITOR'
abbr --add o open
abbr --add oo 'open .'
abbr --add oa 'open -a'
abbr --add del trash
abbr --add sdel 'sudo rm -rf'
abbr --add serve miniserve
abbr --add du dua
abbr --add wget 'wget -c'
abbr --add whois 'grc whois'
abbr --add hostfile 'sudo nvim /etc/hosts'
abbr --add editssh 'nvim ~/.ssh'
abbr --add dk docker
abbr --add dc 'docker compose'
abbr --add pn pnpm
abbr --add px 'pnpm dlx'
```

**Also discovered during review — issues in `_aliases.fish`**:

1. **`alias npx bunx` (line 80) — SILENTLY DEAD**: The lazy-loader in config.fish defines `function npx` which overwrites this alias. **Fix**: Remove the alias. Change config.fish lazy-loader to: `function npx; __lazy_fnm; command bunx $argv; end` (runs bunx after fnm init, matching Ed's intent). **Decision**: npx → bunx confirmed.

2. **Laravel aliases (lines 82-88) — dead code**: `art`, `tinker`, `mfs`, `phpunit`, `pest`, `vapor`. **Decision**: Remove entirely (not doing active Laravel).

3. **`alias dc docker-compose` (line 74) — outdated**: Docker Compose V2 uses `docker compose` (space, not hyphen). Fix: `abbr --add dc 'docker compose'`.

4. **Hardcoded paths**: `alias pai="bun /Users/ed/.claude/skills/PAI/Tools/pai.ts"` (line 42) and `alias fld` (line 39) use `/Users/ed/` instead of `$HOME`. Fix pai to use `$HOME`.

5. **Unnecessary `eval`**: `alias hostfile "eval sudo nvim /etc/hosts"` and `alias editssh "eval nvim ~/.ssh"` — the `eval` is unnecessary. These become clean abbreviations.

6. **Dead comment**: Line 70 `#alias ssh "kitty +kitten ssh"` — Kitty-specific, remove.

---

## Item 8 — `secrets.fish.example` update

**File**: `fish/.config/fish/conf.d/secrets.fish.example`

The template is minimal (3 keys). Research found that Ed's actual `secrets.fish` likely has more keys based on his tooling (ElevenLabs for voice, Bright Data, etc.).

**Fix**: Expand the example to match Ed's PAI tooling stack (actual secrets.fish only has the original 3 entries):
```fish
# secrets.fish - API keys and sensitive environment variables
# This file is gitignored and should not be committed to version control
#
# Usage: Copy this file to secrets.fish and fill in your keys
#   cp secrets.fish.example secrets.fish

# AI Providers
#set -gx ANTHROPIC_API_KEY ""
#set -gx OPENAI_API_KEY ""
#set -gx GOOGLE_API_KEY ""
#set -gx XAI_API_KEY ""
#set -gx PERPLEXITY_API_KEY ""

# Voice / Media
#set -gx ELEVEN_API_KEY ""

# GitHub (if not using gh auth)
#set -gx GITHUB_TOKEN ""

# Cloudflare
#set -gx CLOUDFLARE_API_TOKEN ""
#set -gx CLOUDFLARE_ACCOUNT_ID ""

# Data
#set -gx BRIGHT_DATA_API_TOKEN ""

# Add additional secrets below as needed
```

---

## Item 9 — Rust PATH double-entry documentation

**Files**: `fish/.config/fish/conf.d/paths.fish` (line 20), `~/.config/fish/conf.d/rustup.fish` (system-managed)

`rustup.fish` is auto-generated by rustup and adds `$HOME/.cargo/bin` to PATH. Our `paths.fish` also adds it. `fish_add_path` deduplicates, so there's no bug — just redundancy.

**Fix**: Add a comment to paths.fish (already done — the comment exists). No code change needed. This item is informational.

---

## Item 10 — Gitnow documentation

Gitnow provides ~12 standalone commands that Ed actively uses. The research team mapped them:
- `pull` (auto-rebase), `push` (auto-upstream), `commit`, `commit-all`, `state`
- `feature`, `hotfix`, `bugfix`, `release` (branch workflows)
- `tag`, `upstream`, `show`

**Fix**: No code change. This is documentation confirming gitnow is well-utilized and should stay.

---

## Future Improvements (from suggestions)

### F1 — Convert `_backup_restore.fish` to standalone functions

Same pattern as Item 4. Two functions (`mkbak`, `restore`) in a sourced file that should be standalone function files loaded on-demand.

**Fix**:
1. Create `fish/.config/fish/functions/mkbak.fish`
2. Create `fish/.config/fish/functions/restore.fish`
3. Delete `fish/.config/fish/functions/_backup_restore.fish`
4. Remove `source ~/.config/fish/functions/_backup_restore.fish` from exports.fish

### F2 — Clean up `_aliases.fish` after migration

After moving simple aliases to abbreviations (Item 7), `_aliases.fish` will be much smaller. Consider whether the remaining aliases justify a sourced file or should become standalone function files too.

### F3 — Remove `_aliases.fish` source from exports.fish

After Items 4, 7, F1, and F2 are complete, the `if status is-interactive` block in exports.fish becomes minimal — possibly just the key bindings line. The remaining aliases can be a standalone function file or stay as-is.

---

## Execution Order

1. **Item 1**: Delete `lazy_load.fish`
2. **Item 4**: Convert `_utils.fish` → 3 standalone functions, delete sourced file
3. **Item F1**: Convert `_backup_restore.fish` → 2 standalone functions, delete sourced file
4. **Item 3**: Remove iTerm2 source line from exports.fish
5. **Item 7**: Migrate aliases → abbreviations, fix npx/dc/Laravel/hardcoded paths/dead comments
6. **Item 5**: Clean up `keys.fish`
7. **Item 6**: Add Fisher/Stow workflow comment to `fish_plugins`
8. **Item 8**: Update `secrets.fish.example`
9. **Items 2, 9, 10**: No code changes (informational)

## Files Modified

| File | Action |
|------|--------|
| `fish/.config/fish/functions/lazy_load.fish` | Delete |
| `fish/.config/fish/functions/_utils.fish` | Delete (replaced by 3 standalone files) |
| `fish/.config/fish/functions/colormap.fish` | Create |
| `fish/.config/fish/functions/matrix.fish` | Create |
| `fish/.config/fish/functions/doom.fish` | Create |
| `fish/.config/fish/functions/_backup_restore.fish` | Delete (replaced by 2 standalone files) |
| `fish/.config/fish/functions/mkbak.fish` | Create |
| `fish/.config/fish/functions/restore.fish` | Create |
| `fish/.config/fish/functions/_aliases.fish` | Edit (remove migrated aliases, fix npx, remove Laravel, fix paths) |
| `fish/.config/fish/conf.d/exports.fish` | Edit (remove 3 source lines, keep key bindings) |
| `fish/.config/fish/conf.d/abbr.fish` | Edit (add migrated abbreviations) |
| `fish/.config/fish/conf.d/keys.fish` | Edit (remove redundant function call) |
| `fish/.config/fish/fish_plugins` | Edit (add workflow comment) |
| `fish/.config/fish/config.fish` | Edit (fix npx to run bunx) |
| `fish/.config/fish/conf.d/secrets.fish.example` | Edit (expand template) |

## Verification

- New fish shell: abbreviations expand (`dev` + space → `cd ~/Developer`)
- `npx --version` triggers fnm init then runs bunx (not npx)
- `colormap`, `matrix`, `mkbak` work as standalone functions
- `dc` + space expands to `docker compose` (not `docker-compose`)
- No iTerm2 functions defined (`type iterm2_status` → not found)
- `art`, `tinker`, `mfs` not defined (Laravel aliases gone)
- `fisher list` still shows 8 plugins with workflow comment at top
