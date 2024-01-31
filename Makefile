STOW_PACKAGES := dots git fish nvim config warp

.PHONY: help
help: ## Show this help message
	@awk 'BEGIN {FS = ":.*?## "}; \
		/^[^\t][a-zA-Z0-9_-]+:.*?##/ \
		{ printf "\033[36m%-24s\033[0m %s\n", $$1, $$2 } \
		/^##/ { printf "\033[33m%s\033[0m\n", substr($$0, 4) }' $(MAKEFILE_LIST)

.PHONY: stow
stow: ## Symlink all dotfiles managed by Stow
	@for pkg in $(STOW_PACKAGES); do \
		stow $$pkg; \
	done

.PHONY: unstow
unstow: ## Remove all dotfiles managed by Stow
	@for pkg in $(STOW_PACKAGES); do \
		stow --delete $$pkg; \
	done
	@echo "Dotfiles are zapped! 💥 🔫  Good luck 🫡"

.PHONY: update
update: ## Update all dotfiles and remove broken symlinks managed by Stow
	@for pkg in $(STOW_PACKAGES); do \
		stow --restow $$pkg; \
	done
	@echo "Hooray! Dotfiles updated successfully! 🥳"
