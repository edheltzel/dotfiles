<img src="_images/dotfiles-logo.png" alt="dotfiles logo" width="350">

### [Ed Heltzel's](https://github.com/edheltzel) personal configuration (.dotfiles) for MacOS using Fish shell.

This is my personal configuration (.dotfiles) for macOS that involves web development and devops which are deployed using [GNU Stow](https://www.gnu.org/software/stow/). There are also files for provisioning a new machine and setting up my environment.


## So what's next?

Zach Holman wrote a great article on [dotfiles](https://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/) and how they are meant to be forked. I agree with this to a point... I'm more of a fan of the idea that you should take what you like and leave the rest, since dotfiles are highly personalized, and built over time so what works for me probably wont't work for you, but take inspiration all you want and make it your own. Again, this is **my personal setup** so use at your own risk if you choose to use it.

## ⚙️ Usage and the Install

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



### SSH Keys
I use [ssh keys](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/) to authenticate with GitHub and other services. You generally want to create new keys for each device you use, but you can also use the same key on multiple devices. **I have started using two different keys for my multi-machine work flow.** One key is for my personal devices and the other is for my work devices. This allows me to easily revoke access to my work devices if I discontinue a relationship with a company or customer, and not have to worry about my personal keys being compromised or having to change them.

If you look at the `.gitconfig` you'll see the use of an include `path = ~/.gitconfig.local` this file is created during the provisioning process and is populated with the correct configuration based on the hostname.

1. [Generate a new ssh keys](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/) and add to your GitHub account. - _Optional_
  - If you want to restore your key I'd do that before moving on.

2. Clone this repository

```
git clone git@github.com:edheltzel/dotfiles.git
```

3. Run the `bootstrap.sh` script
   1. Alternatively, only run the `setup.sh` scripts in specific subfolder if you don't need everything - You must start with the `./packages/.setup.sh` script first. This will prevent any installation errors.
4. Install [Fisher](https://github.com/jorgebucaran/fisher) and Plugins -- _Optional_

```bash
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher
```

#### Commit and Tag Signing

##### SSH Commit Signing

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

- setup.sh - Installs the contents of the package manager files and the Brewfile

### Repositories (repos/)

- setup.sh - Clones the repositories in the `` files at the corresponding
  locations

### Vim (nvim/)

I use NeoVim, when I need Vim. The distribution I use is [LazyVim](https://www.lazyvim.org/)

- setup.sh - Clone LazyVim to `~/.config/nvim`

### Helper Scripts (scripts/)

- functions.sh - Contains helper functions for symlinked files and printing
  progress messages
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

**Note:** FNM has the ability to auto switch Node versions if there is a `.node-version` or `.nvmrc` file - this is enabled by default

```shell
# automatically run fnm use
fnm env --use-on-cd | source
```

> Please note that when you change your default Node version, you will need to run `npm install --global (cat node_packages.txt)` to include `corepack` in the global packages. This will ensure that `pnpm` and `yarn` are available.

#### 🙏 Special Thanks

Gotta thanks to [kalis.me blog post](https://kalis.me/dotfiles-automating-macos-system-configuration/) for the simple setup, and inspiration.

===

- [ ] create a single line install script to execute bootstrap.sh
- [ ] update install.sh to include duti, packages, repos, and set local git config
- [ ] use makefile to execute bootstrap.sh and install.sh
- [ ] update README
  - [ ] include Stow info
  - [ ] include Make info
  - [ ] include New bootstrap process
  - [ ] include New install process (makefile)
- [x] add customizations to lazyvim
- [x] add vscode settings and symlink to dotfiles
- [ ] consider using XDG
- [ ] Look into [Tuckr](https://github.com/RaphGL/Tuckr)

### GNU Stow

Originally I used a series of custom scripts to create symlinks, it worked but I've since switched to using [GNU Stow](https://www.gnu.org/software/stow/). I feel like everything is way more manageable and  easier to understand – I previously would have to review each script to make sure I wasn't going to break my system.

## Makefile

So with the addition of Stow, I've added a makefile to help with the process of managing each Stow package.

The following commands are available:

- `all` - This is the Default, the same as `make stow`
- `stow` - Symlink all dotfiles managed by Stow
- `unstow` - Remove all dotfiles managed by Stow
- `update` - Update all dotfiles and remove broken symlinks managed by Stow
