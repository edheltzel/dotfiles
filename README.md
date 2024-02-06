<img src="misc/__images/dotfiles-logo.png" alt="dotfiles logo" width="350">

### My personal configuration (.dotfiles) for  macOS using 🐠 Fish shell.

This is my personal configuration (.dotfiles) for macOS that involves web development and devops which are deployed using [GNU Stow][STOW]. There are also files for provisioning a new machine and setting up my environment – they are highly personalized and built over time, so what works for me probably won't work for you. But take inspiration all you want and make it your own. _**So proceed with caution, and use at your own risk**_.

## Get Started

<details>
  <summary><strong>Caveats for non-Apple Silicon (Intel)</strong></summary>
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

  1. Turn off your Mac (Apple > Shut Down).
  2. Hold down Command-R and press the Power button. Keep holding Command-R until the Apple logo appears.
  3. Wait for OS X to boot into the OS X Utilities window.
  4. Choose Utilities > Terminal.
  5. Enter csrutil _disable_.
  6. Enter reboot.
  7. `csrutil status` -> should read `System Integrity Protection status: disabled.`
</details>

### 👋 For future, Ed:

Since we have a bad habit of forgetting things:

1. Install Xcode Command Line Tools `sudo softwardupdate -i -a && xcode-select --install`
    - This will install `git` and `make` if not already installed.
2. Setup SSH keys for GitHub
    - [Generate a new ssh keys][GENSSHKEY] or restore existing key if needed.
2. Clone this repository to `~/.dotfiles`
3. Run the `bootstrap.sh` script or `make install` command

## What's Inside

### GNU Stow

Originally I used a series of custom scripts to create symlinks, it worked but I've since switched to using [GNU Stow][STOW]. This is way more manageable and easier to understand.

### Makefile

So with the addition of Stow, I added a `makefile` – I treat this like NPM scripts. You need to be in the root of `~/.dotfiles` to execute any of the `make` commands.

The following commands are available:

```shell
help          Show this help message (default)
install       Bootstraps a new machine
run           Symlink all dotfiles w/Stow
stow          Add individual packages w/Stow
unstow        Remove individual packages w/Stow
delete        Delete all dotfiles w/Stow
update        Sync & clean dead symlinks w/Stow
```

#### Bootstrapping

- `make install` task, it will execute the `bootstrap.sh` script. This script will install the necessary package managers, packages with dependencies, applications, clone the necessary repositories, configure the `~/.gitconfig.local` and symlink dotfiles using Stow.

#### Stowing and Unstowing

There are two options for managing packages with Stow:

1. Just use Stow: `stow nvim` or `stow -D nvim` _(unstow)_
2. Use the Makefile: `make stow pkg=nvim` or `make unstow pkg=nvim`
    - The `pkg=` variable must be specified.

## Stow Packages

- dots (dots/)
  - misc dotfiles that are stored in the $HOME directory
- git (git/)
  - git configuration
- fish (fish/)
  - XDG Base Directory – Reference: [XDG Base Directory][XDGRef] for more information. To edit/set the XDG Base Directory variables, you can edit the `~/fish/.config/fish/conf.d/paths.fish` file. Hopefully, this will keep the `$HOME` directory clean and organized.
