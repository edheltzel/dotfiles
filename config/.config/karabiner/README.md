# A Karabiner Elements TypeScript Configuration

This is a clone of [mxstbr's Karabiner Elements configuration](https://github.com/mxstbr/karabiner) - but heavily modified for my own personal usage.

If you're interested in the original configuration, check it out here:
[mxstbr's Karabiner Elements Repo](https://github.com/mxstbr/karabiner) or watch his [demo](https://www.youtube.com/watch?v=j4b_uQX3Vu0) or his [Raycast interview](https://www.youtube.com/watch?v=m5MDv9qwhU8)

If you like TypeScript and want your Karabiner configuration maintainable & type-safe, you probably want to use the custom configuration DSL / generator I created in `rules.ts` and `utils.ts`!

>[!NOTE]
> @mxstbr said it best: "You probably don't want to use my exact configuration, as it's optimized for my personal style & usage. Best way to go about using this if you want to? Probably delete all the sublayers in `rules.ts` and add your own based on your own needs!"

## Installation

1. Install & start [Karabiner Elements](https://karabiner-elements.pqrs.org/)
1. Clone this repository
1. Delete the default `~/.config/karabiner` folder
1. Create a symlink with `ln -s ~/github/mxstbr/karabiner ~/.config` (where `~/github/mxstbr/karabiner` is your local path to where you cloned the repository)
1. [Restart karabiner_console_user_server](https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/) with `` launchctl kickstart -k gui/`id -u`/org.pqrs.karabiner.karabiner_console_user_server ``

## Dev

Starting the dev server is pretty straightforward. You can replace `bun` with the package manager of your choice.

**Available Run Commands**

```shell
bun install #only need to execute once to install dependencies
bun run build #builds the karabiner.json from the rules.ts
bun run watch #watches the TypeScript files and rebuilds whenever they change.
bun run upgrade #runs `npm-check-updates -ui` to update dependencies
bun run purge #runs `./.scrub.sh purge` to remove all the extra files from the repo
bun pm ls #lists all the dependencies - not an npm script but a bun command
```
I'm updated the dependencies to their latest versions and removed the using `tsx` along with modifying the rules to fit my own needs, you'll find that I created new functions in `utils.ts` as well.
