<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## Unreleased

## [v3.3](https://github.com/edheltzel/dotfiles/tree/v3.3) - 2026-06-24

[Full Changelog](https://github.com/edheltzel/dotfiles/compare/v3.2...v3.3)

### Added

- **Vite+ replaces Biome** for Neovim formatting & linting (neoed): `vp fmt` (Oxfmt) on save, live Oxlint LSP diagnostics, `vtsls` for TypeScript, and a `vp check --fix` pre-commit hook
- `hunk` as the git diff pager, with herdr integration (replaces diffnav)
- SSH signing-key auto-registration on GitHub during provisioning (`git/git.sh`) — keeps commits verified after a key rotation
- DOX `AGENTS.md` documentation framework (local, untracked)
- Raycast window management; `visual-recap` GitHub workflow
- Global packages/abbreviations: codegraph, roughdraft, maestro, mosh/moshi, mdv (yazi markdown preview), bettershot

### Changed

- Migrated leaderkey to a Raycast extension
- Herd swapped to the stable release; topgrade runs custom commands; `push.default` matching → simple
- refactor(install): unified bootstrap.sh + install.sh into a single subcommand-driven script [#53](https://github.com/edheltzel/dotfiles/pull/53) ([edheltzel](https://github.com/edheltzel))
- Stow ignores `AGENTS.md` so local agent docs are never symlinked into `$HOME`

### Fixed

- topgrade repos path

## [v3.2](https://github.com/edheltzel/dotfiles/tree/v3.2) - 2026-03-20

[Full Changelog](https://github.com/edheltzel/dotfiles/compare/create...v3.2)

### Other

- Add comprehensive Zsh configuration with Fish parity [#51](https://github.com/edheltzel/dotfiles/pull/51) ([edheltzel](https://github.com/edheltzel))
- Add kitty workspace, statusbar & keymap parity with WezTerm [#50](https://github.com/edheltzel/dotfiles/pull/50) ([edheltzel](https://github.com/edheltzel))
- NeoEd [#49](https://github.com/edheltzel/dotfiles/pull/49) ([edheltzel](https://github.com/edheltzel))
- neovim [#48](https://github.com/edheltzel/dotfiles/pull/48) ([edheltzel](https://github.com/edheltzel))
- Fish4Beta [#47](https://github.com/edheltzel/dotfiles/pull/47) ([edheltzel](https://github.com/edheltzel))
- KEUpdate [#46](https://github.com/edheltzel/dotfiles/pull/46) ([edheltzel](https://github.com/edheltzel))
- SketchybarUpdate [#45](https://github.com/edheltzel/dotfiles/pull/45) ([edheltzel](https://github.com/edheltzel))
- SketchybarUpdate [#44](https://github.com/edheltzel/dotfiles/pull/44) ([edheltzel](https://github.com/edheltzel))
- karabiner update - for mouse events [#43](https://github.com/edheltzel/dotfiles/pull/43) ([edheltzel](https://github.com/edheltzel))
- feature/zsh [#39](https://github.com/edheltzel/dotfiles/pull/39) ([edheltzel](https://github.com/edheltzel))
- feature/zsh [#38](https://github.com/edheltzel/dotfiles/pull/38) ([edheltzel](https://github.com/edheltzel))
- feature/zsh [#37](https://github.com/edheltzel/dotfiles/pull/37) ([edheltzel](https://github.com/edheltzel))
- Update fish shell configuration with multiple prompts [#36](https://github.com/edheltzel/dotfiles/pull/36) ([edheltzel](https://github.com/edheltzel))
- stow [#35](https://github.com/edheltzel/dotfiles/pull/35) ([edheltzel](https://github.com/edheltzel))
- feature/xdg [#34](https://github.com/edheltzel/dotfiles/pull/34) ([edheltzel](https://github.com/edheltzel))
- Feature/xdg [#33](https://github.com/edheltzel/dotfiles/pull/33) ([edheltzel](https://github.com/edheltzel))
- hotfix/randomUpdates [#28](https://github.com/edheltzel/dotfiles/pull/28) ([edheltzel](https://github.com/edheltzel))
- adds fig [#27](https://github.com/edheltzel/dotfiles/pull/27) ([edheltzel](https://github.com/edheltzel))
- hotfix/randomUpdates [#26](https://github.com/edheltzel/dotfiles/pull/26) ([edheltzel](https://github.com/edheltzel))
- hotfix/randomUpdates [#25](https://github.com/edheltzel/dotfiles/pull/25) ([edheltzel](https://github.com/edheltzel))
- hotfix/randomUpdates [#24](https://github.com/edheltzel/dotfiles/pull/24) ([edheltzel](https://github.com/edheltzel))
- fish key bindings are good resolves #22 [#23](https://github.com/edheltzel/dotfiles/pull/23) ([edheltzel](https://github.com/edheltzel))
- global dictionary update [#21](https://github.com/edheltzel/dotfiles/pull/21) ([edheltzel](https://github.com/edheltzel))
- hotfix/randomUpdates [#20](https://github.com/edheltzel/dotfiles/pull/20) ([edheltzel](https://github.com/edheltzel))
- hotfix/randomUpdates [#19](https://github.com/edheltzel/dotfiles/pull/19) ([edheltzel](https://github.com/edheltzel))
- dictionary update [#18](https://github.com/edheltzel/dotfiles/pull/18) ([edheltzel](https://github.com/edheltzel))
- feature/packages [#15](https://github.com/edheltzel/dotfiles/pull/15) ([edheltzel](https://github.com/edheltzel))

## [create](https://github.com/edheltzel/dotfiles/tree/create) - 2023-08-27

[Full Changelog](https://github.com/edheltzel/dotfiles/compare/c54eea8aef30a954d0e9c320ff6b68a44afebe5c...create)
