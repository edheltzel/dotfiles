# packages — multi-package-manager provisioning

## Purpose

Installs/uninstalls packages across every package manager. NOT a stow package — run directly by `install.sh`, never symlinked.

## Ownership

- `packages.sh` — subcommand dispatcher
- Manifests: `Brewfile` (Homebrew CLI/casks/fonts), `node_packages.txt`, `bun_packages.txt`, `pnpm_packages.txt`, `ruby_packages.txt`, `rust_packages.txt`

## Local Contracts

- Usage: `./packages.sh [action] [target]`.
  - Bare target installs: `./packages.sh bun`
  - Explicit: `./packages.sh install pnpm` / `./packages.sh uninstall bun`
  - No args = `install all`; `uninstall all` removes in reverse order (JS toolchains first, brew last).
- Targets: `brew`, `node`, `bun`, `pnpm`, `ruby`, `rust`, `all`. `--help` for full reference.
- Add a package by editing the correct manifest, not by hardcoding it in `packages.sh`.
- Bun owns global JavaScript CLIs. Keep Vite+ for project tooling only; do not install duplicate globals with `vp install -g`.

## Work Guidance

- Use `bun`/`bunx` for JS tooling, never `npm`/`npx`.
- Sources `../scripts/functions.sh` for logging helpers.
- Cargo installs failing under a brew-managed toolchain: `brew uninstall rustup-init`, `brew reinstall rust`, `cargo install cargo-update --force`, then `topgrade --only cargo`.

## Verification

- `shellcheck packages.sh`
- `bun pm ls -g` lists Bun-owned globals; `vp list -g` reports none.

## Child DOX Index

No children.
