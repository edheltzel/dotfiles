# dots — miscellaneous $HOME dotfiles (stow package)

## Purpose

Loose top-level dotfiles that live directly in `~`. Maps `dots/*` → `~`.

## Ownership

Tool rc/config files: `.npmrc`, `.curlrc`, `.wgetrc`, `.tmux.conf`, `.tigrc`, `.ackrc`, `.biome.json`, `.gemrc`, `.gitnow`, `.hushlogin`, `.maccleanerrc`, `.no-mistakes/config.yaml`, `.profile`, `.warp/`, and similar. Owns `dots/.stow-global-ignore`, which is symlinked to `~/.stow-global-ignore` and used by stow packages that have no local ignore.

## Local Contracts

- Files map straight into `~`; keep this package to genuinely home-rooted dotfiles.
- `AGENTS.md` is excluded from stow via `.stow-global-ignore` (the shared global ignore).
- `.no-mistakes/` tracks only `config.yaml`; `install.sh` and `just update` pre-create `~/.no-mistakes` so stow never folds the runtime dir (repos, sqlite, logs) into this repo.

## Work Guidance

(none)

## Verification

(none)

## Child DOX Index

No children.
