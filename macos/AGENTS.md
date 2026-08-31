# macos — system preference scripts

## Purpose

Applies macOS system preferences and security settings. Not a stow package; invoked by `install.sh`.

## Ownership

- `macos.sh` — orchestrator
- `01-preferences.sh`, `02-apps.sh`, `03-security.sh` (Gatekeeper/security)

## Local Contracts

- `defaults write` operations should be idempotent (safe to re-run).
- Sources `../scripts/functions.sh` for logging helpers.

## Work Guidance

Group new settings into the appropriate numbered script by concern (preferences vs apps vs security).

## Verification

`shellcheck macos.sh 0*.sh`.

## Child DOX Index

No children.
