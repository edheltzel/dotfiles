# OpenCode Configuration

Personal OpenCode configuration with custom commands, plugins, and themes.

> For Claude Code configuration, see [`~/.claude/README.md`](../../.claude/README.md)

## Hey Future Ed

Just in case you forget, plugins in the `plugin/` directory are **automatically loaded** by OpenCode.
There is no need to register them in `opencode.jsonc`.

See: https://opencode.ai/docs/plugins#location

---

**Plugin Dependencies:** If your plugins use the OpenCode plugin API, you need to install the types:

```bash
cd ~/.dotfiles/ai/.config/opencode && bun add @opencode-ai/plugin

```

since we use Stow, we need to include the `bun add` in our dotifles repo. This is why `package.json` and `bun.lock` exist in this directory (ignored by stow).

## Structure

- `opencode.jsonc` - Main configuration (model, MCP servers, theme)
- `agent/` - Custom sub-agents for specialized tasks
- `command/` - Custom slash commands (`/commit`, `/commit-push`, etc.)
- `plugin/` - Autoloaded plugins (audio feedback notifications, etc.)
- `themes/` - Custom color themes (Eldritch variants)
- `tool/` - Custom tools

## Setup

### Per-Project

```bash
curl -o opencode.json https://raw.githubusercontent.com/edheltzel/dotfiles/main/ai/.config/opencode/opencode.json
```

### Global

```bash
mkdir -p ~/.config/opencode
curl -o ~/.config/opencode/opencode.json https://raw.githubusercontent.com/edheltzel/dotfiles/main/ai/.config/opencode/opencode.json
```

## Permissions Format

OpenCode uses a permission object with `"allow"`, `"ask"`, or `"deny"` values:

```json
{
  "permission": {
    "bash": {
      "git *": "allow",
      "rm -rf /": "deny",
      "*": "ask"
    }
  }
}
```

| Goal                   | Example                 |
| ---------------------- | ----------------------- |
| Allow all Git commands | `"git *": "allow"`      |
| Block specific command | `"rm -rf /": "deny"`    |
| Prompt for approval    | `"docker run *": "ask"` |

## What's Allowed and Blocked

### Allowed

The config includes ~250 command patterns covering tools most devs actually use:

- **Languages & Package Managers:** Node (npm, yarn, pnpm, bun), Python (pip, poetry), Rust (cargo), Go, Java, Ruby, and PHP.
- **Infrastructure & Cloud:** Docker, Kubernetes (kubectl, helm), AWS, Google Cloud, Azure, Vercel, and Netlify.
- **Git & GitHub:** Full git operations and GitHub CLI (`gh`).
- **Database Tools:** Postgres, MySQL, MongoDB, Redis, and SQLite.
- **System Tools:** File manipulation, text processing (grep, sed, jq), SSH, curl, wget.

### Blocked

These are blocked to prevent you from accidentally nuking something:

- **Destructive Acts:** Recursive root deletion (`rm -rf /`), disk formatting, kernel mods.
- **Docker Risks:** Privileged containers, host socket mounting.
- **Malicious Activity:** Reverse shells, crypto mining, credential theft.
- **User Admin:** Password changes, user account modification.

## Customizing

Edit `opencode.jsonc` to add or modify patterns.

**Tip:** Put private servers and domains in local config files so they don't end up in version control.

## How Settings are Applied

Settings merge using deep merge strategy:

1. **Environment Variable:** `OPENCODE_CONFIG` path
2. **Custom Directory:** `OPENCODE_CONFIG_DIR`
3. **Project:** `opencode.json` in project root
4. **Global:** `~/.config/opencode/opencode.json`

## Security Notes

1. **Sudo:** Only allowed for package managers (`sudo apt install`, etc). Remove those patterns if you don't need them.
2. **Permissiveness:** These settings lean loose so you're not approving every command. Tighten them up if your environment requires it.

## Links

- [Configuration Docs](https://opencode.ai/docs/config)
- [Permissions Docs](https://opencode.ai/docs/permissions)