- nvim (nvim/)
  - When I need Vim, I use [LazyVim](https://www.lazyvim.org/) - lightly customized.
- config (config/)
  - Configuration files for various applications
- local (local/)
  - User specific data not configuration related. ie: fonts, wallpapers, misc items that mean nothing,etc.
- warp (warp/)
  - I like Warp but I really like iTerm2
- vscode (vscode/)
  - I use the sync feature in vscode to keep my settings and extensions in sync. The `settings.json` and `keybindings.json` are symlinked out of habit.

## Scripts

Any of the scripts can be run individually at any time to update/reset as needed.

### macOS (macos/)

`macos.sh` - Executes a long list of commands pertaining to macOS Preferences – **DO NOT** blindly run this script - it is a WIP with each macOS update things change.

### packages (packages/)

- `packages.sh` - Installs the Brewfile and each package manager's packages based on the `.txt` files.

### repositories (repos/)

- `repos.sh` - Clones the repositories in the `` files at the corresponding locations

### private (private/)

- `private.sh` - Left empty on purpose

### duti (duti/)

- `duti.sh` - Sets the default applications for file types
    - run `./duti/duti.sh` to reset the default applications for file types

### misc (misc/)

There isn't anything of substance in the `misc/` directory, it's just a place to store files that don't fit anywhere else and I like to keep handy.

### Helper Scripts (scripts/)

- `functions.sh` - Contains helper functions for symlinked files and printing progress messages

## Troubleshooting
<details>
  <summary>Fish: Fisher Plugin Manager</summary>
  In the past, Fisher (fish plugin manager) will do something weird or will introduce a breaking change - just reinstall Fisher.

  ```bash
  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
  ```
</details>
<details>
  <summary>Node Development</summary>
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

  **Note:** FNM has the ability to auto switch Node versions if there is a `.node-version` or `.nvmrc` file - this is enabled by default

  ```shell
  # automatically run fnm use
  fnm env --use-on-cd | source
  ```

  > Please note that when you change your default Node version, you will need to run `npm install --global (cat node_packages.txt)` to include `corepack` in the global packages. This will ensure that `pnpm` and `yarn` are available.
</details>
<details>
  <summary>Git: Commit and Tag Signing</summary>

  **SSH Signing**

  I use SSH commit signing over GPG. GPG is there if I need it, but I prefer SSH. For a few resources to help get this setup:

  - [Git Merge Workshop - Simplify Signing with SSH](https://github.com/git-merge-workshops/simplify-signing-with-ssh/tree/main)
  - [Gitlab SSH Commit Signing Doc](https://docs.gitlab.com/ee/user/project/repository/ssh_signed_commits/)

  The `.gitconfig` includes `.gitconfig.local`

  ```shell
    [meta]
      isLocalConfig = true
    [user]
      signingkey = PATH_TO_YOUR_KEY
    [gpg "ssh"]
      allowedSignersFile = PATH_TO_YOUR_ALLOWED_SIGNERS_FILE
  ```
  If you choose to use this make sure you look at that `./git/git.sh`, this script is where the provisioning of `.gitconfig.local` happens.
  <details>
    <summary>GPG Commit Signing - <em>optional</em></summary>

    GPG signing is set to `TRUE` by default. If you rather not enable GPG then execute: `git config --global commit.gpgsign false` and remove the GPG packages from the [Brewfile](https://github.com/edheltzel/dotfiles/blob/master/packages/Brewfile).

    [renew expired gpg](https://gist.github.com/krisleech/760213ed287ea9da85521c7c9aac1df0)

    [Generate new key and assign to global git config](https://gist.github.com/paolocarrasco/18ca8fe6e63490ae1be23e84a7039374#:~:text=It%20means%20that%20is%20not,secret%20keys%20available%20in%20GPG.)

    main take away:

    - `gpg --list-secret-keys --keyid-format=long`
    - Copy key
    - set key for your git user
      - `git config --global user.signingkey <your key>`
    - If you need help setting this up GPG:
      - follow the Github article for [Signing Commits](https://help.github.com/en/articles/signing-commits) to set up you GPG key(s).
      - I found this [GIST helpful](https://gist.github.com/cezaraugusto/2c91d141ddec026753051ffcace3f1f2)
      - To get VSCode setup follow this [article](https://dev.to/devmount/signed-git-commits-in-vs-code-36do)
    - **Please Note** if you used the [Brewfile](https://github.com/edheltzel/dotfiles/blob/master/packages/Brewfile), Cask installed the macOS [GPG Suite](https://gpgtools.org/) via `cask 'gpg-suite-no-mail'` -- _(alternatively)_ update the [Brewfile](https://github.com/edheltzel/dotfiles/blob/master/packages/Brewfile) with `cask 'gpg-suite' to include GPGMail.

  </details>
</details>

#### 🙏 Special Thanks

Gotta thanks to [kalis.me blog post](https://kalis.me/dotfiles-automating-macos-system-configuration/) for the simple setup, and inspiration.

===

## 📝 TODOs

- [ ] create a single line install script to execute bootstrap.sh
- [ ] use makefile to execute bootstrap.sh and install.sh
- [ ] Look into [Tuckr](https://github.com/RaphGL/Tuckr)
- [x] update make unstow to include only the available stow package or all
- [x] add customizations to lazyvim
- [x] add vscode settings and symlink to dotfiles
- [x] add XDG Base Directory support
- [x] update README
  - [x] include XDG info
  - [x] include Stow info
  - [x] include Make info
  - [x] include New bootstrap process
  - [x] include New install process (makefile)

[XDGRef]: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
[STOW]: https://www.gnu.org/software/stow/
[GENSSHKEY]: https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
