# git-files.yazi

> Basically [`vcs-files`](https://github.com/yazi-rs/plugins/tree/main/vcs-files.yazi) but with untracked using `git status`

Show Git file changes in Yazi which includes untracked file.

![image](https://github.com/user-attachments/assets/639dc45c-c380-474c-8ea7-0b0455b299e3)

## Installation

```sh
ya pkg add ktunprasert/git-files
```

## Usage

```toml
# keymap.toml
[[mgr.prepend_keymap]]
on   = [ "g", "c" ]
run  = "plugin git-files"
desc = "Show Git file changes"
```

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
