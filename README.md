<img src="_images/dotfiles-logo.png" alt="dotfiles logo" width="350">

---

An experimental, ongoing configuration for my personal needs using macOS, Fish shell, Git, and front-end web development.

My playground revolves around devops and frontend development which includes all things JavaScript, CSS Wizardry with Scss, SSG/JAMStack – mainly [11ty](https://www.11ty.dev/), [Hugo](https://gohugo.io/), and I have this soft spot in my ❤️ for the OG [Jekyll](https://jekyllrb.com).

## Terminal toolkit with replacements for [Unix commands](https://en.wikipedia.org/wiki/List_of_Unix_commands)
I find tools that are built with Rust or Go to be performant and cover 90% of my use cases.

- [bat](https://github.com/sharkdp/bat) Rust replacement for `cat`
- [exa](https://the.exa.website/) Rust replacement for `ls`
- [fd](https://github.com/sharkdp/fd) Rust replacement for `find`
- [fzf](https://github.com/junegunn/fzf) a mostly Go fuzzy finder
- [zoxide](https://github.com/ajeetdsouza/zoxide) Rust companion for `cd` and replacement for z and autojump
- [bottom](https://clementtsang.github.io/bottom/0.8.0/) Rust replacement for `top`
- [ripgrep](https://github.com/BurntSushi/ripgrep) Rust replace for `grep`
- [tldr](https://tldr.sh/) Rust replace for `man`
- [procs](https://github.com/dalance/procs) Rust replace for `ps`

## Usage and the Install

**Caveats**
If you are on any version of macOS that uses AFPS, you'll need to disable the SIP.
First check to see if SIP is enabled or not.

```shell
csrutil status
```

output should read:

```shell
System Integrity Protection status: enabled.
```

If your SIP is enabled, then follow the next steps to disable it – Assuming that you know what you're doing, here is how to turn off System Integrity Protection on your Mac.

1 Turn off your Mac (Apple > Shut Down).
2 Hold down Command-R and press the Power button. Keep holding Command-R until the Apple logo appears.
3 Wait for OS X to boot into the OS X Utilities window.
4 Choose Utilities > Terminal.
5 Enter csrutil disable.
6 Enter reboot.
7 `csrutil status` -> should read `System Integrity Protection status: disabled.`

1. Restore your safely backed up ssh keys to `~/.ssh/`

  - I personally use Dropbox to keep these keys and configuration in sync with my devices, it's not ideal but works for me:
      - `touch ~/Dropbox/.ssh-config && ln -s ~/Dropbox/.ssh-config ~/.ssh/config`
    -  Alternatively, [generate new ssh keys](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/), and add these to your GitHub account.

2. Install Homebrew and Git

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

```bash
  brew install git
```

3. Clone this repository

```
git clone git@github.com:edheltzel/dotfiles.git
```

4. Run the `bootstrap.sh` script
   1. Alternatively, only run the `setup.sh` scripts in specific subfolder if you don't need everything
5. Install [Fisher](https://github.com/jorgebucaran/fisher) and Plugins -- _Optional_

```bash
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
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
- `npm install -g.list`
- `pip install.list`
- `pip3 install.list`

#### Repos

This folder is a collection of my own repos, most are private `¯\_(ツ)_/¯`. The existing lists can easily be edited or replaced by custom lists. **note:** for each file you have a new folder will be created based on the file's name.

## Contents

### Root (/)

- bootstrap.sh - Calls all setup.sh scripts and executes.

### Duti (duti/)

- setup.sh - Sets the defaults set up in the different files
- `app.package.id` - Contains all extensions for the specified program _(run `man duti` to learn more)_

### Fonts (fonts/)

- ~~setup.sh - Installs Fonts~~
- ~~FiraCode.otf - for my text editor~~

> **Note:** I have moved to using Brew Cask to install fonts via [Nerd Fonts](https://www.nerdfonts.com/) > **FireCode** for my text editor

### Fish (fish/)

- setup.sh - Symlinks all fish files to their corresponding location in `~/.config/fish/`
- config.fish - Global fish configuration _(.fishrc)_
- \_importSources.fish - used to source the `customs` directory: this allows the usage of a single file to have multiple functions.
  - \_aliases.fish - Contains all aliases for completions
  - \_colors.fish - Sets the colors for `xterm-256color` and `LS_COLORS`
  - \_exports.fish - sets custom Exports ie: `$EDITOR`
- `fishfile` - list of [Fisher](https://github.com/jorgebucaran/fisher) plugins to install
- `completions/`
  - **NOTE:** considering removing this and sticking with `Z` + aliases/abbreviations
  - repo.fish - Contains all repos as completions for the `repo` command
  - repodir.fish - Contains all repos as completions for the `repodir` command
- `functions/`
  - abbrex.fish - Utility for expanding abbreviations in fish-scripts
  - emptytrash.fish - Empties trash and clears system logs
  - fish_greeting.fish - My personal fish greeting using the full-color fish logo
  - fish_right_prompt.fish - Left Blank on purpose
  - fish_prompt.fish Using [Starship - The cross-shell prompt for astronauts](https://starship.rs/)
    - check out `prompt> startship.toml` to modify the starship prompt
  - forrepos.fish - Executes a passed command for all repos in `~/Projects`
  - pubkey.fish - Copies the public key to the clipboard
  - repo.fish - Finds a repository in `~/Projects` and jumps to it **NOTE:currently using `Z`**
  - repodir.fish - Finds a repository in `~/Projects` and prints its path
  - setup.fish - Initial setup for a new fish installation,
    contains abbreviations
  - speedtest.fish - **macOS ONLY** leverages the built-in `networkQuality` cli tool - just a glorified alias but works with all the flag options
    - run `speedtest`

```shell
==== SUMMARY ====
Upload capacity: 125.773 Mbps
Download capacity: 540.165 Mbps
Upload flows: 20
Download flows: 20
Responsiveness: Medium (218 RPM)
Base RTT: 121
Start: 12/5/21, 7:42:03 AM
End: 12/5/21, 7:42:20 AM
OS Version: Version 12.0.1 (Build 21A559)
```

#### Update All The Things

- using [Topgrade by r-darwish](https://github.com/r-darwish/topgrade) -- see `prompt > topgrade.tmol` for config options.
- a fish function exist `upp` to check current global node version and to run the `topgrade` command

### Git (git/)

- setup.sh - Symlinks all git files to `~/`
- .gitignore_global - Contains global gitignores, such as OS-specific files and
  several compiled files
- .gitconfig - Sets several global Git variables - also include signing

  - _(options)_: GPG signing is set to `TRUE` by default
    [renew expired gpg](https://gist.github.com/krisleech/760213ed287ea9da85521c7c9aac1df0)

  [Generate new key and assign to global git config](https://gist.github.com/paolocarrasco/18ca8fe6e63490ae1be23e84a7039374#:~:text=It%20means%20that%20is%20not,secret%20keys%20available%20in%20GPG.)

  main take away:

  - `gpg --list-secret-keys --keyid-format=long`
  - Copy key
  - set key for your git user
    - `git config --global user.signingkey <your key>`

  git config --global user.signingkey <your key>

  - <img alt="look ma' verified" src="https://rdmcrew.d.pr/f11jZt+" width="500"/>
  - If you need help setting this up GPG:
    - follow the Github article for [Signing Commits](https://help.github.com/en/articles/signing-commits) to set up you GPG key(s).
    - I found this [GIST helpful](https://gist.github.com/cezaraugusto/2c91d141ddec026753051ffcace3f1f2)
    - To get VSCode setup follow this [article](https://dev.to/devmount/signed-git-commits-in-vs-code-36do)
  - **Please Note** if you used the [Brewfile](https://github.com/edheltzel/dotfiles/blob/master/packages/Brewfile), Cask installed the macOS [GPG Suite](https://gpgtools.org/) via `cask 'gpg-suite-no-mail'` -- _(alternatively)_ update the [Brewfile](https://github.com/edheltzel/dotfiles/blob/master/packages/Brewfile) with `cask 'gpg-suite' to include GPGMail.

  - If you **DO NOT** want to enable GPG run `git config --global commit.gpgsign false` and remove the GPG packages from the [Brewfile](https://github.com/edheltzel/dotfiles/blob/master/packages/Brewfile).

### macOS Preferences (macos/)

- setup.sh - Executes a long list of commands pertaining to macOS Preferences
  - **I can not stress enough to read this and change this for what works for you.**
  - **DO NOT** blindly run this script - it is a WIP with each macOS update things change.

### Misc Dotfiles (misc/)

- setup.sh - Symlinks all the associated rc and other dot files to your `~/` _(home directory)_
- Special Mentions:
  - `.tigrc` - [tig](https://jonas.github.io/tig/) – configured with pretty colors and layout for git diff and logs
  - `.eslintrc` - has specific configuration for my JS workflow
  - `bat/config` - [bat](https://github.com/sharkdp/bat) – a clone of cat with syntax highlighting
  -

### Packages (packages/)

- setup.sh - Installs the contents of the `.list` files and the Brewfile

### Repositories (repos/)

- setup.sh - Clones the repositories in the `.list` files at the corresponding
  locations

### Vim (vim/)

I'd suggest you take a look at this configuration - I use NeoVim when I need Vim

- [AstroNvim](https://astronvim.github.io/configuration/basic_configuration) is the distribution I use.
- setup.sh - Symlinks all vim files to `~/.config/nvim`

### Helper Scripts (scripts/)

- functions.sh - Contains helper functions for symlinked files and printing
  progress messages

### VSCODE (vscode/)

VSCode is my default editor but I also use NeoVim.

- `markdown-pdf-vue.css` - custom styles for markdown to PDF/HTML exporting
- ~~I use the [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) extension to keep my configuration in a gist.~~
- VSCode has a native syncing option using your Github account - I'd suggest that for either the stable or insiders

- Make sure you add `code` and/or `code-insiders` to your PATH
- run `⌘+⇧+p` then type `Shell Command: Install 'code-insiders' command in PATH`

  - ![install vscode inside of PATH](_images/install-vscode-in-path.png)

- Notable Extensions I Use:
  - Keybindings: [VSpaceCode](https://vspacecode.github.io/)
  - Project management: [Git Project Manager](https://marketplace.visualstudio.com/items?itemName=felipecaputo.git-project-manager)
  - Remote development: [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
  - API client: [Thunder Client](https://marketplace.visualstudio.com/items?itemName=rangav.vscode-thunder-client)
  - [1Dark Raincoat](https://marketplace.visualstudio.com/items?itemName=ginfuru.ginfuru-onedark-raincoat-theme) 👈 self plug
  - [Better Solarized](https://marketplace.visualstudio.com/items?itemName=ginfuru.ginfuru-better-solarized-dark-theme) 👈 self plug

### Node development

Node Version switching for Node development, takes advantage of [fnm](https://github.com/Schniz/fnm) for managing Node versions, which supports both `.nvmrc` and `.node-version` files.

- Install happens in the `Brewfile` by running

```shell
brew install fnm
```

For Completions run:

```shell
fnm completions --shell fish
```

Make sure you run:

```shell
./fish/./setup.sh
```

This will symlink the `fnm.fish` file in `~/.config/fish/conf.d` _(It might be helpful to `source ~/.config/fish/config.fish`)_
# TODO

- [ ] need to reorder install of packages
- [ ] `gem install.list` should come after Homebrew and before for Fish

#### Special Thanks

Gotta thanks to [kalis.me blog post](https://kalis.me/dotfiles-automating-macos-system-configuration/) for the simple setup,
