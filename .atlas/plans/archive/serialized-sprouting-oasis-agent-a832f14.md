# Red Team Analysis: Fish Shell Optimization Plan

## Methodology
Every proposed change was examined against the live filesystem state, current Fish session state, symlink topology, Fisher plugin files, and universal variable persistence. Findings are ordered by change number with cross-cutting concerns at the end.

---

## Change 1: Docker Fix

### RISKS

**A1. OrbStack is still installed and may reclaim the symlinks.** OrbStack is present at `/Applications/OrbStack.app` with its own docker-buildx and docker-compose binaries at `/Applications/OrbStack.app/Contents/MacOS/xbin/`. If OrbStack has any launch daemon, login item, or post-update hook, it could silently re-symlink `~/.docker/cli-plugins/` back to its own binaries after you fix them. You would not notice until a `docker compose` command behaves differently or fails.

**A2. The `~/.docker/bin` directory does not exist.** The plan says to uncomment the Docker PATH (`~/.docker/bin`) in paths.fish, and paths.fish line 62 currently adds `$HOME/.docker/bin` to `fish_user_paths`. But `~/.docker/bin/` does not exist on disk. The directory listing shows only `cli-plugins/`, `config.json`, `contexts/`, and `.DS_Store`. Adding a nonexistent path is harmless with `fish_add_path` (it silently skips), but it signals a misunderstanding of where Docker Desktop puts its binaries. Docker Desktop puts the `docker` binary at `/usr/local/bin/docker` or uses its own app bundle. This PATH entry does nothing and the plan treats it as if it does something.

**A3. Docker Desktop has 13 CLI plugins, not just 2.** The plan only relinks `docker-compose` and `docker-buildx`, but Docker Desktop ships 13 plugins: `docker-ai`, `docker-buildx`, `docker-compose`, `docker-debug`, `docker-desktop`, `docker-extension`, `docker-init`, `docker-mcp`, `docker-model`, `docker-offload`, `docker-sandbox`, `docker-sbom`, `docker-scout`. The current `~/.docker/cli-plugins/` directory only has the 2 OrbStack symlinks. If the user has been using Docker Desktop features like `docker scout` or `docker sbom`, those already work via Docker Desktop's own PATH mechanism, not via cli-plugins symlinks. But the plan creates a false sense of completeness by fixing only 2 of 13.

### BAD ASSUMPTIONS

- Assumes Docker Desktop is the desired runtime. Both OrbStack and Docker Desktop are installed. The user may want OrbStack. The plan never asks.
- Assumes `~/.docker/bin` is a real Docker Desktop PATH. It is not. Docker Desktop does not create this directory on modern macOS installations.

### MISSING STEPS

- No verification that OrbStack is disabled or uninstalled. If OrbStack is still running, the fix is temporary.
- No backup of existing symlinks before deletion.
- Should check if Docker Desktop is actually running and functional after relinking.

### ORDERING DEPENDENCIES

- None with other changes, but the paths.fish change (Change 3) intersects because it also touches the Docker PATH line.

### ROLLBACK PLAN

- `ln -sf /Applications/OrbStack.app/Contents/MacOS/xbin/docker-compose ~/.docker/cli-plugins/docker-compose` and same for buildx.
- Comment out Docker PATH line in paths.fish again.

---

## Change 2: Rewrite config.fish

### RISKS

**B1. Dropping `__load_full_config` removes the only deferred-load mechanism for `_aliases.fish` from config.fish.** The plan states this is "likely broken" because `& ` runs in a subshell. This is CORRECT for abbreviations but WRONG for aliases. Fish `alias` commands create global functions, and while a backgrounded subshell's function definitions do not propagate to the parent, the current code has `_aliases.fish` ALSO loaded by `exports.fish` (line 8) which runs synchronously in conf.d. So `_aliases.fish` is already loaded before config.fish even runs. The risk here is minimal, but the reasoning in the plan is partially wrong about WHY it is safe to remove -- it is safe because of the redundant load in exports.fish, not because the feature is "broken."

**B2. The plan says "Remove PATH lines (handled by paths.fish + brew.fish)" but does not account for the Warp.app PATH.** config.fish line 8 adds `/Applications/Warp.app/Contents/MacOS` to PATH. This is NOT in paths.fish or brew.fish. If this line is removed without being relocated, Warp terminal integration breaks. The current `fish_user_paths` shows Warp at position 1, coming from this exact line.

**B3. "Add npx" lazy-loader is problematic.** `_aliases.fish` line 80 already defines `alias npx bunx`. If the plan adds an npx lazy-loader function in config.fish AND keeps the alias in `_aliases.fish`, the alias and function will conflict. Fish resolves functions before aliases, so the lazy-loader would win, meaning npx would go through fnm/node instead of bun. This silently changes behavior.

**B4. Using `command node` instead of bare `node` in lazy wrappers.** The current code (line 34) calls `node $argv` which would recurse into the lazy wrapper function `node` again. This IS a bug in the current code -- calling `node` from within the `node` function wrapper causes infinite recursion. The fix to `command node` is correct. BUT: the zoxide lazy-loader at `zoxide.fish:9` has the same bug (`z $argv` calls itself). The plan does not fix that one. This means the fix is applied inconsistently.

