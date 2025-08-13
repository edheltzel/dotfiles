# CRUSH Configuration for Dotfiles Repository

## Build/Test/Lint Commands
- **Install/Bootstrap**: `make install` or `./install.sh`
- **Stow all packages**: `make run` 
- **Stow single package**: `make stow pkg=<packageName>` (dots, git, fish, nvim, config, vscode, local)
- **Update all packages**: `make update` or `make up`
- **Remove package**: `make unstow pkg=<packageName>`
- **Karabiner build**: `cd config/.config/karabiner && bun run build`
- **Karabiner watch**: `cd config/.config/karabiner && bun run start`

## Code Style Guidelines
- **Shell scripts**: Use bash with `set -e`, include function sourcing from `scripts/functions.sh`
- **Fish functions**: Place in `fish/.config/fish/functions/`, use `.fish` extension
- **TypeScript (Karabiner)**: Strict mode enabled, ES2018 target, use explicit imports
- **Config files**: Use appropriate extensions (.toml, .lua, .json, .fish, .sh)
- **Naming**: Use kebab-case for files, snake_case for fish functions, camelCase for TypeScript
- **Documentation**: Include help comments in Makefiles using `## Description` format
- **Stow packages**: Organize configs by logical groupings (dots, git, fish, nvim, config, etc.)
- **File organization**: Keep related configs together, use `.stow-local-ignore` to exclude files
- **Error handling**: Use proper exit codes and error messages in shell scripts
- **Dependencies**: Check for required commands before execution using `is_executable()` pattern

## Repository Structure
This is a dotfiles repository using GNU Stow for symlink management. Main packages: dots, git, fish, nvim, config, vscode, local.