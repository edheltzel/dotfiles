# A Karabiner Elements TypeScript Configuration

[👈 Dotfiles Readme](../../../README.md)

## TL;DR

**Assumes** have Node, Bun, and Karabiner Elements installed.

```shell
#fish
bun install; and bun start; and $EDITOR ~/.dotfiles/config/.config/karabiner
```

## What's Inside:

This is my version of [mxstbr's Karabiner Elements](https://github.com/mxstbr/karabiner) configuration. It is heavily modified compared to the original to fit my needs. Many things are different and is by no means a 1-to-1 copy.


If you're interested in the original configuration, check it out here:
[mxstbr's Karabiner Elements Repo](https://github.com/mxstbr/karabiner) or watch his [demo](https://www.youtube.com/watch?v=j4b_uQX3Vu0) or his [Raycast interview](https://www.youtube.com/watch?v=m5MDv9qwhU8)

But get **inspired**, take what you want, and leave the rest to make it your own.

For my keyboard hacks, I use a combination of QMK/VIA for macros along with Raycast to launch apps but I chord the Hyper Key with other modifiers using Karabiner Elements.

### Hyper Key
Caps Lock is configured as my Hyper Key: `right_cmd` + `right_shift` + `right_option` + `right_control` (notice that it is the right side modifiers only.) This give me the ability to use the left side modifiers as well.

ie: `hyper + left_cmd + d` launches my Dotfiles repo in my default editor.

I could technically do all of this through QMK/VIA but it requires me to flash my keyboard every time I make a change. This isn't ideal because **I change my config a lot**.

## Get Started

1. Install & start [Karabiner Elements](https://karabiner-elements.pqrs.org/)
2. Clone this repository
3. Delete the default `~/.config/karabiner` folder
4. Create a symlink with `ln -s ~/github/mxstbr/karabiner ~/.config` (where `~/github/mxstbr/karabiner` is your local path to where you cloned the repository)
5. [Restart karabiner_console_user_server](https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/) with `` launchctl kickstart -k gui/`id -u`/org.pqrs.karabiner.karabiner_console_user_server ``

## Development

Starting the dev server is pretty straightforward – You can replace `bun` with the package manager of your choice.

Just run:
```shell
bun install && bun start
```
Alternatively you can execute `bun run build` to build the `karabiner.json` file to test out my current configuration.

Most of your hacking happens inside of `rules.ts` file, configure this to match your personal preferences and needs.

**Additional Run Commands**

```shell
bun run start #watches the TypeScript files and rebuilds whenever they change.
bun run build #builds the karabiner.json from the rules.ts
bun run upgrade #runs `npm-check-updates -ui` to update dependencies
bun run purge #runs `./.scrub.sh purge` to remove all the extra files from the repo
bun pm ls #lists all the dependencies - not an npm script but a bun command
```
