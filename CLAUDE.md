# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

**See [AGENTS.md](AGENTS.md) for all repository documentation, build commands, code style, conventions, and development standards.**

## Atlas - Personal AI Infrastructure

The `atlas/` directory is a **git submodule** containing the Personal AI Infrastructure (PAI) for Claude Code:

- **Repository:** https://github.com/edheltzel/atlas
- **Stow Target:** `~/.claude/` and `~/.config/opencode/`

### Key Components

| Directory | Purpose |
|-----------|---------|
| `atlas/.claude/commands/atlas/` | 18 slash commands (`/atlas:*`) |
| `atlas/.claude/skills/` | 7 skills (CORE, Art, Agents, Browser, Prompting, etc.) |
| `atlas/.claude/hooks/` | TypeScript session lifecycle hooks |
| `atlas/.claude/voice/` | ElevenLabs TTS voice server |
| `atlas/.claude/observability/` | Real-time Vue dashboard |
| `atlas/.config/opencode/` | OpenCode AI configuration |

### Working with Atlas

```bash
# Update atlas submodule
cd ~/.dotfiles/atlas && git pull origin master

# Restow after changes
make stow pkg=atlas

# Or update all packages
make update
```

### Atlas Commands

Run `/atlas:help` in Claude Code to see all available commands.
