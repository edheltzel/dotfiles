# Atlas Custom Commands

Custom slash commands for the Atlas Personal AI Infrastructure system.

## Installation

These commands are part of the `ai` stow package. To install:

```bash
cd ~/.dotfiles
make update
```

Or manually:

```bash
stow -t ~ ai
```

Commands will be symlinked to `~/.claude/commands/` and available in all Claude Code sessions.

## Available Commands

### Voice Management (2)
| Command | Description |
|---------|-------------|
| `/atlas-voice <name>` | Switch voice personality |
| `/atlas-voices` | List all available voice personalities |

### Skills (4)
| Command | Description |
|---------|-------------|
| `/atlas-art <task>` | Launch Art skill for visual content generation |
| `/atlas-agents <task>` | Launch Agents skill for custom agent composition |
| `/atlas-prompting <task>` | Launch Prompting skill for meta-prompting |
| `/atlas-skills` | List all installed skills |

### System Status (4)
| Command | Description |
|---------|-------------|
| `/atlas-status` | Show Atlas system status and health |
| `/atlas-check` | Comprehensive system health check |
| `/atlas-hooks` | Show active hooks configuration |
| `/atlas-context` | Show current session context |

### Observability (1)
| Command | Description |
|---------|-------------|
| `/atlas-observability [action]` | Start/stop/restart observability dashboard (actions: start, stop, restart, status) |

### Stack & Preferences (1)
| Command | Description |
|---------|-------------|
| `/atlas-stack-check` | Verify project uses Atlas stack preferences |

### Pack Management (3)
| Command | Description |
|---------|-------------|
| `/atlas-packs` | List available PAI packs for installation |
| `/atlas-install <pack>` | Install a PAI pack |
| `/atlas-docs [doc]` | Access PAI documentation |

### Utilities (2)
| Command | Description |
|---------|-------------|
| `/atlas-help` | Show all available Atlas commands |
| `/atlas-create-skill <name>` | Create a new Atlas skill |

## Command Categories

**17 total commands** organized by utility:

- **Voice Management:** 2 commands
- **Skills:** 4 commands
- **System Status:** 4 commands
- **Observability:** 1 command
- **Stack & Preferences:** 1 command
- **Pack Management:** 3 commands
- **Utilities:** 2 commands

## Usage

After installation, commands are available in Claude Code:

```bash
/atlas-help             # Show all commands
/atlas-status           # Check system health
/atlas-voices           # See available voices
/atlas-voice intern     # Switch to intern personality
/atlas-observability    # Start real-time dashboard
```

## Command Structure

All commands follow the `atlas-*` naming convention to:
- Clearly identify Atlas system commands
- Avoid conflicts with built-in commands
- Group related functionality
- Enable tab completion

## Dependencies

Most commands require:
- `bun` runtime
- Atlas hooks directory (`~/.claude/hooks/`)
- Atlas settings (`~/.claude/settings.json`)
- Voice personalities config (`~/.claude/voice-personalities.json`)

Some commands also require:
- PAI repository at `~/Developer/PAI/` (for pack management)
- Voice server running (for voice commands)
- Observability server (for dashboard commands)

## Development

To create a new Atlas command:

1. Create a `.md` file in `ai/.claude/commands/`
2. Add frontmatter with `description`
3. Use `$ARGUMENTS`, `$1`, `$2` for parameters
4. Prefix bash commands with `!`
5. Test locally before committing

Use `/atlas-create-skill` to scaffold new skills with proper structure.

## See Also

- **Atlas Documentation:** `/atlas-docs`
- **Installed Skills:** `/atlas-skills`
- **Available Packs:** `/atlas-packs`
- **System Status:** `/atlas-status`
- **Observability Dashboard:** `/atlas-observability`
