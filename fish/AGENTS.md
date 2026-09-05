# fish — Fish shell config (stow package)

## Purpose

Primary shell (v3). XDG-compliant, performance-optimized with lazy-loading for fast startup. Maps `fish/.config/fish/` → `~/.config/fish/`.

## Ownership

- `config.fish` — prompt selection (`FISH_PROMPT`, Starship) plus the lazy-load wrappers for FNM (`node`/`npm`/`npx`) and rbenv (`ruby`/`gem`/`bundle`/`rake`/`irb`). Third-party installers append PATH lines to the bottom; keep them there.
- `conf.d/` — auto-loaded modules: `abbr.fish`, `paths.fish` (XDG vars), `exports.fish`, `brew.fish`, `fish-ssh-agent.fish`, `keys.fish`, `mole.fish`, `theme_colors.fish`, `wezterm.fish`, `zellij.fish`, `zoxide.fish`, `secrets.fish` (gitignored) + `secrets.fish.example`
- `functions/` — custom functions; `completions/`; `utils/`
- `fish_plugins` — Fisher plugin list
- `agent-harnesses.txt` — data manifest of harnesses updated by `functions/aup.fish`
- `config_lazy_load.fish`, `config_ultra_minimal.fish` — alternate startup experiments, not sourced

## Local Contracts

- Use **abbreviations** (`abbr.fish`), not aliases, for composability.
- Keep multi-step command implementations in named files under `functions/`; `abbr.fish` should contain abbreviations only.
- `functions/aup.fish` updates agent harnesses listed in `agent-harnesses.txt` (pipe-delimited: `label | color | binary | version | args`) — add or remove harnesses there, not in the fish file. The manifest lives at the fish config root (`fish/.config/fish/agent-harnesses.txt`), read at runtime via `$__fish_config_dir`, so it travels with the stow package. Harnesses whose binary is not installed are skipped (dim note, not an error); successful updates report the installed version in a harness-specific color, with Pi in pink.
- Lazy-load heavy tools. Two patterns are in use: FNM/rbenv wrappers in `config.fish` erase themselves after the first init; the `z`/`zi` wrappers in `conf.d/zoxide.fish` persist (guarded by `functions -q`, zoxide started with `--no-cmd`) so they can run `__list_dir` after every jump. `npx` delegates to `bunx`.
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
