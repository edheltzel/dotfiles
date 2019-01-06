# Dotfiles
Gotta thank [kalis.me blog post](https://kalis.me/dotfiles-automating-macos-system-configuration/) for the simple setup, but what you'll find is a configuration for my personal needs, surrounding front-end web development -- NodeJS + React, CSS Wizadary with SCSS and the soft spot in my ❤️ for [Jekyll](https://jekyllrb.com).

## Usage and the Install
1. Restore your safely backed up ssh keys to `~/.ssh/`
    1. Alternatively, [generate new ssh keys](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/), and add these to your GitHub account.
2. Install Homebrew and Git

  ```bash
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  ```

  ```bash
    brew install git
  ```
3. Clone this repository

  ```
  git clone git@github.com:ginfuru/dotfiles.git
  ```
4. Run the `bootstrap.sh` script
    1. Alternatively, only run the `setup.sh` scripts in specific subfolders if you don't need everything
5. Install [Fisher](https://github.com/jorgebucaran/fisher) and Plugins -- _Optional_
```bash
curl -Lo curl -L ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
fisher
```


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

* `Brewfile`
* `gem install.list`
* `npm isntall -g.list`
* `pip install.list`
* `pip3 install.list`

#### Repos
This folder is a collection of my own repos, most are private `¯\_(ツ)_/¯`. The existing lists can easily be edited or replaced by custom lists. **note:** for each file you have a new folder will be created based on the file'sname.

## Contents

### Root (/)
* bootstrap.sh - Calls all setup.sh scripts and executes.

### Duti (duti/)
* setup.sh - Sets the defaults set up in the different files
* `app.package.id` - Contains all extensions for the specified program _(run `man duti` to learn more)_

### Fonts (fonts/)
* setup.sh - Installs Fonts
* ~~FiraCode.otf - for my text editor~~
**Note:** I have moved to used Cask to install fonts.

### Fish (fish/)
* setup.sh - Symlinks all fish files to their corresponding location in `~/.config/fish/`
* config.fish - Global fish configuration _(.fishrc)_
* _aliases.fish - Contains all aliases for completions
* _colors.fish - Sets the colors for `xterm-256color` and `LS_COLORS`
* _exports.fish - sets custom Exports ie: `$EDITOR`
* `fishfile` - list of [Fisher](https://github.com/jorgebucaran/fisher) plugins to install
* `completions/`
  * **NOTE:** considering removing this and sticking with `Z`
  * repo.fish - Contains all repos as completions for the `repo` command
  * repodir.fish - Contains all repos as completions for the `repodir` command
* `functions/`
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
  * ~~update.fish~~ - Using a Fisher plugin, [Update](https://github.com/publicarray/update) _(see `fishfile`)_

### Git (git/)
* setup.sh - Symlinks all git files to `~/`
* .gitignore_global - Contains global gitignores, such as OS-specific files and
several compiled files
* .gitconfig - Sets several global Git variables

### macOS Preferences (macos/)
* setup.sh - Executes a long list of commands pertaining to macOS Preferences
  * **I can not stress enough to read this and change this for what works for you.**

### Misc Dotfiles (misc/)
* setup.sh - Symlinks all the associated rc and other dot files to your `~/` _(home directory)_

### Packages (packages/)
* setup.sh - Installs the contents of the `.list` files and the Brewfile

### Repositories (repos/)
* setup.sh - Clones the repositories in the `.list` files at the corresponding
locations

### Helper Scripts (scripts/)
* functions.sh - Contains helper functions for symlinking files and printing
  progress messages

