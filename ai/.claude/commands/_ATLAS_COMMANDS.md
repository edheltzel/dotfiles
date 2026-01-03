# Atlas Commands System

> **For AI Agents, Claude Code Instances, and Automated Tools**
>
> This document provides comprehensive information about the Atlas command system for AI consumption. All commands follow predictable patterns and can be invoked programmatically.

---

## System Overview

**Atlas** is a Personal AI Infrastructure (PAI) built on Claude Code that provides:
- Voice personality management
- Skill-based delegation
- Real-time observability
- Pack-based modularity
- Stack preference enforcement

The command system exposes 17 slash commands under the `atlas-*` namespace.

## Architecture

```
~/.dotfiles/ai/.claude/commands/    # Source (git-tracked)
            ↓ (stow)
~/.claude/commands/                 # Installed (symlinked)
            ↓ (Claude Code)
/atlas-<command>                    # Available slash commands
```

**Key Directories:**
- `~/.claude/hooks/` - Hook scripts (TypeScript, executed by bun)
- `~/.claude/skills/` - Skill definitions (Markdown)
- `~/.claude/observability/` - Real-time dashboard server
- `~/Developer/PAI/` - PAI pack repository

**Runtime:** bun (NOT npm/yarn/pnpm)
**Language:** TypeScript preferred over Python
**Markup:** Markdown preferred over HTML

## Command Reference

### Voice Management

#### `/atlas-voice <personality>`
**Purpose:** Switch active voice personality for TTS output
**Parameters:**
- `<personality>` - Required. One of: pai, intern, engineer, architect, researcher, designer, artist, pentester, writer

**Example:**
```
/atlas-voice intern     # Switch to enthusiastic intern personality
/atlas-voice architect  # Switch to deliberate architect personality
```

**Behavior:**
- Executes: `bun run ~/.claude/hooks/lib/voice-controller.ts --personality <name>`
- Personality persists for current session
- Voice characteristics defined in `~/.claude/voice-personalities.json`

#### `/atlas-voices`
**Purpose:** List all configured voice personalities with descriptions
**Parameters:** None

**Output Format:**
```
🎙️  Atlas Voice Personalities

  pai          - Professional, expressive - Daniel's primary AI assistant
  intern       - Enthusiastic, chaotic energy - eager 176 IQ genius
  engineer     - Wise leader, stable - Fortune 10 principal engineer
  ...
```

---

### Skills

Skills are specialized capabilities that can be invoked via the Skill tool or slash commands.

#### `/atlas-art <task>`
**Purpose:** Launch Art skill for visual content generation
**Domain:** Excalidraw-style diagrams, comics, architectural sketches
**Delegation:** Uses `Skill` tool to invoke "Art" skill
**Example:**
```
/atlas-art Create a system architecture diagram for microservices
```

#### `/atlas-agents <task>`
**Purpose:** Launch Agents skill for custom agent composition
**Domain:** Multi-agent orchestration, personality assignment, parallel execution
**Delegation:** Uses `Skill` tool to invoke "Agents" skill
**Example:**
```
/atlas-agents Spawn 3 researchers to analyze this codebase
```

#### `/atlas-prompting <task>`
**Purpose:** Launch Prompting skill for meta-prompting
**Domain:** Template generation, prompt optimization, pattern libraries
**Delegation:** Uses `Skill` tool to invoke "Prompting" skill
**Example:**
```
/atlas-prompting Generate a template for code review prompts
```

#### `/atlas-skills`
**Purpose:** List all installed skills
**Output:** Skill name + description from each `SKILL.md`

---

### System Status

#### `/atlas-status`
**Purpose:** Quick system health overview
**Checks:**
- PAI_DIR, DA, PAI_SOURCE_APP, TIME_ZONE environment variables
- Voice server (port 3456)
- Skills directory
- Hooks configuration

**Output Format:**
```
🤖 Atlas System Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📍 PAI Directory: /Users/ed/.claude
🎯 Assistant: Atlas
🌍 Source App: Atlas
🕐 Timezone: America/New_York

Voice Server:
  ✅ Running on port 3456

Active Skills:
  📚 Skills loaded: 7

Hooks:
  🪝 Hook events configured: 6
```

#### `/atlas-check`
**Purpose:** Comprehensive system health check
**Analysis:**
1. Directory structure validation
2. Configuration integrity (settings.json)
3. Hook system verification
4. Skills system validation
5. Voice system status
6. Custom commands validation
7. Dependency checks (bun, git)

**Output:** Structured report with ✅/⚠️/❌ status codes

#### `/atlas-hooks`
**Purpose:** Show active hook configuration
**Source:** `~/.claude/settings.json`
**Output:** Lists all hook events and their registered handlers

**Example Output:**
```
🪝 Atlas Hooks Configuration

SessionStart:
  • start-voice-server.ts
  • initialize-session.ts
  • load-core-context.ts

PreToolUse:
  • security-validator.ts
```

