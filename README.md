<img src="_images/dotfiles-logo.png" alt="dotfiles logo" width="350">

---

An experimental, ongoing configuration for my personal needs using macOS, Fish shell, Git, and front-end web development.

My playground revolves around the use of, Go, JavaScript + NodeJS, CSS Wizadary with Scss and the soft spot in my ❤️ for [Jekyll](https://jekyllrb.com).

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

- The `.gitconfig` file includes my [user] config, replace these with your own user name and email
  - Almost all of git aliases are located in `.gitconfig` versus `_aliases.fish` or `fish/functions/setup.fish` - I've found this to work best for me.
- Also check the `.gitignore_global` for anything you might want to add or remove.

#### OSX

- At the top of the setup.sh file, my computer name is set as `MacDaddy` - might want to change it.

#### Packages

This folder is a collection of the programs and utilities I use. The lists can easily be amended for your workflow.

- `Brewfile`
- `gem install.list`
- `npm isntall -g.list`
- `pip install.list`
- `pip3 install.list`

#### Repos

This folder is a collection of my own repos, most are private `¯\_(ツ)_/¯`. The existing lists can easily be edited or replaced by custom lists. **note:** for each file you have a new folder will be created based on the file'sname.

## Contents

### Root (/)

- bootstrap.sh - Calls all setup.sh scripts and executes.

### Duti (duti/)

- setup.sh - Sets the defaults set up in the different files
- `app.package.id` - Contains all extensions for the specified program _(run `man duti` to learn more)_

### Fonts (fonts/)

- setup.sh - Installs Fonts
- ~~FiraCode.otf - for my text editor~~

> **Note:** I have moved to using Cask to install fonts via [Nerd Fonts](https://www.nerdfonts.com/)

### Fish (fish/)

- setup.sh - Symlinks all fish files to their corresponding location in `~/.config/fish/`
- config.fish - Global fish configuration _(.fishrc)_
- \_importSources.fish - used to source the `customs` directory: this allows the useage of a single file to have multiple functions.
  - \_aliases.fish - Contains all aliases for completions
  - \_colors.fish - Sets the colors for `xterm-256color` and `LS_COLORS`
  - \_exports.fish - sets custom Exports ie: `$EDITOR`
- `fishfile` - list of [Fisher](https://github.com/jorgebucaran/fisher) plugins to install
- `completions/`
  - **NOTE:** considering removing this and sticking with `Z`
  - repo.fish - Contains all repos as completions for the `repo` command
  - repodir.fish - Contains all repos as completions for the `repodir` command
- `functions/`
  - abbrex.fish - Utility for expanding abbreviations in fish-scripts
  - emptytrash.fish - Empties trash and clears system logs
  - fish_greeting.fish - My personal fish greeting using the full-color fish logo
  - fish_right_prompt.fish - Left Blank on purpse
  - ~~fish_prompt.fish~~ - Is Installed [Spacefish - A Fish Shell prompot of Astronauts](https://github.com/matchai/spacefish)
  - ~~Spacefish~~ - Using [Starship - The cross-shell prompt for astronauts](https://starship.rs/)
  - forrepos.fish - Executes a passed command for all repos in `~/Projects`
  - pubkey.fish - Copies the public key to the clipboard
  - repo.fish - Finds a repository in `~/Projects` and jumps to it **NOTE:currently using `Z`**
  - repodir.fish - Finds a repository in `~/Projects` and prints its path
  - setup.fish - Initial setup for a new fish installation,
    contains abbreviations
  - ~~update.fish~~ - Using a Fisher plugin, [Update](https://github.com/publicarray/update) _(see `fishfile`)_

### Git (git/)

- setup.sh - Symlinks all git files to `~/`
- .gitignore_global - Contains global gitignores, such as OS-specific files and
  several compiled files
- .gitconfig - Sets several global Git variables - also include GPG signing

  - _(options)_: GPG signing is set to `TRUE` by default

    - <img alt="look ma' verified" src="https://rdmcrew.d.pr/f11jZt+" width="500"/>
    - If you need help setting this up GPG:
      - follow the Github article for [Signing Commits](https://help.github.com/en/articles/signing-commits) to set up you GPG key(s).
      - I found this [GIST helpful](https://gist.github.com/cezaraugusto/2c91d141ddec026753051ffcace3f1f2)
      - To get VSCode setup follow this [article](https://dev.to/devmount/signed-git-commits-in-vs-code-36do)
    - **Please Note** if you used the [Brewfile](https://github.com/ginfuru/dotfiles/blob/master/packages/Brewfile), Cask installed the macOS [GPG Suite](https://gpgtools.org/) via `cask 'gpg-suite-no-mail'` -- _(alternatively)_ update the [Brewfile](https://github.com/ginfuru/dotfiles/blob/master/packages/Brewfile) with `cask 'gpg-suite' to include GPGMail.

    - If you **DO NOT** want to enable GPG run `git config --global commit.gpgsign false` and remove the GPG packages from the [Brewfile](https://github.com/ginfuru/dotfiles/blob/master/packages/Brewfile).

### macOS Preferences (macos/)

- setup.sh - Executes a long list of commands pertaining to macOS Preferences
  - **I can not stress enough to read this and change this for what works for you.**

### Misc Dotfiles (misc/)

- setup.sh - Symlinks all the associated rc and other dot files to your `~/` _(home directory)_

### Packages (packages/)

- setup.sh - Installs the contents of the `.list` files and the Brewfile

### Repositories (repos/)

- setup.sh - Clones the repositories in the `.list` files at the corresponding
  locations

### Vim (vim/)

I'd suggest you take a look at this file

- setup.sh - Symlinks all vim files to `~/`
- .vimrc - Basic Vim configuration
- If you feel bold, you could just open vim and run `:PlugInstall`

### Helper Scripts (scripts/)

- functions.sh - Contains helper functions for symlinking files and printing
  progress messages

### VSCODE ~~(vscode/)~~

VSCode Insiders is my default editor.

- I use the [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) extention to keep my configuration in a gist.
- Make sure you add `code` and/or `code-insiders` to your Path - run `⌘+⇧+P` type `Shell Command: Install 'code-insiders' command in PATH`
- **Self Plug**
  - Try out my VSCode theme - [1Dark Raincoat](https://marketplace.visualstudio.com/items?itemName=ginfuru.ginfuru-onedark-raincoat-theme)

### Node development

Auto Node Version switching for Node development, takes advantage of [NVM](https://github.com/nvm-sh/nvm) for managing Node versions and using two Fish plugins, [edc/bass](https://github.com/edc/bass) and [fish-avn](https://github.com/martinkacmar/fish-avn). This workflow supports both `.nvmrc` and `.node-version` files.

- Install NVM by using the [install script](https://github.com/nvm-sh/nvm#installing-and-updating)
- BASS allows the use of utilities written for bash
- Fish-AVN handles auto switching and reading either `.nvmrc` or `.node-version`

#### Special Thanks

Gotta thanks to [kalis.me blog post](https://kalis.me/dotfiles-automating-macos-system-configuration/) for the simple setup,
