# readinglist — Safari Reading List -> FieldNotes notes (stow package)

## Purpose

Saves each new Safari Reading List item as a source note in the FieldNotes Obsidian vault. A LaunchAgent runs `rl2notes` whenever Safari's bookmarks change, every 10 minutes, and at login.

## Ownership

- `.local/bin/rl2notes` — Python script, stowed to `~/.local/bin/rl2notes`. Reads `~/Library/Safari/Bookmarks.plist` (`com.apple.ReadingList` child) and writes one note per unseen item to `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/FieldNotes✱/HUB/Sources/Web/` (frontmatter `type: source`, `status: inbox`, tags `Resource`, `ReadingList`). `--seed` marks every current item seen without writing notes.
- `readinglist.sh` — provisioner (not stowed). Generates `~/Library/LaunchAgents/com.ed.readinglist-notes.plist` with `$HOME`-expanded paths, seeds state if missing, and reloads the agent via `launchctl bootout`/`bootstrap` in `gui/$(id -u)`. Idempotent.
- `.stow-local-ignore` — excludes `AGENTS.md` and `readinglist.sh` from stow.

## Local Contracts

- Label is `com.ed.readinglist-notes`; keep it stable so `bootout` finds the old job.
- The plist is generated, never stowed: launchd cannot expand `$HOME`, and this repo carries no machine paths.
- State lives outside the repo: `~/.local/state/rl2notes/seen.json` (WebBookmarkUUIDs already saved) and `run.log` (agent stdout/stderr). Never commit either.
- Install: `just readinglist` on a provisioned machine (stows the package, then runs `readinglist.sh`); `./install.sh bootstrap` runs it on a new Mac. A failure there only warns, so bootstrap continues.
- Full Disk Access is required for Homebrew's `Python.app` (`readinglist.sh` prints the exact path, under `$(brew --prefix)/Cellar/python@3.x/<version>/Frameworks/Python.framework/Versions/3.x/Resources/Python.app`). Each Homebrew Python upgrade moves that path, so the grant must be redone and the agent fails with `PermissionError` in `run.log` until it is.
- With no `seen.json`, `readinglist.sh` seeds first so a new Mac does not re-save items already synced into the vault. Seeding needs Full Disk Access for the terminal running it.
- `rl2notes` exits non-zero without touching state when the vault folder is missing (iCloud not synced yet).
- Env overrides for testing: `RL2NOTES_OUT`, `RL2NOTES_STATE` (script), `RL2NOTES_PYTHON` (provisioner).

## Work Guidance

- Keep it Python standard library only; it runs under bare Homebrew `python3` with no venv.
- Re-save an item: remove its id from `seen.json` (or delete the file to re-save everything) and run `rl2notes`.
- Disable: `launchctl bootout gui/$(id -u)/com.ed.readinglist-notes`, then delete the generated plist and `just unstow readinglist`.

## Verification

- `shellcheck readinglist/readinglist.sh`
- `"$(brew --prefix)/bin/python3" ~/.local/bin/rl2notes` prints `new: <n>` (`new: 0` when nothing is pending).
- `launchctl print gui/$(id -u)/com.ed.readinglist-notes` shows the job and `~/.local/bin/rl2notes` in its arguments; `last exit code = 0` once Full Disk Access is granted.
- `tail ~/.local/state/rl2notes/run.log` shows `new: <n>` lines, not `PermissionError`.

## Child DOX Index

No children.
