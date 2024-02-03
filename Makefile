STOW_PACKAGES := dots git fish nvim config warp vscode

.PHONY: all
all: help

.PHONY: help
help: ## Show this help message (default)
	@awk 'BEGIN {FS = ":.*?## "}; \
		/^[^\t][a-zA-Z0-9_-]+:.*?##/ \
		{ printf "\033[36m%-24s\033[0m %s\n", $$1, $$2 } \
		/^##/ { printf "\033[33m%s\033[0m\n", substr($$0, 4) }' $(MAKEFILE_LIST)

.PHONY: stow
stow: ## Symlink all dotfiles managed by Stow
	@for pkg in $(STOW_PACKAGES); do \
		stow $$pkg; \
	done
	@echo "Dotfiles stowed successfully"

.PHONY: unstow
unstow: ## Remove all dotfiles managed by Stow
	@for pkg in $(STOW_PACKAGES); do \
		stow --delete $$pkg; \
	done
	@echo "Dotfiles zapped! ⚡️"

.PHONY: update
update: ## Update dotfiles & remove broken symlinks managed by Stow
	@for pkg in $(STOW_PACKAGES); do \
		stow --restow $$pkg; \
	done
	@echo "Dotfiles updated successfully"
