# Atlas Configuration for Claude Code

My personal and highly customized Claude Code configuration.

Unabashedly, inspired, and cloned from PAI and Always on AI Assistant

> [!info]
> For OpenCode configuration, see [`~/.config/opencode/README.md`](../.config/opencode/README.md)

## Structure

- `settings.json` - Main settings file (permissions, hooks, etc.)
- `skills/` - Custom skills for specialized tasks

## Setup

### Per-Project

_Use this if you want the same permissions for everyone on a project._

```bash
mkdir -p .claude
curl -o .claude/settings.json https://raw.githubusercontent.com/edheltzel/dotfiles/main/ai/.claude/settings.json
```

### Global

_Use this if you want these permissions to apply everywhere._

```bash
mkdir -p ~/.claude
curl -o ~/.claude/settings.json https://raw.githubusercontent.com/edheltzel/dotfiles/main/ai/.claude/settings.json
```

### Local Overrides

_Use this for personal overrides you don't want to commit._

```bash
touch .claude/settings.local.json
echo ".claude/settings.local.json" >> .gitignore
```

## Permissions Format

Claude Code uses `Tool(pattern)` syntax in allow/deny arrays:

```json
{
  "permissions": {
    "allow": ["Bash(git *)"],
    "deny": ["Bash(rm -rf /)"]
  }
}
```

| Goal                   | Example                            |
| ---------------------- | ---------------------------------- |
| Allow all Git commands | `"Bash(git *)"`                    |
| Block specific command | `"Bash(rm -rf /)"`                 |
| Allow specific domain  | `"WebFetch(domain:*.example.com)"` |

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

Edit `settings.json`. Patterns use `Tool(specifier)` format.

**Tip:** Put private servers and domains in `settings.local.json` so they don't end up in version control.

## How Settings are Applied

Settings merge from multiple sources. Higher in the list wins:

1. **Enterprise Policies:** `/etc/claude-code/policies.json`
2. **CLI Flags:** `--allow`, `--deny`
3. **Local Project:** `.claude/settings.local.json`
4. **Shared Project:** `.claude/settings.json`
5. **Global User:** `~/.claude/settings.json`

## Security Notes

1. **Sudo:** Only allowed for package managers (`sudo apt install`, etc). Remove those patterns if you don't need them.
2. **Permissiveness:** These settings lean loose so you're not approving every command. Tighten them up if your environment requires it.

## Links

- [Settings Documentation](https://docs.anthropic.com/en/docs/claude-code/settings)
- [Security & Trust Model](https://docs.anthropic.com/en/docs/claude-code/security)
