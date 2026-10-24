# dots — miscellaneous $HOME dotfiles (stow package)

## Purpose

Loose top-level dotfiles that live directly in `~`. Maps `dots/*` → `~`.

## Ownership

Tool rc/config files: `.npmrc`, `.curlrc`, `.wgetrc`, `.tmux.conf`, `.tigrc`, `.ackrc`, `.biome.json`, `.gemrc`, `.gitnow`, `.hushlogin`, `.maccleanerrc`, `.no-mistakes/config.yaml`, `.empryo/`, `.profile`, `.warp/`, and similar. Owns `dots/.stow-global-ignore`, which is symlinked to `~/.stow-global-ignore` and used by stow packages that have no local ignore.

## Local Contracts

- Files map straight into `~`; keep this package to genuinely home-rooted dotfiles.
- `AGENTS.md` is excluded from stow via `.stow-global-ignore` (the shared global ignore). `~/AGENTS.md` is Pi's home config, not this package's doc, so both ignore files also carry `^/AGENTS\.md$`. A local ignore replaces stow's defaults, so `dots/.stow-local-ignore` repeats `.DS_Store` and `AGENTS.md`.
- `.no-mistakes/` tracks only `config.yaml`; `install.sh` and `just update` pre-create `~/.no-mistakes` so stow never folds the runtime dir (repos, sqlite, logs) into this repo.
- `.empryo/` tracks config only: `EMPRYO.md`, `tui-layout.json`, `orchestrations/`, and `.empryo/memory-config.json` are symlinked into `~/.empryo`. `config.json` is seed-copy, not a symlink, because Empryo replaces a symlinked config on write; `install.sh` and `just update` copy it only when `~/.empryo/config.json` is missing, and `just capture-empryo` copies the live file back. Runtime state (binaries, databases, logs, identity) stays in `~/.empryo`. `install.sh`, `just update`, and `just stow dots` pre-create `~/.empryo/.empryo` and `~/.empryo/orchestrations` so stow links files inside them.

## Work Guidance

(none)

## Verification

(none)

## Child DOX Index

No children.
