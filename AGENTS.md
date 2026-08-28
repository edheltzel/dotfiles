# EdHeltzel's Dotfiles

Fish-shell macOS dotfiles (v3) managed with GNU Stow. Each top-level directory is a stow package symlinked into `~`; provisioning scripts run from `install.sh`. XDG-compliant so `~` stays clean.

Guidance for AI coding agents. Per-package rules live in the child `AGENTS.md` listed at the bottom.

## Invariants

Not discoverable from the tree, and expensive to get wrong.

- **`neovim/` is a git submodule** ([edheltzel/neoed](https://github.com/edheltzel/neoed)), a separate repo outside this DOX tree. Run `git submodule update --init --recursive` after cloning. Neovim edits do not commit here.
- **Never set `core.hooksPath` to `.githooks/`.** GitButler writes managed wrappers into `hooksPath`, and committing them causes a delete/untracked conflict. `just hooks` installs wrappers into `.git/hooks` and unsets `core.hooksPath` instead.
- **Post-navigation directory listing lives in exactly one file:** `fish/.config/fish/functions/__list_dir.fish`. `cd`, `z`, and `zi` all delegate to it. Never duplicate eza flags in `cd.fish` or `zoxide.fish`.
- **Commit signing is SSH, not GPG.** Machine-specific values live in untracked `~/.gitconfig.local`, symlinked by `git/git.sh` keyed on `ComputerName`. Never commit machine paths or keys.
- **Bun owns global JavaScript CLIs.** Use `bun`/`bunx`, never `npm -g`/`npx`. Vite+ is project tooling only.
- **`AGENTS.md` files are never stowed** - excluded per package via `.stow-local-ignore` or the shared `dots/.stow-global-ignore`. DOX docs stay repo-local and never land in `~`.
- **Fish uses abbreviations, not aliases.** Multi-step implementations go in `functions/`, never inline in `conf.d/abbr.fish`.
- **Secrets are gitignored:** `fish/.config/fish/conf.d/secrets.fish`, created from `secrets.fish.example`.
- **DOX docs are tracked in this public repo.** Every `AGENTS.md` plus the `CLAUDE.md` symlink is committed, so treat each line as published: never write secrets, tokens, or credentials into them. Edits go through a branch like any other change.

## Agent workflow

- **Plans** -> `.agents/atlas/plans/*.md`, descriptive filenames (`add-zellij-config.md`).
- **Handoffs** -> `.agents/atlas/handoffs/*.md`, same convention.
- **Worktrees** -> `.agents/atlas/worktrees/`, branches named `atlas-<type>-<slug>` (e.g. `atlas-feature-drift-control`).

Applies to every agent: plan mode, subagents, and manual planning alike.

## Provisioning

`install.sh <subcommand>` is the entry point. There is no `bootstrap.sh`; it was absorbed into `install.sh`.

- `bootstrap` - full machine provision: Xcode CLT, Homebrew, `packages/packages.sh`, stow, `duti/duti.sh`, `macos/macos.sh`, `git/git.sh`. Flags apply here.
- `link` - re-symlink only, for an already-provisioned machine.
- `help` - full usage, flags, and caveats.

Adding configuration: drop files into the owning stow package, `just stow <pkg>`, verify the app, then `just update` to restow everything.

## Conventions

- Shell: `set -e`, validate commands exist before use, fail fast. Source `scripts/functions.sh` for `error`/`info`/`warning`/`success`.
- Naming: `SCREAMING_SNAKE_CASE` for env and constants, `lowercase_snake` for shell locals, `camelCase` in Lua. Functions take verb prefixes (`install_`, `check_`).
- Comments explain *why*, not *what*.
- EditorConfig is enforced: 2 spaces, LF, UTF-8, `trim=false`, final newline.

## Verification

No test suite. Lint manually; the hooks run these on staged files.

- `shellcheck <script>` for shell.
- Lua lives in the `neovim` submodule and is linted in its own repo: `stylua --check neovim/.config/nvim` (config: `neovim/.config/nvim/stylua.toml`, 2 spaces, 120 cols). The pre-commit hook never reaches these files - the submodule is a single gitlink here, so no `.lua` path is ever staged in this repo.
- `just hooks` installs `.githooks/pre-commit` (blocks direct commits to `master`, refuses GitButler-managed hook files, runs `shellcheck --severity=error` + `stylua --check` on staged files, warns and skips when a linter is absent) and `.githooks/commit-msg` (Conventional Commits).

Per-package verification lives in each child `AGENTS.md`.

## Discover, do not memorize

Transcribed command and package lists rot. Query the source instead:

| Question | Source of truth |
| --- | --- |
| Available `just` recipes | `just --list` |
| Stow package list | `stow_packages` in `justfile` |
| Install subcommands and flags | `./install.sh help` |
| Package-manager targets | `packages/packages.sh --help` |
| Shell abbreviations | `abbr` (defined in `fish/.config/fish/conf.d/abbr.fish`) |
| Git aliases | `git config --get-regexp '^alias\.'` |
| Brew formulae, casks, fonts | `packages/Brewfile` |
| DOX docs present | `find . -name AGENTS.md -not -path './.git/*'` |

Confirm a path or command exists before acting on it, including ones written in this file. These docs previously described a `bootstrap.sh` and `just doctor`/`sync`/`prune`/`snapshot` recipes that do not exist on `master`.

---

# DOX framework

- DOX is highly performant AGENTS.md hierarchy installed here
- Agent must follow DOX instructions across any edits

## Core Contract

- AGENTS.md files are binding work contracts for their subtrees
- Work products, source materials, instructions, records, assets, and durable docs must stay understandable from the nearest applicable AGENTS.md plus every parent AGENTS.md above it

## Read Before Editing

1. Read the root AGENTS.md
2. Identify every file or folder you expect to touch
3. Walk from the repository root to each target path
4. Read every AGENTS.md found along each route
5. If a parent AGENTS.md lists a child AGENTS.md whose scope contains the path, read that child and continue from there
6. Use the nearest AGENTS.md as the local contract and parent docs for repo-wide rules
7. If docs conflict, the closer doc controls local work details, but no child doc may weaken DOX

Do not rely on memory. Re-read the applicable DOX chain in the current session before editing.

## Update After Editing

Every meaningful change requires a DOX pass before the task is done.

Update the closest owning AGENTS.md when a change affects:

- purpose, scope, ownership, or responsibilities
- durable structure, contracts, workflows, or operating rules
- required inputs, outputs, permissions, constraints, side effects, or artifacts
- user preferences about behavior, communication, process, organization, or quality
- AGENTS.md creation, deletion, move, rename, or index contents

Update parent docs when parent-level structure, ownership, workflow, or child index changes. Update child docs when parent changes alter local rules. Remove stale or contradictory text immediately. Small edits that do not change behavior or contracts may leave docs unchanged, but the DOX pass still must happen.

## Hierarchy

- Root AGENTS.md is the DOX rail: project-wide instructions, global preferences, durable workflow rules, and the top-level Child DOX Index
- Child AGENTS.md files own domain-specific instructions and their own Child DOX Index
- Each parent explains what its direct children cover and what stays owned by the parent
- The closer a doc is to the work, the more specific and practical it must be

## Child Doc Shape

- Create a child AGENTS.md when a folder becomes a durable boundary with its own purpose, rules, responsibilities, workflow, materials, or quality standards
- Work Guidance must reflect the current standards of the project or user instructions; if there are no specific standards or instructions yet, leave it empty
- Verification must reflect an existing check; if no verification framework exists yet, leave it empty and update it when one exists
- Update the CHANGELOG.md to always be in sync with the release created.

Default section order:
- Purpose
- Ownership
- Local Contracts
- Work Guidance
- Verification
- Child DOX Index

## Style

- Keep docs concise, current, and operational
- Document stable contracts, not diary entries
- Put broad rules in parent docs and concrete details in child docs
- Prefer direct bullets with explicit names
- Do not duplicate rules across many files unless each scope needs a local version
- Delete stale notes instead of explaining history
- Trim obvious statements, repeated rules, misplaced detail, and warnings for risks that no longer exist

## Closeout

1. Re-check changed paths against the DOX chain
2. Update nearest owning docs and any affected parents or children
3. Refresh every affected Child DOX Index
4. Remove stale or contradictory text
5. Run existing verification when relevant
6. Report any docs intentionally left unchanged and why

## User Preferences

- OMP uses its upstream release updater. Harness-update commands in Topgrade and shell abbreviations must call `omp update` directly; do not route through a local patched-source wrapper unless Ed explicitly reinstates one.
- Agent commits and PRs use Atlas-Key (`296298943+Atlas-Key@users.noreply.github.com`) signed with `/Users/ed/.ssh/atlas_signing`. Manual commits keep Ed's identity and the machine key in `.gitconfig.local`. Set Atlas as repo-local git user/signingkey only for the agent commit, then unset. Open PRs as Atlas-Key and request `edheltzel` as reviewer. Details: `git/AGENTS.md`.
- When the user requests another durable behavior change, record it here or in the relevant child AGENTS.md.

## Child DOX Index

Stow packages (symlinked into `~`):

- `config/` — application configs for 30+ tools (`~/.config`) — has child: `config/.config/wezterm/`
- `fish/` — Fish shell config (primary shell, lazy-loading)
- `git/` — git config, SSH signing, per-machine provisioning
- `dots/` — miscellaneous `$HOME` dotfiles; owns the shared stow global ignore
- `local/` — user-specific data (`~/.local`)
- `zsh/` — secondary shell config
- `neovim/` — Neovim (NEO.ED) — **git submodule**, separate repo, not part of this DOX tree

Infrastructure (run by `install.sh`, not stowed):

- `packages/` — multi-package-manager provisioning (`packages.sh` + manifests)
- `scripts/` — shared shell helpers (`functions.sh`, `nvim.sh`) sourced by the install flow
- `.githooks/` - tracked git hook sources (`pre-commit`, `commit-msg`); `just hooks` installs wrappers into `.git/hooks` and unsets `core.hooksPath` so GitButler cannot overwrite tracked files
- `macos/` — macOS system preference scripts
- `duti/` — default app / file associations

`AGENTS.md` files are excluded from stow (via each package's `.stow-local-ignore` or the shared `~/.stow-global-ignore`), so DOX docs stay repo-only and are never symlinked into `~`.
