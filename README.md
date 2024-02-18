# Ed's Dotfiles

### My setup for 🐠 Fish shell on  macOS - `v3`

Here, you'll find my dotfiles configuration for [fish shell][fishshell] on macOS managed using [GNU Stow][STOW]. You'll also find files for provisioning a new machine and setting up my environment. Again, this is my personal setup and **changes often**, so don't blindly fork and run the [`install.sh`][installFile] script without reading it first. But get inspired, take what you want, and leave the rest to make it your own.

<details>
  <summary>Older Versions</summary>

  - [v1](https://github.com/edheltzel/dotfiles/tree/v1) uses oh-my-zsh
  - [v2](https://github.com/edheltzel/dotfiles/tree/v2) uses fish shell + custom scripts
</details>


## Prerequisites

<details>
  <summary><strong>Install with a single line...</strong></summary>

  I have not tested this on a fresh install, so this could break your setup. I'd suggest you read through the `bootstrap.sh` and `install.sh` scripts and the `Makefile` before running this command.

  In theory, this will clone the repository and install everything outlined below. Again, In theory.
  ```shell
  bash -c "`curl -fsSL https://raw.githubusercontent.com/edheltzel/dotfiles/master/bootstrap.sh`"
  ```
</details>

<details>
  <summary>Resources & Inspiration for the help</summary>

  Below are the resources I used to get to this point in my setup.

  - [dotfiles.github.io][ThanksGithub]
    - [utilities][ThanksGHUtils]
    - [inspiration][ThanksGHInspiration]
  - [kalis.me blog post][ThanksKalis]
  - [Lissy93 dotfiles][ThanksLissy]
  - [jakewiesler.com blog post][ThanksJake]

</details>

<details>
  <summary><em>Caveats for non-Apple Silicon (Intel)</em></summary>
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

## **👋 For future Ed**:

Since we have a bad habit of forgetting things:

1. Installing Xcode Command Line Tools
    - `sudo softwardupdate -i -a && xcode-select --install` This will install `git` and `make` if not already installed.
2. Generate a new SSH key and add to GitHub
    - [Generate a new ssh keys][GENSSHKEY]
    - `eval "$(ssh-agent -s)" && ssh-add --apple-use-keychain ~/.ssh/id_ed25519`

3. Clone repo
    - `git clone https://github.com/edheltzel/dotfiles.git ~/.dotfiles`
4. Use the [`Makefile`](makefile) for the rest of the setup
    - `cd ~/.dotfiles && make install`
    - Alternatively, run install script `cd ~/.dotfiles && ./install.sh`
5. After the setup is complete, run `upp` to execute topgrade and update everything.
6. Optional steps for DX and nice to haves:
    - Disable Gatekeeper when installing apps: `sudo spctl --master-disable` (in macos/security.sh)
    - Make sure to run `fnm env --use-on-cd | source` to enable auto-switching of Node versions. (in fish)

## The Nitty Gritty

Originally, I used a series of custom scripts to create symlinks, and it worked, but I've since switched to using [GNU Stow][STOW]. This is way easier to manage.

So, with the addition of GNU Stow, I added a `makefile` – I treat this like NPM scripts. You need to be in the root of `~/.dotfiles` to execute any of the `make` tasks.

The following are available:

```shell
help          Show this help message (default)
install       Bootstraps a new machine
run           Symlink all dotfiles w/Stow
stow          Add individual packages w/Stow
unstow        Remove individual packages w/Stow
delete        Delete all dotfiles w/Stow
update        Sync & clean dead symlinks w/Stow
```

**Bootstrapping**

- `make install` task, it will execute the `bootstrap.sh` script. This script, is for setting up a brand new machine, it will install the necessary package managers, packages with dependencies, applications, clone the necessary repositories, configure the `~/.gitconfig.local` and symlink dotfiles using GNU Stow.

**Stowing/Unstowing (add/remove)**

There are two options for managing packages with GNU Stow:

1. Just use Stow: `stow nvim` / `stow --restow nvim` or `stow -D nvim` _(unstow)_
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
  - When I need Vim, I use [LazyVim](lazyVim) - lightly customized.
- config (config/)
  - Configuration files for various applications
- local (local/)
  - User-specific data not configuration-related. ie: dictionaries, wallpapers, misc items that mean nothing, etc.
- warp (warp/)
  - Includes my [Lunar Eclipse theme](https://github.com/edheltzel/lunar-eclispe-for-terminal) and Warp preferences.
  - iTerm2 is my daily driver, I really want to like Warp, but I just can't get into it.
  - iTerm's preferences are synced with iCloud Drive.

## Scripts

Any of the scripts can be run individually at any time to update/reset as needed. ie: `cd ~/.dotfiles && ./duti/duti.sh`

- macOS (macos/)
  - `macos.sh` - Executes a long list of commands pertaining to macOS Preferences – **DO NOT** blindly run this script - it is a WIP with each macOS update things change.
- packages (packages/)
  - `packages.sh` - Installs the Brewfile and each package manager's packages based on the `.txt` files.
- repositories (repos/)
  - `repos.sh` - Clones the repositories in the `.txt` files at the corresponding locations
- private (private/)
  - `private.sh` - Left empty on purpose
- duti (duti/)
  - `duti.sh` - Sets the default applications for file types
    - run `./duti/duti.sh` to reset the default applications for file types
- Helper Scripts (scripts/)
  - `functions.sh` - Contains helper functions for for the scripts

## Troubleshooting
<details>
  <summary>Fish: Fisher Plugin Manager</summary>
  In the past, Fisher (fish plugin manager) would do something weird or introduce a breaking change - just reinstall Fisher.

  ```bash
  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
  ```
</details>
<details>
  <summary>Node Development: FNM</summary>

  Node Version switching for Node development, takes advantage of [fnm](https://github.com/Schniz/fnm) for managing Node versions, which supports both `.nvmrc` and `.node-version` files.

  - If not already installed from the Brewfile, install `fnm`:

  ```shell
  brew install fnm
  fnm env --use-on-cd | source
  ```

  For Fish Completions run:

  ```shell
  fnm completions --shell fish
  ```

  Make sure you run:

  ```shell
  make update #updates all stow packages
  OR
  make stow pkg=fish
  ```

  Enable auto switch of Node versions with `.node-version` or `.nvmrc` files

  ```shell
  # auto runs: fnm use
  fnm env --use-on-cd | source
  ```
  Which each Node version change, enabling `corepack` is necessary to ensure that `pnpm` and `yarn` are available.

  ```shell
  npm install --global $(cat node_packages.txt)
  ```
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
  If you choose to use this, make sure you look at that `./git/git.sh`; this script is where the provisioning of `.gitconfig.local` happens.
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

## TODOs

- [ ] Look into [Tuckr](https://github.com/RaphGL/Tuckr)
- [ ] Consider using [NixOS](https://nixos.org/) for package management over Homebrew. ie: [good example](https://github.com/biosan/dotfiles)
- [x] Create a single-line install script to execute bootstrap.sh
- [x] use makefile to execute bootstrap.sh and install.sh
- [x] update make unstow to include only the available stow package or all
- [x] add customizations to lazyvim
- [x] Add vscode settings and symlink to dotfiles
- [x] Add XDG Base Directory support
- [x] update README
  - [x] include XDG info
  - [x] include Stow info
  - [x] include Make info
  - [x] include New bootstrap process
  - [x] include New install process (makefile)

[XDGRef]: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
[STOW]: https://www.gnu.org/software/stow/
[GENSSHKEY]: https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
[lazyVim]: https://www.lazyvim.org/
[vscodeSyncSetting]: https://code.visualstudio.com/docs/editor/settings-sync
[fishshell]: https://fishshell.com/
[installFile]: https://github.com/edheltzel/dotfiles/blob/master/install.sh
[ThanksGithub]: https://dotfiles.github.io/
[ThanksGHInspiration]: https://dotfiles.github.io/inspiration
[ThanksGHUtils]: https://dotfiles.github.io/utilities/
[ThanksKalis]: https://kalis.me/dotfiles-automating-macos-system-configuration/
[ThanksLissy]: https://github.com/lissy93/dotfiles
[ThanksJake]: https://www.jakewiesler.com/blog/managing-dotfiles