#### `/atlas-context`
**Purpose:** Show current session context
**Information:**
- Identity (Assistant: Atlas, User: Ed)
- Environment variables
- Active session metadata
- Stack preferences

---

### Observability

#### `/atlas-observability [action]`
**Purpose:** Control real-time monitoring dashboard
**Parameters:**
- `[action]` - Optional. One of: start, stop, restart, status (default: start)

**Requirements:**
- Observability server installed at `~/.claude/observability/`
- kai-observability-server pack

**Behavior:**
- **start:** Launch WebSocket server + Vue dashboard (port 5173)
- **stop:** Shut down server processes
- **restart:** Stop and start in sequence
- **status:** Show running processes

**Dashboard Features:**
- Real-time event streaming via WebSocket
- Multi-agent swim lanes
- Event timeline visualization
- Automatic JSONL ingestion from `~/.claude/history/raw-outputs/`

**Example:**
```
/atlas-observability        # Start dashboard
/atlas-observability stop   # Shut down
```

---

### Stack & Preferences

#### `/atlas-stack-check`
**Purpose:** Verify project follows Atlas stack preferences
**Allowed Tools:** Read, Glob, Grep

**Validation:**
1. Package manager: Check for `bun.lockb` (✅) vs `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml` (❌)
2. Language: Count TypeScript files vs Python files
3. Scripts: Verify `package.json` uses `bun` commands
4. Documentation: Check for `.md` files over `.html`

**Output:** Report violations and suggest corrections

---

### Pack Management

Packs are self-contained markdown files that add capabilities to Atlas.

#### `/atlas-packs`
**Purpose:** List available PAI packs from repository
**Source:** `~/Developer/PAI/Packs/`
**Categories:**
- Feature Packs: `kai-*-system.md` (architecture systems)
- Skill Packs: `kai-*-skill.md` (action-oriented capabilities)
- Core Packs: `kai-core-*.md` (foundational infrastructure)

**Example Output:**
```
📦 Atlas Pack System

Feature Packs:
  • kai-history-system
  • kai-hook-system
  • kai-observability-server
  • kai-voice-system

Skill Packs:
  • kai-agents-skill
  • kai-art-skill
  • kai-prompting-skill
```

#### `/atlas-install <pack-name>`
**Purpose:** Install a PAI pack
**Allowed Tools:** Read, Write, Edit, Bash

**Process:**
1. Read pack file: `~/Developer/PAI/Packs/<pack-name>.md`
2. Parse contents (code files, settings, dependencies)
3. Create required directories
4. Write all code files
5. Merge settings.json configuration
6. Verify installation
7. Report status

**Safety:** Does not overwrite existing configurations; merges instead

**Example:**
```
/atlas-install kai-history-system
```

#### `/atlas-docs [doc]`
**Purpose:** Access PAI documentation
**Parameters:**
- `[doc]` - Optional. One of: readme, packs, platform, security

**Available Docs:**
- `readme` - PAI project overview
- `packs` - Pack system documentation
- `platform` - Platform architecture
- `security` - Security protocols

**Behavior:**
- Without parameter: Lists available docs
- With parameter: Outputs full document content

---

### Utilities

#### `/atlas-help`
**Purpose:** Show complete command reference
**Output:** Categorized list of all 17 commands with descriptions

#### `/atlas-create-skill <name>`
**Purpose:** Scaffold a new Atlas skill
**Parameters:**
- `<name>` - Required. Skill name (no spaces)

**Process:**
1. Create `~/.claude/skills/<name>/`
2. Generate `SKILL.md` with template structure
3. Register in skills directory
4. Provide usage instructions

**Template Structure:**
```markdown
---
name: SkillName
description: Brief description
---

# SkillName

## When to Use
## Capabilities
## Usage
## Examples
## Technical Details
```

---

## Usage Patterns for AI Agents

### Detecting Available Commands
```bash
# List all atlas commands
ls ~/.claude/commands/atlas-*.md

# Check if specific command exists
[ -f ~/.claude/commands/atlas-observability.md ] && echo "Observability available"
```

### Invoking Commands Programmatically
Commands can be invoked directly in Claude Code sessions:
```
User: /atlas-status
User: /atlas-voice engineer
User: /atlas-observability start
```

### Checking Dependencies
```bash
# Check for required runtime
which bun

# Verify PAI directory
[ -d ~/.claude ] && echo "Atlas installed"

# Check observability server
[ -f ~/.claude/observability/manage.sh ] && echo "Observability ready"
```

### Parsing Command Output
Most commands output structured text with:
- Emoji markers (🤖, 📚, ✅, ❌, ⚠️)
- Section dividers (━━━)
- Labeled fields (Key: Value)

**Pattern Recognition:**
```
✅ = Success/Running
❌ = Failure/Not Found
⚠️ = Warning
📚 = Information
🎯 = Context/Identity
```

