<h1 id="to-the-top">Mr EdHeltzel's Dotfiles</h1>

### My setup for 🐠 Fish shell on  macOS - `v3`

![image](./local/.local/__repoImages/workspace-setup.png)

Here, you'll find my dotfiles configuration for [fish shell][fishshell] on macOS managed using [GNU Stow][STOW]. You'll also find files for provisioning a new machine and setting up my environment.

> [!WARNING]
> Again, this is my personal setup and <ins>**changes often**</ins>, so don't blindly fork and run the [`install.sh`][installFile] script without reading it first.

But get **inspired**, take what you want, and leave the rest to make it your own.

<details>
  <summary>Older Versions</summary>

- [v1](https://github.com/edheltzel/dotfiles/tree/v1) uses oh-my-zsh
- [v2](https://github.com/edheltzel/dotfiles/tree/v2) uses fish shell + custom scripts

</details>

Table of Contents:

- [Prerequisites](#prereq)
- [The Nitty Gritty](#the-nitty-gritty)
- [MacOS Mods](#macos-mods)
  - [~~Aerospace Window Manager~~ Stage Manager + Raycast + Alt-Tab](#window-manager)
  - [~~Sketchybar~~ Ice Bar](#status-bar)
  - [Karabiner Elements](#keyboard-hacks)
- [Troubleshooting](#troubleshooting)
  - [Dotfiles](#troubleshoot-dotfiles)
  - [MacOS](#troubleshoot-macos)
- [TODOs](#todos)
- [Scripts](#scripts)

<h2 id="prereq">Prerequisites <a href="#to-the-top">↑</a></h2>

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

<h2 id="for-future-ed">👋 For future Mr EdHeltzel<a href="#to-the-top">↑</a></h2>

Since we have a bad habit of forgetting things - see [Troubleshooting](#troubleshooting):

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
   - `upp` is an alias for `topgrade` which is Update Packages _(this is what I say to myself)_.
   - The `topgrade.toml` includes `[post_commands]` for additional Brew and Node updates.
6. Optional steps for DX and nice to haves:
   - Disable Gatekeeper when installing apps: `sudo spctl --master-disable` (in macos/security.sh)
   - Make sure to run `fnm env --use-on-cd | source` to enable auto-switching of Node versions. (in fish)
7. Wallpapers are stored in `~/.wallpapers/` which now lives in it's own [repo here](https://github.com/edheltzel/wallpapers)
   - Raycast uses this repo/directory to set wallpapers

<h2 id="the-nitty-gritty">The Nitty Gritty <a href="#to-the-top">↑</a></h2>

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
  - A customized verions of [LazyVim](lazyVim) I call **NEO.ED**. (Primary Editor)
- config (config/)
  - Configuration files for various applications, instead of adding them to root of the repo.
- editors(editors/)
  - VSCode configurations, ie: keybindings, settings, and custom stuff.(Secondary Editor)
- local (local/)
  - User-specific data not configuration-related. ie: dictionaries and misc items that mean nothing, etc.

<h2 id="scripts">Scripts <a href="#to-the-top">↑</a></h2>

Any of the scripts can be run individually at any time to update/reset as needed. ie: `cd ~/.dotfiles && ./duti/duti.sh`

- macObS (macos/)
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

<h2 id="macos-mods">MacOS Mods <a href="#to-the-top">↑</a></h2>

> [!NOTE]
> For Karabiner Elements, I'm constantly changing my config to better fit my workflow and preferences.

<h4 id="window-manager">~~Aerospace Window~~ Native MacOS Stage Manager + Raycast + Alt-Tab <a href="#to-the-top">↑</a></h4>
<h4 id="status-bar">Ice Bar <a href="#to-the-top">↑</a></h4>
I only use Ice.app to change the appearance of the native MacOS menu bar.

<h4 id="keyboard-hacks">Karabiner Elements <a href="#to-the-top">↑</a></h4>

For most of my keyboard hacking, I'm using a combination of QMK (thru VIA app), with Raycast, but I leverage Karabiner Elements for more complex modifications, like chording the Hyper Key with other modifiers.

My Hyper Key: `right_cmd` + `right_shift` + `right_option` + `right_control` (notice that it is the right side modifiers only.)

ie: `hyper + left_alt + d` launches my Dotfiles repo in my default editor.

See the Readme for more details: [config/.config/karabiner/README.md](./config/.config/karabiner/README.md)

<h2 id="troubleshooting">Troubleshooting <a href="#to-the-top">↑</a></h2>
<h4 id="troubleshoot-dotfiles">Dotfiles<a href="#to-the-top">↑</a></h4>
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

</details>
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
<details>
  <summary>Rust and Cargo</summary>
  From time to time, `cargo` will fail to update/upgrade using `topgrade`. This is generally due to something changing inside of the Rust system that doesn't allow `cargo install cargo-update` to work.

**The solution:**
Uninstall and reinstall `rust` and `rustup-init` along with `cargo` using `brew`.

```shell
brew uninstall rustup-init;
and brew reinstall rust;
and cargo uninstall cargo;
cargo install cargo-update --force;
topgrade --only cargo
```

</details>
<details>
  <summary>SSH Agent</summary>
  In the even when restarting macOS, the SSH agent will not be running, even though it is configured to run on login. A result of this is that Git will keep asking for your SSH Passphrase, to resolve this you will need to execute the following:

```shell
eval ssh-agent -s;
and ssh-add --apple-use-keychain
```

<small>What this does: Starts the SSH agent and adds the SSH key to the keychain.</small>

Since we are using [danhper/fish-ssh-agent](https://github.com/danhper/fish-ssh-agent) to manage the SSH agent, we only have to run this once.

</details>
<h4 id="troubleshoot-macos">MacOS<a href="#to-the-top">↑</a></h4>

I include this [website](https://mac-key-repeat.zaymon.dev/) in `01-preferences.sh` - it's a great resource to see what the default key repeat rate will be. fs

<details>
  <summary>WindowServer RAM Leak</summary>
  As of `2024-07` there is a known bug/issue with macOS where the WindowServer will consume CPU and/or Memory. It is annoying. From my experience, this is related to more than one external monitor. My current workaround is to kill the WindowServer on macOS, which logs you out. Once you log back in the WindowServer will be restarted and your RAM usage will be back in normal ranges. This is a workaround until Apple fixes the issue, which will probably never happen.
  <strong>Usage:</strong>
  <ul>
    <li>Open your Terminal</li>
    <li>run `killws`</li>
    <li>Log back into your account</li>
  </ul>
</details>
<details>
  <summary>Media Control Keys</summary>
  From time to time some of the "nice-to-have" features of MacOS break. An example of this is when the media keys stop working for one reason or another; Google Chrome/WhatsApp/ can and generally hijack the media keys.

To resolve this just run the following command in the terminal:

```shell
launchctl load -w /System/Library/LaunchAgents/com.apple.rcd.plist
```

This `luanchctl` will reenable media key, which in turn will control Spotify 🙂

</details>
<details>
  <summary>Ethernet Backhaul</summary>
  Run the `flashEthernet` function to "flush" the Ethernet backhaul.

```shell
flashEthernet; and echo 'Ethernet backhaul flushed'
speedtest
```

</details>
<h2 id="todos">TODOs <a href="#to-the-top">↑</a></h2>

- [x] ~~Convert fish functions to zsh functions - **WIP**~~ this was a dumb idea
- [x] ~~zsh completions seem to be broken [issue #40](https://github.com/edheltzel/dotfiles/issues/40)~~
  - [x] ~~Look into zsh-completions vs autocomplete~~
- [x] Consider using [Home Manager](https://nix-community.github.io/home-manager/) for package management.
- [x] include zsh abbreviations
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
[fishshell]: https://fishshell.com/
[installFile]: https://github.com/edheltzel/dotfiles/blob/master/install.sh
[ThanksGithub]: https://dotfiles.github.io/
[ThanksGHInspiration]: https://dotfiles.github.io/inspiration
[ThanksGHUtils]: https://dotfiles.github.io/utilities/
[ThanksKalis]: https://kalis.me/dotfiles-automating-macos-system-configuration/
[ThanksLissy]: https://github.com/lissy93/dotfiles
[ThanksJake]: https://www.jakewiesler.com/blog/managing-dotfiles
