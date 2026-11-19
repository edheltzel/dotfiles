# fish — Fish shell config (stow package)

## Purpose

Primary shell (v3). XDG-compliant, performance-optimized with lazy-loading for fast startup. Maps `fish/.config/fish/` → `~/.config/fish/`.

## Ownership

- `config.fish` — prompt selection (`FISH_PROMPT`, Starship) plus the lazy-load wrappers for rbenv (`ruby`/`gem`/`bundle`/`rake`/`irb`). Node/npm come from Vite+ shims (`conf.d/vite-plus.fish`, installer-managed); do not re-add `node`/`npm` wrapper functions, they shadow the shims. Third-party installers append PATH lines to the bottom; keep them there.
- `conf.d/` — auto-loaded modules: `abbr.fish`, `paths.fish` (XDG vars), `exports.fish`, `brew.fish`, `fish-ssh-agent.fish`, `grit.fish` (`GRIT_PAGER`), `keys.fish`, `mole.fish`, `theme_colors.fish`, `wezterm.fish`, `zellij.fish`, `zoxide.fish`, `secrets.fish` (gitignored) + `secrets.fish.example`
- `functions/` — custom functions; `completions/`; `utils/`
- `fish_plugins` — Fisher plugin list
- `agent-harnesses.toml` — data manifest of harnesses updated by `functions/aup.fish`
- `config_lazy_load.fish`, `config_ultra_minimal.fish` — alternate startup experiments, not sourced

## Local Contracts

- Use **abbreviations** (`abbr.fish`), not aliases, for composability. grit abbreviations (`gr`, `grs`, `grl`, `grd`, `grc`, `gra`, `grp`, `grf`, `grpl`, `grsw`) live there; the binary is the script install in `~/.local/bin`, updated by the topgrade `grit` command.
- `completions/grit.fish` is generated output of `grit completions fish` for the installed binary. After `grit update`, regenerate it (and `zsh/.config/zsh/completions/_grit`) instead of hand-editing.
- Keep multi-step command implementations in named files under `functions/`; `abbr.fish` should contain abbreviations only.
- `functions/aup.fish` updates agent harnesses listed in `agent-harnesses.toml` (`[[harness]]` tables: `label`, `color`, `binary`, optional `installed`, optional `version`, `args` as a string or list). Add or remove harnesses there, not in the fish file. The manifest lives at the fish config root (`fish/.config/fish/agent-harnesses.toml`), read at runtime via `$__fish_config_dir`, so it travels with the stow package. Order is run order. Every entry is checked before anything runs: it is installed when both `binary` and `installed` (default `binary`) are on PATH; the preflight prints `Installed:` and `Not installed (skipped):`, then only installed entries run. Successful updates report the installed version in the harness color, and the run ends with an `Update report` (version before and after, failures, skips). Omit `version` or set it to `"-"` to skip that line. Prefer the harness's own self-update command. When `binary` is a package manager (`brew`, `bun`, `bash` installer), set `installed` to the harness's own command (Herdr, Codex, Gemini CLI, Plannotator) so an absent harness is skipped. `tools/aup` (Go CLI with a TUI, manifest `config/.config/aup/harnesses.toml`, contract in `tools/aup/AGENTS.md`) matches this behavior in `--plain` mode; keep the two manifests in step until the migration retires this function.
- Lazy-load heavy tools. Two patterns are in use: rbenv wrappers in `config.fish` erase themselves after the first init; the `z`/`zi` wrappers in `conf.d/zoxide.fish` persist (guarded by `functions -q`, zoxide started with `--no-cmd`) so they can run `__list_dir` after every jump. `npx` delegates to `bunx` (alias in `functions/_aliases.fish`).
- Navigation listing for `cd`, `z`, and `zi` is centralized in `functions/__list_dir.fish`. Edit listing flags (columns, icons, git info) there ONLY — never duplicate them in `cd.fish` or `zoxide.fish`.
- `conf.d/secrets.fish` is gitignored; create from `secrets.fish.example`.

## Work Guidance

Preserve the lazy-loading pattern — new heavy integrations should defer initialization until first use.

If Fisher is missing or broken, reinstall it with:

```fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

## Verification

`reload` (re-source config). No automated tests; verify interactively.

## Child DOX Index

No children.