---

## Integration Points

### With Skills System
Commands can invoke skills via the `Skill` tool:
- `/atlas-art` → Skill("Art")
- `/atlas-agents` → Skill("Agents")
- `/atlas-prompting` → Skill("Prompting")

### With Hooks System
Commands execute hooks via `bun run`:
- Voice control: `~/.claude/hooks/lib/voice-controller.ts`
- Event capture: `~/.claude/hooks/capture-all-events.ts`
- Session init: `~/.claude/hooks/initialize-session.ts`

### With Observability
Commands can start/stop the WebSocket server:
- Server: `~/.claude/observability/apps/server/`
- Client: `~/.claude/observability/apps/client/`
- Manager: `~/.claude/observability/manage.sh`

---

## Environment Variables

**Required:**
- `PAI_DIR` - Atlas installation directory (usually `~/.claude`)
- `DA` - Digital Assistant name (Atlas)
- `PAI_SOURCE_APP` - Source application (Atlas)
- `TIME_ZONE` - User timezone (e.g., America/New_York)

**Optional:**
- `ELEVENLABS_VOICE_*` - Voice IDs for TTS personalities

---

## Error Handling

### Common Error Patterns

**Command Not Found:**
```
bash: /atlas-foo: No such file or directory
```
→ Command doesn't exist. Use `/atlas-help` to list available commands.

**Dependency Missing:**
```
❌ Observability server not installed
```
→ Install required pack: `/atlas-install kai-observability-server`

**Runtime Error:**
```
bun: command not found
```
→ Install bun runtime (Atlas dependency)

### Graceful Degradation
Commands check for dependencies before execution:
```bash
if [ -f ~/.claude/observability/manage.sh ]; then
  # Execute command
else
  echo "❌ Not installed"
  echo "To install: /atlas-install <pack>"
fi
```

---

## Security Considerations

### Hook Execution
All hooks run via `bun run` with:
- User-level permissions (no sudo)
- Sandboxed execution environment
- Security validation via `security-validator.ts` hook

### Command Injection Protection
Commands use:
- Parameterized inputs (`$1`, `$2`)
- Quote escaping in shell commands
- Input validation before execution

### File System Access
Commands only access:
- `~/.claude/` - Atlas installation directory
- `~/Developer/PAI/` - PAI pack repository
- Current working directory (read-only)

---

## Troubleshooting

### Voice Server Not Running
```bash
# Check process
lsof -ti:3456

# Start manually
bun run ~/.claude/hooks/start-voice-server.ts
```

### Skills Not Loading
```bash
# Verify skills directory
ls -la ~/.claude/skills/*/SKILL.md

# Check skill format
cat ~/.claude/skills/CORE/SKILL.md | head -20
```

### Observability Dashboard Won't Start
```bash
# Check installation
~/.claude/observability/manage.sh status

# View logs
tail ~/.claude/observability/apps/server/logs/*.log
```

---

## Version Information

- **Command System Version:** 1.0.0
- **Total Commands:** 17
- **Namespace:** `atlas-*`
- **Runtime:** bun
- **Platform:** Claude Code
- **Compatible With:** PAI Pack System v1.0+

---

## For Developers

### Adding New Commands

1. Create `.md` file: `ai/.claude/commands/atlas-<name>.md`
2. Add frontmatter:
   ```yaml
   ---
   description: Brief description for autocomplete
   allowed-tools: [Read, Write, Bash]  # Optional
   ---
   ```
3. Document usage with `$ARGUMENTS`, `$1`, `$2`
4. Prefix shell commands with `!`
5. Update `/atlas-help` command
6. Update `README.md`
7. Update this file (ATLAS_COMMANDS.md)

### Testing Commands

```bash
# Test locally (before stowing)
cat ai/.claude/commands/atlas-test.md

# Install via stow
cd ~/.dotfiles && make update

# Verify installation
ls ~/.claude/commands/atlas-test.md

# Test in Claude Code
/atlas-test
```

### Debugging Commands

```bash
# View command source
cat ~/.claude/commands/atlas-<name>.md

# Check for syntax errors
bash -n <(sed -n '/^!/p' ~/.claude/commands/atlas-<name>.md | sed 's/^!//')

# Trace execution
bash -x <(sed -n '/^!/p' ~/.claude/commands/atlas-<name>.md | sed 's/^!//')
```

---

## Related Documentation

- **User README:** `ai/.claude/commands/README.md`
- **PAI Documentation:** `~/Developer/PAI/README.md`
- **Pack System:** `~/Developer/PAI/PACKS.md`
- **Skills Index:** `~/.claude/skills/skill-index.json`
- **Hook System:** `~/.claude/settings.json`

---

**Last Updated:** 2026-01-03
**Maintained By:** Ed (Atlas user)
**For AI Agents:** This document is authoritative for Atlas command system integration
