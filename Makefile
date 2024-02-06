STOW_PACKAGES := dots git fish nvim config local warp vscode
YELLOW := \033[33m
GREEN := \033[32m
WHITE := \033[37m
CLR := \033[0m

.PHONY: default
default: help

.PHONY: help
help: ## Show this help message (default)
	@awk 'BEGIN {FS = ":.*?## "}; \
		/^[^\t][a-zA-Z0-9_-]+:.*?##/ \
		{ printf "\033[36m%-24s$(CLR) %s\n", $$1, $$2 } \
		/^##/ { printf "$(YELLOW)%s$(CLR)\n", substr($$0, 4) }' $(MAKEFILE_LIST)

.PHONY: install
install: ## Bootsraps a new machine
	@echo "$(YELLOW)Running bootstrap to provision the system...$(CLR)"
	@./install.sh
	@echo "$(GREEN)System provisioning complete!$(CLR)"


.PHONY: run
run: ## Symlink all dotfiles w/Stow
	@for pkg in $(STOW_PACKAGES); do \
		stow $$pkg; \
	done
	@echo "Dotfiles stowed successfully"

.PHONY: stow
stow: ## Add individual packages w/Stow
	@if [ -z "${pkg}" ]; then \
		echo "Error: Please specify a package to stow. \n$(YELLOW)ie: $(YELLOW)make stow pkg=<pacakgeName>$(CLR) \n$(WHITE)Available packages:$(CLR) $(STOW_PACKAGES)"; \
		exit 1; \
	fi
	@if [[ ! " ${STOW_PACKAGES} " =~ " ${pkg} " ]]; then \
		echo "Error: Package '${pkg}' not found in STOW_PACKAGES: $(STOW_PACKAGES)"; \
		exit 1; \
	fi
	stow ${pkg}
	@echo "${pkg} was added"

.PHONY: unstow
unstow: ## Remove individual packages w/Stow
	@if [ -z "${pkg}" ]; then \
		echo "Error: Please specify a package to unstow. \n$(YELLOW)ie: $(YELLOW)make unstow pkg=<pacakgeName>$(CLR) \n$(WHITE)Available packages:$(CLR) $(STOW_PACKAGES)"; \
		exit 1; \
	fi
	@if [[ ! " ${STOW_PACKAGES} " =~ " ${pkg} " ]]; then \
		echo "Error: Package '${pkg}' not found in STOW_PACKAGES: $(STOW_PACKAGES)"; \
		exit 1; \
	fi
	stow --delete ${pkg}
	@echo "${pkg} was removed"

.PHONY: delete
delete: ## Delete all dotfiles w/Stow
	@for pkg in $(STOW_PACKAGES); do \
		stow --delete $$pkg; \
	done
	@echo "$(WHITE)Dotfiles zapped! ⚡️"

.PHONY: update
update: ## Sync & clean dead symlinks w/Stow
	@for pkg in $(STOW_PACKAGES); do \
		stow --restow $$pkg; \
	done
	@echo "$(GREEN)Dotfiles updated successfully$(CLR)"
