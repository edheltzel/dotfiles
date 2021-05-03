<img src="_images/dotfiles-logo.png" alt="dotfiles logo" width="350">

---

An experimental, ongoing configuration for my personal needs using macOS, Fish shell, Git, and front-end web development.

My playground revolves around the use of, Go, JavaScript + NodeJS, CSS Wizadary with Scss and the soft spot in my ❤️ for [Jekyll](https://jekyllrb.com).


# TODO

- [ ] need to reorder install of packages
- [ ] `gem install.list` should come after Homebrew and before for Fish

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
If you SIP is enabled, then follow the next steps to disable it – Assuming that you know what you're doing, here is how to turn off System Integrity Protection on your Mac.

1 Turn off your Mac (Apple > Shut Down).
2 Hold down Command-R and press the Power button. Keep holding Command-R until the Apple logo appears.
3 Wait for OS X to boot into the OS X Utilities window.
4 Choose Utilities > Terminal.
5 Enter csrutil disable.
6 Enter reboot.
7 `csrutil status` -> should read `System Integrity Protection status: disabled.` 


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
git clone git@github.com:edheltzel/dotfiles.git
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
- `yarn global add.list`

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
  - **NOTE:** considering removing this and sticking with `Z` + aliases/abbreviations
  - repo.fish - Contains all repos as completions for the `repo` command
  - repodir.fish - Contains all repos as completions for the `repodir` command
- `functions/`
  - abbrex.fish - Utility for expanding abbreviations in fish-scripts
  - emptytrash.fish - Empties trash and clears system logs
  - fish_greeting.fish - My personal fish greeting using the full-color fish logo
  - fish_right_prompt.fish - Left Blank on purpse
  - fish_prompt.fish Using [Starship - The cross-shell prompt for astronauts](https://starship.rs/)
    - check out `prompt> startship.toml` to modifiy the starship prompt
  - forrepos.fish - Executes a passed command for all repos in `~/Projects`
  - pubkey.fish - Copies the public key to the clipboard
  - repo.fish - Finds a repository in `~/Projects` and jumps to it **NOTE:currently using `Z`**
  - repodir.fish - Finds a repository in `~/Projects` and prints its path
  - setup.fish - Initial setup for a new fish installation,
    contains abbreviations
  - For updating - using [Topgrade by r-darwish](https://github.com/r-darwish/topgrade) -- see `prompt > topgrade.tmol` for config options.

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
    - **Please Note** if you used the [Brewfile](https://github.com/edheltzel/dotfiles/blob/master/packages/Brewfile), Cask installed the macOS [GPG Suite](https://gpgtools.org/) via `cask 'gpg-suite-no-mail'` -- _(alternatively)_ update the [Brewfile](https://github.com/edheltzel/dotfiles/blob/master/packages/Brewfile) with `cask 'gpg-suite' to include GPGMail.

    - If you **DO NOT** want to enable GPG run `git config --global commit.gpgsign false` and remove the GPG packages from the [Brewfile](https://github.com/edheltzel/dotfiles/blob/master/packages/Brewfile).

### macOS Preferences (macos/)

- setup.sh - Executes a long list of commands pertaining to macOS Preferences
  - **I can not stress enough to read this and change this for what works for you.**
  - **DO NOT** blindly run this script - it is a WIP with each macOS update things change.

### Misc Dotfiles (misc/)

- setup.sh - Symlinks all the associated rc and other dot files to your `~/` _(home directory)_
- Special Mentions:
  - `.tigrc` - configured with pretty colors and layout for git diff and logs
  - `.eslintrc` - has specific configuration for my JS workflow

### Packages (packages/)

- setup.sh - Installs the contents of the `.list` files and the Brewfile

### Repositories (repos/)

- setup.sh - Clones the repositories in the `.list` files at the corresponding
  locations

### Vim (vim/)

I'd suggest you take a look at this configuration - I use NeoVim

- setup.sh - Symlinks all vim files to `~/.config/nvim`

### Helper Scripts (scripts/)

- functions.sh - Contains helper functions for symlinking files and printing
  progress messages

### VSCODE ~~(vscode/)~~

VSCode is my default editor.

- I use the [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) extention to keep my configuration in a gist.
  - VSCODE has it's own sync options now - so you might want to check that out.
- Make sure you add `code` and/or `code-insiders` to your Path - run `⌘+⇧+P` type `Shell Command: Install 'code-insiders' command in PATH`
- **Self Plug**
  - Try out my VSCode themes
    - [1Dark Raincoat](https://marketplace.visualstudio.com/items?itemName=edheltzel.edheltzel-onedark-raincoat-theme)
    - [Better solarized](https://marketplace.visualstudio.com/items?itemName=edheltzel.edheltzel-better-solarized-dark-theme)

### Node development

Auto Node Version switching for Node development, takes advantage of [NVM](https://github.com/nvm-sh/nvm) for managing Node versions and using two Fish plugins, [edc/bass](https://github.com/edc/bass) and [fish-nvm](https://github.com/FabioAntunes/fish-nvm). This workflow supports both `.nvmrc` and `.node-version` files.

- Install NVM by using the [install script](https://github.com/nvm-sh/nvm#installing-and-updating)
- BASS allows the use of utilities written for bash
- Fish-AVN handles auto switching and reading either `.nvmrc` or `.node-version`

#### Special Thanks

Gotta thanks to [kalis.me blog post](https://kalis.me/dotfiles-automating-macos-system-configuration/) for the simple setup,


#### Mental Notes

      # ====================================================
      # ===   Mental Notes for my persaonal workflow     ===
      # ====================================================
      # Everything below is not for related to any kind of TMUX config - but are crucial
      # for my productivity. Setting them up is REALLY painful, and they are being added
      # here so I don't forget them.

      # ===========================================
      # ===   iTerm + Tmux key integration     ===
      # ==========================================
      # First of all, iTerm can send hex codes for shortcuts you define. So for
      # example you can send a hex code for the shortcut "c-f v" which in my case
      # opens a vertical pane (see setting above). The hex code for this combination
      # is: 0x06 0x76. There are many cases to find it out. One of them is the tool
      # 'xxd'

      # If you run "xxd -psd" and hit "c-f v" and then enter and finally c-c to exit
      # , it outputs the following:
      #
      # 	$ xxd -psd
      # 	^Fv
      # 	06760a^C
      #
      # What matters is the sequence  06760a^C where:
      #
      # 	06 -> c-f
      # 	76 -> v
      # 	0a -> return
      #	^C -> c-c
      #
      # From here, we know that 0x06 0x76 corresponds to "c-f v".
      #
      # Finally, inside the iTerm2 Key settings, I'm adding just various shortcuts,
      # such as cmd-j, cmd-left, etc.. , select the option "send hex code" and the
      # enter the hex code which I want to be executed, hence the tmux sequence. So
      # when I press CMD + d in iterm, I send the sequence 0x06 0x76,
      # which tmux inteprets it as opening a new pane.
      # ============================================================================

      # ==============================================
      # ===   Alacritty + Tmux key integration    ===
      # =============================================
      # First of all, Alacritty can send hex codes for shortcuts you define. So for
      # example you can send a hex code for the shortcut "c-f v" which in my case
      # opens a vertical pane (see setting above). The hex code for this combination
      # is: 0x06 0x76. There are many cases to find it out. One of them is the tool
      # 'xxd'

      # If you run "xxd -psd" and hit "c-f v" and then enter and finally c-c to exit
      # , it outputs the following:
      #
      # 	$ xxd -psd
      # 	^Fv
      # 	06760a^C
      #
      # What matters is the sequence  06760a^C where:
      #
      # 	06 -> c-f
      # 	76 -> v
      # 	0a -> return
      #	^C -> c-c
      #
      # From here, we know that 0x06 0x76 corresponds to "c-f v".
      #
      # Next step is to add a line to 'key_binding' setting in Alacritty:
      #
      #   - { key: D,        mods: Command,       chars: "\x06\x76"  }
      #
      # That's it! The followings are the ones that I'm using:
      #
      #   key_bindings:
      #     - { key: D,        mods: Command,       chars: "\x06\x76" }
      #     - { key: D,        mods: Command|Shift, chars: "\x06\x73" }
      #     - { key: W,        mods: Command,       chars: "\x06\x78" }
      #     - { key: H,        mods: Command,       chars: "\x06\x68" }
      #     - { key: J,        mods: Command,       chars: "\x06\x6a" }
      #     - { key: K,        mods: Command,       chars: "\x06\x6b" }
      #     - { key: L,        mods: Command,       chars: "\x06\x6c" }
      #     - { key: T,        mods: Command,       chars: "\x06\x63" }
      #     - { key: Key1,     mods: Command,       chars: "\x06\x31" }
      #     - { key: Key2,     mods: Command,       chars: "\x06\x32" }
      #     - { key: Key3,     mods: Command,       chars: "\x06\x33" }
      #     - { key: Key4,     mods: Command,       chars: "\x06\x34" }
      #     - { key: Key5,     mods: Command,       chars: "\x06\x35" }
      #     - { key: Key6,     mods: Command,       chars: "\x06\x36" }
      #     - { key: Key7,     mods: Command,       chars: "\x06\x37" }
      #     - { key: Key8,     mods: Command,       chars: "\x06\x38" }
      #     - { key: Key9,     mods: Command,       chars: "\x06\x39" }
      #     - { key: Left,     mods: Command,       chars: "\x06\x48" }
      #     - { key: Down,     mods: Command,       chars: "\x06\x4a" }
      #     - { key: Up,       mods: Command,       chars: "\x06\x4b" }
      #     - { key: Right,    mods: Command,       chars: "\x06\x4c" }
      #
      # Finally, inside the iTerm2 Key settings, I'm adding just various shortcuts,
      # such as cmd-j, cmd-left, etc.. , select the option "send hex code" and the
      # enter the hex code which I want to be executed, hence the tmux sequence. So
      # when I press CMD + d in iterm, I send the sequence 0x06 0x76,
      # which tmux inteprets it as opening a new pane.
      # ===========================================================================
https://arslan.io/2018/02/05/gpu-accelerated-terminal-alacritty/
