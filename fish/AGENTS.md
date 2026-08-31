# fish — Fish shell config (stow package)

## Purpose

Primary shell (v3). XDG-compliant, performance-optimized with lazy-loading for fast startup. Maps `fish/.config/fish/` → `~/.config/fish/`.

## Ownership

- `config.fish` — ultra-minimal for fast startup
- `conf.d/` — auto-loaded modules: `abbr.fish`, `paths.fish`, `exports.fish`, `fnm.fish`, `zoxide.fish`, `brew.fish`, `secrets.fish`
- `functions/` — custom functions; `completions/`; `themes/`; `utils/`
- `agent-harnesses.txt` — data manifest of harnesses updated by `functions/aup.fish`

## Local Contracts

- Use **abbreviations** (`abbr.fish`), not aliases, for composability.
- Keep multi-step command implementations in named files under `functions/`; `abbr.fish` should contain abbreviations only.
- `functions/aup.fish` updates agent harnesses listed in `agent-harnesses.txt` (pipe-delimited: `label | color | binary | version | args`) — add or remove harnesses there, not in the fish file. The manifest lives at the fish config root (`fish/.config/fish/agent-harnesses.txt`), read at runtime via `$__fish_config_dir`, so it travels with the stow package. Harnesses whose binary is not installed are skipped (dim note, not an error); successful updates report the installed version in a harness-specific color, with Pi in pink.
- Lazy-load heavy tools (FNM, Zoxide) — keep `config.fish` minimal.
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
