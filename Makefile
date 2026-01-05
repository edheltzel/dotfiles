STOW_PACKAGES := atlas dots git fish config neoed local
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
install: ## Bootstraps a new machine
	@echo "$(YELLOW)Running bootstrap to provision the system...$(CLR)"
	@./install.sh
	@echo "$(GREEN)System provisioning complete!$(CLR)"

.PHONY: run
run: ## Symlink all dotfiles w/Stow
	@for pkg in $(STOW_PACKAGES); do \
		stow $$pkg; \
	done
	@echo "Dotfiles stowed successfully"

.PHONY: stow add
stow: ## Add individual packages w/Stow
	@if [ -z "${pkg}" ]; then \
		echo "Error: Please specify a package to stow. \n$(YELLOW)ie: $(YELLOW)make stow pkg=<packageName>$(CLR) \n$(WHITE)Available packages:$(CLR) $(STOW_PACKAGES)"; \
		exit 1; \
	fi
	@if [[ ! " ${STOW_PACKAGES} " =~ " ${pkg} " ]]; then \
		echo "Error: Package '${pkg}' not found in STOW_PACKAGES: $(STOW_PACKAGES)"; \
		exit 1; \
	fi
	stow ${pkg}
	@echo "${pkg} was added"

.PHONY: unstow remove
unstow: ## Remove individual packages w/Stow
	@if [ -z "${pkg}" ]; then \
		echo "Error: Please specify a package to unstow. \n$(YELLOW)ie: $(YELLOW)make unstow pkg=<packageName>$(CLR) \n$(WHITE)Available packages:$(CLR) $(STOW_PACKAGES)"; \
		exit 1; \
	fi
	@if [[ ! " ${STOW_PACKAGES} " =~ " ${pkg} " ]]; then \
		echo "Error: Package '${pkg}' not found in STOW_PACKAGES: $(STOW_PACKAGES)"; \
		exit 1; \
	fi
	stow --delete ${pkg}
	@echo "${pkg} was removed"

.PHONY: update up
update: ## Update all dotfiles packages
	@for pkg in $(STOW_PACKAGES); do \
		if [ "$$pkg" = "fish" ]; then \
			rm -f ~/.config/fish/conf.d/brew.fish ~/.config/fish/conf.d/fish-ssh-agent.fish; \
		fi; \
		stow --restow $$pkg; \
	done
	@echo "$(GREEN)Dotfiles updated successfully$(CLR) - run $(YELLOW)reload$(CLR) to apply changes to Fish"

.PHONY: delete
delete: ## Delete all dotfiles w/Stow
	@for pkg in $(STOW_PACKAGES); do \
		stow --delete $$pkg; \
	done
	@echo "$(WHITE)Dotfiles zapped! ⚡️"

up: update ## Same as update command
add: stow ## Same as stow command
remove: unstow ## Same as unstow command
