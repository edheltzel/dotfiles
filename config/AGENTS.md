# config — application configs (stow package)

## Purpose

GNU Stow package holding XDG-compliant configuration for 30+ applications. Maps `config/.config/` → `~/.config/`.

## Ownership

Per-app config dirs under `.config/`: aerospace, alacritty, bat, borders, broot, btop, fastfetch, gh, gh-dash, ghostty, glow, herdr, karabiner, kitty, lazygit, leaderkey, raycast, sketchybar, starship, superfile, television, theme-switcher, topgrade, wezterm, yazi, zed, zellij, and others. Owns `config/.stow-local-ignore`.

## Local Contracts

- Stowed via `just stow config`; `config/.config/*` symlinks into `~/.config/`.
- `AGENTS.md` files are excluded from stow by `.stow-local-ignore` — they stay repo-only and are never symlinked into `~`.
- Never hardcode machine-specific or absolute home paths in app configs.
- Add a new app: drop its config under `.config/<app>/`, then `just stow config`.
- `superfile`: `theme/eldritch.toml` and `hotkeys.toml` are tracked (stow symlinks them into superfile's real, app-owned dir). `hotkeys.toml` is the upstream vim preset (vim nav: `-` parent, `enter` confirm, `m` select, `p` paste, `ctrl+c` quit, `q` close-panel). The bundled themes and `config.toml` (mode 600, private) stay untracked; the active-theme line is set live in `~/.config/superfile/config.toml`.
- Starship (`starship.toml` + `.config/starship/`): branch display is `${custom.gitbutler}` from vendored [starship-gitbutler](https://github.com/1stvamp/starship-gitbutler) (`gitbutler-branch.sh`, Apache-2.0). Keep `[git_branch]` disabled while that module is active, or `$all` will also print `gitbutler/workspace`. Local patches: `but status --json` (GitButler CLI 0.22 dropped `--format json`); Eldritch pink for the butler glyph and stack names (`#F265B5` dark / `#E63F9B` light, same as `[git_branch]`). Keep both current if you refresh the script from upstream. `$git_status` omits ahead/behind/diverged; `${custom.git_ahead_behind}` restores those counts only when `.git/gitbutler` is absent (workspace-vs-upstream is noise on `gitbutler/workspace`).

## Work Guidance

- Match each application's own native config format and conventions.
- Features take precedence over marginal RAM/CPU optimization — do not remove or degrade existing functionality for small resource wins.
- WezTerm shows native topology by default; while Herdr is foreground, its status bar uses cached `herdr api snapshot` workspace/tab/pane state and falls back cleanly on exit or API failure.

## Verification

No automated checks. Verify by launching the affected app.

## Child DOX Index

- `.config/wezterm/` — modular WezTerm (Lua) config — see `config/.config/wezterm/AGENTS.md`
