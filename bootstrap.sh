#!/usr/bin/env bash

# Define the source and target locations
SOURCE="https://github.com/edheltzel/dotfiles"
TARBALL="$SOURCE/tarball/master"
TARGET="$HOME/.dotfiles"
TAR_CMD="tar -xzv -C \"$TARGET\" --strip-components=1 --exclude='{.gitignore}'"

# Function to check if a command is executable
is_executable() {
	type "$1" >/dev/null 2>&1
}

# check for git, curl, or wget
# Determine the download commands based on available tools
if is_executable "git"; then
	CMD="git clone $SOURCE $TARGET"
elif is_executable "curl"; then
	CMD="curl -#L $TARBALL | $TAR_CMD"
elif is_executable "wget"; then
	CMD="wget --no-check-certificate -O - $TARBALL | $TAR_CMD"
fi

# Execute the download command or abort if no tools are available
if [ -z "$CMD" ]; then
	echo "No git, curl, or wget available. Aborting."
else
	echo "Installing dotfiles..."
	mkdir -p "$TARGET"
	eval "$CMD"

	# Check if install.sh exists
	if [ -f "$TARGET/install.sh" ]; then
		# Prompt the user for confirmation before proceeding
		read -p "Do you want to continue with the installation? [y/N] " -n 1 -r
		echo # Move to a new line
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			echo "Running install script..."
			bash "$TARGET/install.sh"
		else
			echo "Installation aborted by user."
			exit 1
		fi
	else
		echo "Error: install.sh not found in the dotfiles repository."
		exit 1
	fi
fi
