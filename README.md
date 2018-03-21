# Dotfiles
Gotta thank [Raklis dotfile](https://github.com/rkalis/dotfiles) for the simple setup, but what you'll find is a configuration for my personal needs, surrounding front-end web development -- NodeJS + React, CSS Wizadary with SCSS and the soft spot in my ❤️ for [Jekyll](https://jekyllrb.com).

## Usage and the Install
1. Restore your safely backed up ssh keys to `~/.ssh/`
    1. Alternatively, [generate new ssh keys](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/), and add these to your GitHub account.
2. Install Homebrew and git

  ```bash
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew install git
  ```
3. Clone this repository

  ```
  git clone git@github.com:ginfuru/dotfiles.git
  ```
4. Run the `bootstrap.sh` script
    1. Alternatively, only run the `setup.sh` scripts in specific subfolders if you don't need everything

## Customization
I strongly encourage you to play around with the configurations, and add or remove features.
If you would like to use these dotfiles for yourself, I'd recommend changing at least the following:

#### Git
* The `.gitconfig` file includes my [user] config, replace these with your own user name and email
  * Almost all of git aliases are located in `.gitconfig` versus `_aliases.fish` or `fish/functions/setup.fish` - I've found this to work best for me. 
* Also check the `.gitignore_global` for anything you might want to add or remove.

#### OSX
* At the top of the setup.sh file, my computer name is set as `MacDaddy` - might want to change it.

####  Packages
This folder is a collection of the programs and utilities I use. The lists can easily be amended for your workflow.

* brewfile
* gem.list
* npm -g.list
* pip3.ist

#### Repos
This folder is a collection of my own repos, some of which are even private. The existing lists can easily be edited or replaced by custom lists.

## Contents

### Root (/)
* bootstrap.sh - Calls all setup.sh scripts and executes.

### Duti (duti/)
* setup.sh - Sets the defaults set up in the different files
* app.package.id - Contains all extensions for the specified program

### Fish (fish/)
* setup.sh - Symlinks all fish files to their corresponding location in `~/.config/fish/`
* config.fish - Global fish configuration _(.fishrc)_
* _aliases.fish - Contains all aliases for completions
* _colors.fish - Sets the colors for `xterm-256color` and `LS_COLORS`
* _exports.fish - sets custom Exports ie: `$EDITOR`

* completions/
  * **NOTE:** considering removing this and sticking with `Z`
  * repo.fish - Contains all repos as completions for the `repo` command
  * repodir.fish - Contains all repos as completions for the `repodir` command
* functions/
  * abbrex.fish - Utility for expanding abbreviations in fish-scripts
  * emptytrash.fish - Empties trash and clears system logs
  * fish_greeting.fish - My personal fish greeting using the full-color fish logo
  * fish_right_prompt.fish - Left Blank on purpse
  * ~~fish_prompt.fish~~ - Using [Spacefish - A Fish Shell prompot of Astronauts](https://github.com/matchai/spacefish) 
  * forrepos.fish - Executes a passed command for all repos in `~/Projects`
  * pubkey.fish - Copies the public key to the clipboard
  * repo.fish - Finds a repository in `~/Projects` and jumps to it **NOTE:currently using `Z`**
  * repodir.fish - Finds a repository in `~/Projects` and prints its path
  * setup.fish - Initial setup for a new fish installation,
  contains abbreviations
  * ~~update.fish~~ - using a Fisherman plugin, [Update](https://github.com/publicarray/update) _(see `fishfile`)_

### Git (git/)
* setup.sh - Symlinks all git files to `~/`
* .gitignore_global - Contains global gitignores, such as OS-specific files and
several compiled files
* .gitconfig - Sets several global Git variables

### macOS Preferences (macos/)
* setup.sh - Executes a long list of commands pertaining to macOS Preferences
  * **I can not stress enough to read this and change this for what works for you.**

### Packages (packages/)
* setup.sh - Installs the contents of the .list files and the Brewfile

### Repositories (repos/)
* setup.sh - Clones the repositories in the .list files at the corresponding
locations

### Helper Scripts (scripts/)
* functions.sh - Contains helper functions for symlinking files and printing
  progress messages

### Vim (vim/)
* setup.sh - Symlinks all vim files to `~/`
* .vimrc - Basic Vim configuration -- though slighly modified for my needs.