**B5. Prompt init runs outside `status is-interactive`.** The plan says "Single prompt init inside `if status is-interactive` block." This is important because `starship init fish | source` spawns a process and defines prompt functions. Running it in non-interactive shells (scripts, SSH commands) wastes time and may cause side effects. The current code runs it unconditionally (line 24 is outside the interactive block). The plan fixes this. However, if ANY script relies on the prompt being initialized (unlikely but possible with starship's env vars), it would break.

**B6. Dropping PROJECTS_DIR from config.fish.** Line 56 sets `PROJECTS_DIR ~/Developer`. paths.fish line 52 also sets it. The plan says "handled by paths.fish." This is correct, but if the plan's rewrite of paths.fish (Change 3) does not preserve this variable, it silently disappears. The plan for Change 3 does not explicitly mention keeping PROJECTS_DIR.

### BAD ASSUMPTIONS

- Assumes `_aliases.fish` is only needed interactively. Some aliases like `grep "grep --color=auto"` might be invoked in scripts via the fish shell. Unlikely, but the plan does not consider it.
- Assumes the Warp PATH is unnecessary. It may or may not be -- depends on whether Ed still uses Warp.

### MISSING STEPS

- Must relocate Warp.app PATH to paths.fish if keeping it, or explicitly decide to drop it.
- Must reconcile the `npx` alias in `_aliases.fish` with any new lazy-loader.
- Should fix the recursive `z $argv` bug in zoxide.fish at the same time.

### ORDERING DEPENDENCIES

- Change 3 (paths.fish rewrite) MUST happen simultaneously or before, because config.fish removal of PATH lines depends on them being present in paths.fish.
- Change 5 (merge variables.fish) should happen before or simultaneously to ensure PROJECTS_DIR is preserved somewhere.

### ROLLBACK PLAN

- `git checkout fish/.config/fish/config.fish` restores the original. Then `make stow pkg=fish`.

---

## Change 3: Rewrite paths.fish

### RISKS

**C1. Removing `set -e fish_user_paths` (line 2) leaves stale universal variables permanently accumulated.** The current system has BOTH global and universal `fish_user_paths`. The universal scope has 5 entries that were set by `set -U` commands in the current paths.fish (pyenv, composer, etc.). The global scope has 9 entries set by `set -g` and `fish_add_path`. The `set -e fish_user_paths` on line 2 currently only erases the GLOBAL variable (despite the comment suggesting otherwise), and the universal values persist. If you switch to `fish_add_path` exclusively, the universal values REMAIN and cannot be removed by editing paths.fish. You must explicitly run `set -eU fish_user_paths` once to clear the universal scope, or those 5 stale paths persist forever across sessions.

THIS IS THE SINGLE HIGHEST-RISK ITEM IN THE ENTIRE PLAN. The plan says "Remove `set -e fish_user_paths` (the nuclear clear on line 2)" but does not address the existing universal variable contamination. After the rewrite, paths will be duplicated (once from universal, once from fish_add_path), and there is no way to fix it without a manual `set -eU fish_user_paths` command. The plan must include a one-time cleanup step.

**C2. `fish_add_path` is idempotent but the ORDER matters.** `fish_add_path` prepends by default. The order paths appear in PATH determines priority. The current paths.fish uses `set -gx PATH ... $PATH` and `set -g fish_user_paths ... $fish_user_paths` which prepend. With `fish_add_path`, calls later in the file will be EARLIER in PATH. The plan does not specify the intended PATH ordering. If Homebrew's PATH needs to be highest priority, the `fish_add_path /opt/homebrew/bin` call must be LAST, not first.

**C3. Hardcoded ruby version path: `$HOME/.gem/ruby/3.0.2/bin`.** The current ruby is 3.4.8 (verified). The paths.fish still references ruby 3.0.2. The plan says to use `fish_add_path` and `$HOME` instead of hardcoded paths, but does not mention fixing the ruby version. If this stale 3.0.2 path is migrated as-is into the new paths.fish, it is a bug carried forward.

**C4. Removing rbenv init from paths.fish (deferring to lazy-load in Change 6) means rbenv shims are not in PATH until first ruby/gem/bundle invocation.** Any non-interactive process that needs ruby (git hooks, editor integrations, Makefiles) will get the system ruby or Homebrew ruby instead of the rbenv-managed one. This could cause version mismatches in projects with `.ruby-version` files.

**C5. Pyenv PATH uses `set -Ux PYENV_ROOT`.** The `-Ux` flag sets a universal exported variable. This persists permanently. If the plan removes this line from paths.fish and replaces it with `fish_add_path`, the `PYENV_ROOT` variable itself will still be set universally from the OLD run. But any NEW machine that runs the new paths.fish will NOT get `PYENV_ROOT` set at all unless the plan includes `set -gx PYENV_ROOT $HOME/.pyenv`. The plan does not mention preserving environment VARIABLES -- only PATH entries.

**C6. Netlify credential helper path is hardcoded to `/Users/ed/`.** Line 59 has `test -f '/Users/ed/Library/Preferences/netlify/helper/path.fish.inc'`. The plan says to use `$HOME` instead of hardcoded `/Users/ed/`, which is correct, but this particular file uses `test -f` and `source`, meaning the file might set its own hardcoded paths internally. Fixing just the outer reference may not be sufficient.

**C7. The antigravity PATH on line 65 is hardcoded to `/Users/ed/.antigravity/antigravity/bin`.** The plan mentions using `$HOME` but does not call out this specific line. If missed, the hardcoded username remains.

**C8. GOPATH and Go PATH use different variable mechanisms.** Line 37-38 use `set -x GOPATH` (exported but not global-exported) and direct PATH manipulation. Converting to `fish_add_path $GOPATH/bin` requires GOPATH to be set BEFORE the `fish_add_path` call, so the order within the file matters.

### BAD ASSUMPTIONS

- Assumes `fish_add_path` handles all cases. `fish_add_path` only manages PATH. The file also sets HOMEBREW_PREFIX, HOMEBREW_CELLAR, HOMEBREW_REPOSITORY, MANPATH, INFOPATH, GOPATH, PYENV_ROOT, PNPM_HOME, BUN_INSTALL, FZF_DEFAULT_COMMAND, FZF_CTRL_T_COMMAND, and PROJECTS_DIR. These are not PATH entries -- they are environment variables. The plan only addresses PATH standardization but the file does double duty.
- Assumes removing `set -e fish_user_paths` is safe without cleaning universal scope. It is not.
- Assumes the openssl@1.1 path is still needed. OpenSSL 1.1 is EOL. Homebrew may have removed it.

### MISSING STEPS

- ONE-TIME MANUAL STEP: `set -eU fish_user_paths` to clear stale universal values.
- Must decide what happens to non-PATH variables (HOMEBREW_PREFIX, GOPATH, PNPM_HOME, BUN_INSTALL, FZF vars, PROJECTS_DIR). Where do they go?
- Must verify openssl@1.1 is still installed: `brew list openssl@1.1`
- Must fix ruby 3.0.2 gem path to current version or remove it.
- Must decide whether brew.fish and paths.fish overlap on Homebrew PATH setup (they currently do -- both add /opt/homebrew/bin).

### ORDERING DEPENDENCIES

- Change 2 (config.fish) depends on this. Config.fish PATH lines can only be removed after paths.fish handles them.
- Change 6 (lazy rbenv) depends on this. rbenv init must be removed from paths.fish only after lazy-load is in place.
- Change 5 (merge variables.fish) must coordinate to avoid losing environment variables.

### ROLLBACK PLAN

- `git checkout fish/.config/fish/conf.d/paths.fish && make stow pkg=fish`
- BUT: if universal `fish_user_paths` was erased as a cleanup step, those cannot be restored by git checkout. They need manual recreation.

---

## Change 4: Fix exports.fish

### RISKS

**D1. The `status is-interactive` guard will break non-interactive shells that depend on _aliases.fish functions.** Currently, `_aliases.fish` is sourced unconditionally by exports.fish (conf.d auto-load, no guard). This means even non-interactive fish (scripts, cron, SSH commands) have access to alias-functions like `grep --color=auto`, `cp -Ri`, `rm -i`, etc. Wrapping these in an interactive guard means scripts that call `grep` will no longer get colorized output (minor), but more critically, scripts calling `rm` will lose the `-i` safety flag. Actually, wait -- since these are ALIASES (functions), a script that runs `rm something` through Fish would invoke the alias. Losing the alias in non-interactive mode means `rm` goes back to the unguarded system rm. This is actually a correctness improvement (interactive safety aliases should not apply to scripts), but it IS a behavior change.

**D2. `_utils.fish` functions become unavailable non-interactively.** The `colormap`, `matrix`, and `doom` functions only make sense interactively, so this is fine. But if any script or tool calls `_backup_restore.fish` functions (`mkbak`, `restore`) non-interactively, those break.

**D3. iTerm2 shell integration loaded conditionally.** If Ed opens a non-interactive fish shell inside iTerm2, the shell integration will not load. This is unlikely to matter in practice because iTerm2 integration is inherently interactive, but it is a behavior change.

**D4. `fish_key_bindings` set inside interactive guard.** Wait -- the plan says to wrap the SOURCE calls, but `set -g fish_key_bindings fish_default_key_bindings` on line 2 is not a source call. Does the plan wrap that too? If so, key bindings may not be set in some edge case. If not, this is fine. The plan is ambiguous here.

### BAD ASSUMPTIONS

- Assumes nothing non-interactive sources _aliases.fish indirectly. If a CI/CD script or git hook runs under Fish, aliases are lost.
- Assumes iterm2_shell_integration.fish exists and has no errors. The `2>/dev/null` suppression in current code suggests it might not exist on all machines.

### MISSING STEPS

- Verify that no scripts, git hooks, or automated processes depend on aliases being available non-interactively.
- Clarify whether line 2 (`fish_key_bindings`) should also be wrapped.

### ORDERING DEPENDENCIES

- None strictly, but should be done AFTER Change 2 (config.fish) so the duplicate `_aliases.fish` load can be evaluated holistically.

### ROLLBACK PLAN

- `git checkout fish/.config/fish/conf.d/exports.fish && make stow pkg=fish`

---

## Change 5: Merge variables.fish into exports.fish, delete variables.fish

### RISKS

**E1. CARGO_TARGET_DIR points to a temporary directory.** `variables.fish:15` sets `CARGO_TARGET_DIR` to `/var/folders/88/3h9cyc4979d2l6p7xkn79yqr0000gn/T/cargo-installx9AWBr`. This is a macOS temporary directory that gets cleaned on reboot. If this was intentionally set (to keep cargo build artifacts out of project directories), removing it changes where cargo puts build output. If it was accidentally captured (from a `cargo install` session), it should be fixed to a stable path or removed entirely. The plan says "Fix CARGO_TARGET_DIR" but does not say what to fix it TO.

**E2. VOL=xxx is a placeholder.** The plan says "Remove VOL=xxx placeholder." This is fine, but if ANY script or tool references `$VOL`, it will become undefined instead of "xxx". The value "xxx" is obviously wrong, but undefined is a different kind of wrong.

**E3. The merge must handle the `TERM xterm-256color` issue from colors.fish.** Wait -- this change is about merging variables.fish, not colors.fish. But variables.fish line 24-25 has nvim shell integration (`string match -q "$TERM_PROGRAM" nvim / and . (nvim --locate-shell-integration-path fish)`). This would now live in exports.fish. If the interactive guard from Change 4 wraps this, it breaks nvim terminal integration in non-interactive embedded terminals.

**E4. EDITOR is set to `zed` in variables.fish.** This will now live in exports.fish. If exports.fish is guarded with `status is-interactive` (Change 4), the EDITOR variable disappears in non-interactive contexts, breaking git commit message editing, crontab -e, etc. The interactive guard MUST NOT wrap the EDITOR variable.

**E5. The `WARP_THEME_DIR` variable reveals Ed may still use Warp.** Combined with the Warp PATH in config.fish (Change 2), this suggests Warp is potentially still in use. Removing the Warp PATH without checking is risky.

### BAD ASSUMPTIONS

- Assumes all variables in variables.fish are appropriate for the interactive guard. EDITOR, TERMINAL, XDG vars, and MANPAGER should be set unconditionally. Only some content is appropriate for an interactive guard.
- Assumes deleting variables.fish is clean. But the symlink `~/.config/fish/conf.d/variables.fish -> ../../../.dotfiles/fish/.config/fish/conf.d/variables.fish` must be cleaned up via `stow -D` or `make unstow`.

### MISSING STEPS

- Must decide which variables from variables.fish go INSIDE the interactive guard and which go OUTSIDE.
- Must decide what CARGO_TARGET_DIR should actually be (stable path, or just remove the variable).
- Must run `make unstow pkg=fish` before deleting to clean the symlink, then `make stow pkg=fish` after.
- The XDG variables in variables.fish (lines 1-10) are critical for non-interactive contexts. They MUST NOT be wrapped in an interactive guard.

### ORDERING DEPENDENCIES

- Must coordinate with Change 4 (interactive guard) to ensure variables are not accidentally wrapped.
- Must happen after or simultaneously with Change 4.

### ROLLBACK PLAN

- Recreate variables.fish from git history. `git checkout fish/.config/fish/conf.d/variables.fish && make stow pkg=fish`

---

## Change 6: Lazy-load rbenv

### RISKS

**F1. Lazy-loading breaks rbenv shims for commands NOT in the wrapper list.** The plan wraps `ruby`, `gem`, `bundle`, `rake`, `irb`. But rbenv shims also intercept `erb`, `rdoc`, `ri`, `racc`, `rbs`, `rdbg`, `typeprof`, `bundler`, and any binstubs installed via `bundle install --binstubs`. Any of these commands invoked before `ruby` trigger the shim PATH lookup. Without rbenv initialized, they either fail or run the wrong version.

**F2. `command ruby $argv` bypasses rbenv shims.** The lazy-load function does `source (rbenv init -|psub)` then `command ruby $argv`. But `rbenv init` works by adding SHIMS to PATH, not by aliasing `ruby`. After sourcing rbenv init, the `ruby` in PATH is actually `~/.rbenv/shims/ruby`. Using `command ruby` searches PATH and finds the shim, so this IS correct. However, using `command` skips any Fish FUNCTIONS named `ruby` -- if rbenv init defines a `ruby` function (some versions do), `command ruby` would skip it. This needs testing.

**F3. Git hooks that use ruby run in non-interactive shell.** The lazy-load is in config.fish inside `if status is-interactive`. Git hooks, CI scripts, and non-interactive SSH commands will NOT trigger the lazy-loader. They will use whatever `ruby` is in PATH without rbenv (likely Homebrew's ruby). If a project has a `.ruby-version` specifying a different version, the git hook runs with the wrong ruby.

**F4. Background processes spawned from an interactive shell inherit the environment.** If `ruby` has not been invoked yet in the current session, a background process (`some_script &`) that needs ruby will fail because rbenv is not initialized.

**F5. The `functions -e` line erases specific function names.** `functions -e __lazy_rbenv ruby gem bundle rake irb` erases all named functions. But if any of these names also exist as conf.d-defined functions (e.g., from a Fisher plugin), erasing them removes the plugin's version too. Currently no conflict exists, but it is fragile.

### BAD ASSUMPTIONS

- Assumes only 5 ruby-related commands exist. There are many more rbenv shims.
- Assumes interactive-only usage of ruby. Git hooks and scripts may need it.
- Assumes rbenv init is fast enough that lazy-loading provides meaningful speedup. On modern hardware, `rbenv init - | source` takes ~20-40ms. The lazy-load complexity may not be worth it.

### MISSING STEPS

- Benchmark `rbenv init -|psub` to verify the lazy-load is worth the added complexity and failure modes.
- Add wrappers for at minimum: `erb`, `bundler`, `rdoc`, `ri`.
- Consider whether non-interactive shells need rbenv (git hooks, scripts).
- Test that `command ruby $argv` correctly finds the rbenv shim after init.

### ORDERING DEPENDENCIES

- Change 3 (paths.fish) must remove the rbenv init line simultaneously. If Change 6 is applied but Change 3 is not, rbenv initializes TWICE (once synchronously in paths.fish, once lazily).
- If Change 3 is applied but Change 6 is not, rbenv never initializes at all.

### ROLLBACK PLAN

- Remove lazy-load functions from config.fish. Restore `source (rbenv init -|psub)` in paths.fish. Run `make stow pkg=fish`.

---

## Change 7: Delete dead conf.d files

### RISKS

**G1. Deleting `fnm.fish` is safe but the symlink cleanup matters.** The file at `~/.config/fish/conf.d/fnm.fish` is a symlink to the dotfiles repo. Deleting the source file in the repo breaks the symlink. Must `make unstow pkg=fish` first, delete, then `make stow pkg=fish`. If done in wrong order, a dangling symlink remains until next stow.

**G2. Deleting `tmux.fish` has the same symlink issue.** Same as above.

**G3. Both files are entirely commented out, so deletion is low risk.** The only risk is the stow symlink management.

### BAD ASSUMPTIONS

- None significant. These files are genuinely dead.

### MISSING STEPS

- `make unstow pkg=fish` or `stow -D fish` before deletion, then `make stow pkg=fish` after.
- Alternatively, `make update` after deletion handles restow.

### ORDERING DEPENDENCIES

- None.

### ROLLBACK PLAN

- `git checkout` the deleted files. `make stow pkg=fish`.

---

## Change 8: Fisher plugin removals

### RISKS

**H1. Removing gitnow breaks `cm`, `cma`, and `gs` aliases immediately.** `_aliases.fish` lines 6-8 define `alias cma commit-all`, `alias cm commit`, `alias gs state`. These aliases call gitnow functions (`commit-all`, `commit`, `state`). After `fisher remove joseluisq/gitnow`, those functions disappear. If Change 9 (remove the aliases) does not happen SIMULTANEOUSLY, every invocation of `cm`, `cma`, or `gs` will produce "Unknown command" errors. The blast radius is high -- these are likely used multiple times daily.

**H2. Removing gitnow removes 12 actively-loaded functions.** The `fish -c 'functions -n'` check confirmed these gitnow functions are ACTIVE in the current session: `bugfix`, `commit`, `commit-all`, `feature`, `hotfix`, `move`, `pull`, `push`, `release`, `state`, `tag`, `upstream`. Some of these shadow common git operations. `pull` and `push` in particular -- if Ed has muscle memory for `pull` (gitnow's auto-rebase pull) instead of `git pull`, removing gitnow changes the behavior of commands he types daily. `push` with gitnow auto-sets upstream. Without gitnow, bare `push` becomes "Unknown command."

**H3. Removing plugin-git removes 7 unique functions with no replacement.** `gbda`, `gwip`, `gunwip`, `grt`, `grename`, `gtest`, `gbage` -- these are all regular files in `~/.config/fish/functions/` installed by Fisher. After removal, they are gone. If Ed uses ANY of these, he loses functionality with no substitute. The plan acknowledges this but does not provide replacements.

**H4. Fisher removal deletes files from `~/.config/fish/` directly.** Fisher does NOT use symlinks -- it copies files. When `fisher remove` runs, it deletes the function files AND conf.d files it installed. This means after removing gitnow, the 30+ `__gitnow_*.fish` function files AND `conf.d/gitnow.fish` are deleted. After removing plugin-git, `conf.d/git.fish` and all `__git.*.fish` function files plus `gbda.fish`, `gwip.fish`, etc. are deleted. BUT: Fisher also removes files that might have the SAME NAME as stow symlinks. Specifically:
  - `oh-my-fish/plugin-brew` installed `conf.d/brew.fish` as a regular file. The stow version would be a symlink. After Fisher removes its brew.fish, you MUST run `make stow pkg=fish` to restore the stow symlink.
  - `danhper/fish-ssh-agent` installed `conf.d/fish-ssh-agent.fish` and `functions/__ssh_agent_is_started.fish` and `functions/__ssh_agent_start.fish`. If there is a stow version, it must be restowed.

**H5. The `fish_plugins` file is a regular file, not a symlink.** After Fisher removals, the fish_plugins file at `~/.config/fish/conf.d/fish_plugins` is updated by Fisher. But there is no stow-managed version of this file in the dotfiles repo. This means the plugin list is NOT tracked in version control. If the machine is rebuilt from the repo, the Fisher plugins must be reinstalled manually. This is an existing problem, not caused by the plan, but the plan does not address it.

**H6. Removing `danhper/fish-ssh-agent` may be premature.** The plan notes that macOS handles SSH agent natively via `~/.ssh/config` with `AddKeysToAgent yes` and `UseKeychain yes`. The SSH config DOES have these settings (verified). HOWEVER, the Fisher plugin and the stow-managed conf.d file may serve different purposes. The Fisher plugin (`fish-ssh-agent.fish`) starts an ssh-agent process and checks if it is running. The macOS-native mechanism in `~/.ssh/config` only adds keys to the agent on first use -- it does NOT start the agent. macOS launchd starts `ssh-agent` automatically, so the plugin IS unnecessary on macOS. But if Ed ever SSHs into a Linux box and uses Fish there (with the same dotfiles), the plugin would be needed. The plan does not consider multi-platform use of the dotfiles.

**H7. Removing `oh-my-fish/plugin-brew` when stow has its own brew.fish.** The Fisher-installed `conf.d/brew.fish` is a regular file (not a symlink). The stow version at `fish/.config/fish/conf.d/brew.fish` would be symlinked. Currently, the Fisher version has OVERWRITTEN the stow symlink (the file listing shows `brew.fish` is a regular file with `@` extended attribute, not a symlink). After Fisher removes its version, there is NO brew.fish until `make stow pkg=fish` restores the symlink. During the gap, Homebrew is not in PATH. If this happens in the same shell session, existing commands that depend on Homebrew binaries continue to work (they are already in PATH), but NEW shells will lack Homebrew.

**H8. Removing `z11i/github-copilot-cli.fish` is safe but the conf.d file has eval-based functions.** The `github-copilot-cli.fish` defines `__copilot_what-the-shell`, `__copilot_git-assist`, and `__copilot_gh-assist` with aliases `!!`, `git!`, `gh!`. Removing this is fine since the binary is not installed, but verify that the `!!` alias is not used for bash-style previous command expansion (it is -- `oh-my-fish/plugin-bang-bang` provides that). Wait -- bang-bang plugin is KEPT (it is not on the removal list). But bang-bang also provides `!!`. If copilot-cli defines `alias '!!'='__copilot_what-the-shell'`, and bang-bang also binds `!!`, there is currently a CONFLICT that is silently resolved by load order. Removing copilot-cli may actually FIX bang-bang's `!!` behavior. This is a positive side effect, not a risk.

**H9. Order of Fisher removals matters.** If plugin-git is removed before gitnow, the `__git.init` function disappears, which gitnow might reference. Actually, gitnow and plugin-git are independent. But the point stands: all removals should happen in a single `fisher remove` invocation or in quick succession, followed by a single `make stow pkg=fish`.

### BAD ASSUMPTIONS

- Assumes Ed does not use `pull`, `push`, `move`, `commit`, `state`, `tag`, `upstream`, `feature`, `hotfix`, `release`, `bugfix` as standalone commands. These are ALL gitnow functions that will disappear. The plan only mentions `cm`, `cma`, `gs` as dependencies.
- Assumes Ed does not use `gbda`, `gwip`, `gunwip`, etc. No evidence either way.
- Assumes `make stow pkg=fish` will be run after removals. Does not state this explicitly.
- Assumes Fisher version of brew.fish is identical in function to stow version. Comparing: the stow version (from the dotfiles repo) is an 8-line fast brew detection. The Fisher version is the `oh-my-fish/plugin-brew` which does more (sets HOMEBREW vars). Need to verify the stow brew.fish is sufficient.

### MISSING STEPS

1. BEFORE removing gitnow: audit which gitnow functions are used daily. Check shell history: `history | grep -E '^(pull|push|move|commit|state|tag|feature|hotfix|release|bugfix|upstream)' | head -30`
2. BEFORE removing plugin-git: audit which plugin-git functions are used daily. Check: `history | grep -E '^(gbda|gwip|gunwip|grt|grename|gtest|gbage)' | head -20`
3. AFTER all removals: `make stow pkg=fish` to restore stow symlinks.
4. AFTER removals: verify fish_plugins file reflects the desired state.
5. Consider saving copies of useful plugin-git functions (gbda, gwip/gunwip) as standalone functions in the dotfiles repo.
6. Track `fish_plugins` in version control if not already.

### ORDERING DEPENDENCIES

- Change 9 (remove gitnow aliases) MUST happen simultaneously with or immediately after gitnow removal.
- `make stow pkg=fish` MUST happen after all Fisher removals.
- Should be the LAST change applied, after all other file edits, because Fisher removals can delete files that other changes need to edit.

### ROLLBACK PLAN

- `fisher install joseluisq/gitnow jhillyerd/plugin-git danhper/fish-ssh-agent oh-my-fish/plugin-brew z11i/github-copilot-cli.fish james2doyle/omf-plugin-artisan dteoh/fish-set-lc-all`
- Then `make stow pkg=fish` to fix any symlinks Fisher overwrote.

---

## Change 9: Minor cleanups

### RISKS

**I1. Removing gitnow aliases (lines 6-8 of _aliases.fish) MUST be atomic with gitnow removal.** If the aliases are removed before gitnow, the user loses `cm`/`cma`/`gs` shortcuts. If gitnow is removed before the aliases, those aliases error. Both must happen together.

**I2. "Fix CARGO_TARGET_DIR" is underspecified.** The plan says to fix it but not what value to use. Options:
  - Remove it entirely (cargo uses default: `target/` in project root)
  - Set to `$HOME/.cache/cargo/target` (keeps it out of projects but stable)
  - Set to a stable temp location
  The plan must specify.

**I3. "Remove VOL=xxx placeholder" -- verify nothing references $VOL first.** Run `grep -r VOL ~/.config/fish/ 2>/dev/null` and check scripts.

### BAD ASSUMPTIONS

- Assumes these are truly minor. The gitnow alias removal is tightly coupled to Change 8.

### MISSING STEPS

- Specify the CARGO_TARGET_DIR replacement value.
- Search for $VOL references before removal.
- Must be done simultaneously with Change 8.

### ORDERING DEPENDENCIES

- Depends entirely on Change 8 (Fisher removals).

### ROLLBACK PLAN

- `git checkout fish/.config/fish/functions/_aliases.fish && make stow pkg=fish`

---

## F. PLAN GAPS: What the plan misses entirely

### F1. colors.fish is fully redundant with fish_frozen_theme.fish

The plan does not propose removing `colors.fish`. The frozen theme file (auto-generated by Fish 4.3) contains ALL the same color values as `colors.fish` PLUS additional ones (`fish_color_keyword`, `fish_color_option`, `fish_pager_color_background`, `fish_pager_color_selected_*`). The frozen theme loads AFTER `colors.fish` (alphabetical: `c` before `f`), so it overwrites every value that `colors.fish` sets. `colors.fish` is 100% dead code.

### F2. TERM=xterm-256color override in colors.fish

`colors.fish:10` sets `set -x -g TERM xterm-256color`. This OVERRIDES the TERM value set by modern terminals like WezTerm (`xterm-256color` works but `wezterm` terminfo has more capabilities), Ghostty (`xterm-ghostty`), and Kitty (`xterm-kitty`). This line actively degrades terminal capability detection. It should be removed.

### F3. The `keys.fish` redundant fzf_configure_bindings call

`keys.fish` calls `fzf_configure_bindings` but the Fisher `fzf.fish` plugin conf.d file already calls it. This results in bindings being configured twice. The plan does not address this.

### F4. Double-loading of _aliases.fish and abbr.fish

The plan identifies that `__load_full_config &` is broken (abbreviations do not propagate from subshell). But it does not explicitly address that `_aliases.fish` is still loaded TWICE:
  1. By `exports.fish` (conf.d, no guard) -- synchronously
  2. By `config.fish:46` inside `__load_full_config &` -- backgrounded (broken for abbrs, questionable for aliases)

And `abbr.fish` is loaded TWICE:
  1. By conf.d auto-load (alphabetically first) -- synchronously
  2. By `config.fish:45` inside `__load_full_config &` -- backgrounded (broken, does nothing)

The fix is implied by removing `__load_full_config`, but the plan should explicitly state that the SOLE load path for _aliases.fish after the rewrite is exports.fish, and for abbr.fish is conf.d auto-load.

### F5. The zoxide lazy-loader has the same recursion bug as the node lazy-loader

`zoxide.fish:9` calls `z $argv` which recursively calls the wrapper function. The plan fixes the node wrapper to use `command node` but does not fix the zoxide wrapper. This inconsistency means the zoxide lazy-loader has been silently broken this whole time (Fish might handle it via PATH lookup after `functions -e z`, but it is fragile and depends on zoxide init defining a `z` function vs. binary).

### F6. The `uv.env.fish` file in conf.d sources a potentially missing file

`uv.env.fish` contains `source "$HOME/.local/share/../bin/env.fish"` which resolves to `source "$HOME/.local/bin/env.fish"`. If uv (the Python package manager) is not installed or the env file does not exist, this errors on every shell startup. It has no existence guard.

### F7. `rustup.fish` in conf.d sources cargo env

`rustup.fish` contains `source "$HOME/.cargo/env.fish"`. This is ALSO setting up Rust's PATH, which paths.fish ALSO does via `set -g fish_user_paths $HOME/.cargo/bin $fish_user_paths`. Rust PATH is set twice. After the paths.fish rewrite, this might be the third place (rustup.fish, paths.fish's fish_add_path, and the universal fish_user_paths contamination).

### F8. No mention of the `fish_plugins` file being tracked in version control

Fisher's plugin list exists only as a regular file at `~/.config/fish/conf.d/fish_plugins`. It is not a symlink to the dotfiles repo. If the machine is rebuilt, all Fisher plugins must be reinstalled manually. The plan should consider either:
  - Adding `fish_plugins` to the fish stow package so it is tracked
  - Adding a `fisher install` step to the install.sh script
  - Documenting the Fisher plugin list somewhere tracked

### F9. Prompt initialization happens before Homebrew PATH is confirmed

In the proposed config.fish, prompt init (starship/oh-my-posh) would run. But if starship is installed via Homebrew, it needs Homebrew's PATH. The current config.fish adds Homebrew paths on lines 5-6 before calling `__init_prompt` on line 24. After the rewrite, if PATH lines are removed from config.fish (delegated to paths.fish and brew.fish which load via conf.d), and conf.d loads BEFORE config.fish, then starship IS in PATH by the time config.fish runs. This is actually fine. But if the plan moves prompt init into an event handler or defers it, the PATH might not be ready. Low risk, but worth verifying load order.

### F10. The `artisan.fish` Fisher file conflicts with artisan aliases

`omf-plugin-artisan` installed `functions/artisan.fish`. The `_aliases.fish` has `alias art "php artisan"`. If the Fisher plugin is removed, the `artisan.fish` function disappears, which is fine because `art` is the preferred alias. But if Ed types `artisan` directly, it becomes "Unknown command" instead of running the Fisher function. Low impact since the alias `art` exists.

---

## G. SAFER ALTERNATIVES

### G1. Phase the changes instead of big-bang

The plan proposes 9 simultaneous changes. A safer approach:

**Phase 1 (Low risk, immediate):** Delete dead files (Change 7), remove copilot-cli and set-lc-all plugins (safe subset of Change 8), fix CARGO_TARGET_DIR and VOL (Change 9 partial).

**Phase 2 (Medium risk):** Rewrite paths.fish (Change 3) with the universal variable cleanup. Test for one week.

**Phase 3 (Medium risk):** Rewrite config.fish (Change 2) and exports.fish changes (Change 4, 5). Test for one week.

**Phase 4 (High risk, requires habit changes):** Remove gitnow and plugin-git (Change 8 remainder). Create replacement functions first. Remove aliases (Change 9). Lazy-load rbenv (Change 6).

### G2. Keep gitnow but remove plugin-git

Instead of removing both, keep gitnow (which Ed clearly uses via cm/cma/gs aliases) and only remove plugin-git. Save the unique plugin-git functions (gbda, gwip, gunwip, grt, grename, gtest, gbage) as standalone functions in the dotfiles repo's `functions/` directory before removing the plugin.

### G3. Replace `set -e fish_user_paths` with `set -eU fish_user_paths; set -eg fish_user_paths` one-time script

Instead of just removing the nuclear clear, run a migration script that:
1. Erases both universal and global fish_user_paths
2. Verifies they are clear
3. Applies the new paths.fish
This prevents PATH duplication from stale universal values.

### G4. Benchmark before lazy-loading rbenv

Before adding complexity with lazy rbenv loading, benchmark the actual impact:
```fish
time fish -c 'source (rbenv init -|psub); exit'
```
If it is under 30ms, the lazy-loading complexity is not justified given the failure modes (missing shims, non-interactive breakage).

### G5. Create a `fish/.config/fish/conf.d/fish_plugins` tracked file

Add the fish_plugins file to the stow package so Fisher plugin state is tracked in version control. This way, `fisher update` on a fresh machine restores all plugins.

### G6. Remove colors.fish immediately

Since `fish_frozen_theme.fish` fully supersedes it, and the `TERM` override is actively harmful, removing `colors.fish` is a zero-risk win that the plan inexplicably omits.

### G7. Fix the zoxide lazy-loader bug

Change `z $argv` to the correct form. After `functions -e z`, the `z` command should come from zoxide init, so calling `z $argv` should work because the function was redefined by zoxide init. But to be safe and consistent with the node fix, verify this works or use `command z` if z is a binary.

---

## Summary: Critical Items Requiring Resolution Before Implementation

| Priority | Item | Change | Why Critical |
|----------|------|--------|-------------|
| **P0** | Universal fish_user_paths cleanup | 3 | Stale paths persist forever, cause duplication |
| **P0** | Audit gitnow function usage in shell history | 8 | Could break daily workflow commands |
| **P0** | Simultaneous alias removal with plugin removal | 8+9 | Aliases reference nonexistent functions |
| **P0** | `make stow pkg=fish` after Fisher removals | 8 | brew.fish disappears without restow |
| **P1** | Relocate Warp.app PATH from config.fish | 2+3 | PATH entry lost silently |
| **P1** | Decide CARGO_TARGET_DIR value | 9 | Currently broken, plan does not specify fix |
| **P1** | Non-interactive rbenv access for git hooks | 6 | Wrong ruby version in hooks |
| **P1** | Preserve non-PATH variables from paths.fish | 3 | GOPATH, PYENV_ROOT, PNPM_HOME, etc. |
| **P1** | Interactive guard must not wrap EDITOR, XDG vars | 4+5 | Breaks git, cron, non-interactive tools |
| **P2** | Remove colors.fish (fully redundant) | Missing | Dead code with harmful TERM override |
| **P2** | Fix ruby 3.0.2 gem path | 3 | Wrong version, current is 3.4.8 |
| **P2** | Fix zoxide lazy-loader recursion | Missing | Same bug being fixed in node wrapper |
| **P2** | Check OrbStack status before Docker fix | 1 | May reclaim symlinks |
| **P3** | Track fish_plugins in version control | Missing | Machine rebuild loses plugin state |
| **P3** | Remove redundant fzf_configure_bindings in keys.fish | Missing | Minor, double-bind |
