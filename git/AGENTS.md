# git — git config, SSH signing, provisioning (stow package)

## Purpose

Git configuration with SSH commit/tag signing and per-machine provisioning. Maps tracked dotfiles (`.gitconfig`, `.gitignore_global`) → `~`.

## Ownership

- `.gitconfig` — aliases, signing config (`gpg.format=ssh`, `commit.gpgsign=true`), delta pager
- `git.sh` — provisioner: symlinks the machine-specific local config and registers the SSH signing key on GitHub
- `gitconfig-bigmac.local`, `gitconfig-macdaddy.local` — per-machine `~/.gitconfig.local` sources
- `.gitignore_global`
- Aliases live in `.gitconfig`; list them with `git config --get-regexp '^alias\.'` rather than trusting a copied list.
- `core.editor` is `nvim` (`.gitconfig:3`).

## Local Contracts

- Signing uses **SSH keys, not GPG**.
- Machine-specific settings (`user.signingkey`, allowed-signers path) live in `~/.gitconfig.local`, symlinked by `git.sh` keyed on `ComputerName`. Never commit machine paths or keys to tracked files. Tracked `.gitconfig` includes that file last so local values win.
- Manual commits use Ed's identity from tracked `.gitconfig` plus the machine signing key in `.gitconfig.local`.
- Agent / GitButler commits in this repo use the Atlas-Key account and `/Users/ed/.ssh/atlas_signing`. Set those as repo-local git config only for the commit, then unset so manual git stays on Ed's key:
  - `git config --local user.name Atlas`
  - `git config --local user.email 296298943+Atlas-Key@users.noreply.github.com`
  - `git config --local user.signingkey /Users/ed/.ssh/atlas_signing`
  - after the commit: `git config --local --unset-all user.name user.email user.signingkey` (unset each key if git rejects the combined form)
- Open PRs as Atlas-Key, then request `edheltzel` as reviewer (`gh pr edit <n> --add-reviewer edheltzel`). GitHub cannot request a review from the PR author, so an edheltzel-authored PR cannot list him as reviewer. `.github/CODEOWNERS` requests him automatically when the author is Atlas-Key.
- `git.sh`, `gitconfig-*.local`, and `AGENTS.md` are excluded from stow via `.stow-local-ignore`.
- `git.sh` auto-registers the machine's SSH signing key on GitHub if missing (idempotent). Requires `gh` authenticated with the `admin:ssh_signing_key` scope.

## Work Guidance

The signing key MUST be registered on GitHub as a **signing key** or commits show "Unverified" there even when locally valid. A key rotation requires re-running `git.sh` (or re-registration) so GitHub trusts the new key. Agent signatures verify only if `atlas_signing.pub` is a signing key on the Atlas-Key GitHub account.

## Verification

- `git log --show-signature -1` — local signature validity
- `gh api /user/ssh_signing_keys --jq '.[].key'` — key is registered on GitHub
- `gh api /repos/<owner>/<repo>/commits/<sha> --jq '.commit.verification'` — GitHub-side verified status

## Child DOX Index

No children.
