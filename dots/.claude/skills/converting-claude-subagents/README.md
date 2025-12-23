# Converting Claude Code Subagents to OpenCode Agents

This skill helps you migrate from Claude Code's subagent system to OpenCode's agent system.

## Quick Start

1. **Read the main skill documentation:**
   ```bash
   cat SKILL.md
   ```

2. **See practical examples:**
   ```bash
   cat EXAMPLES.md
   ```

3. **Use the conversion script:**
   ```bash
   scripts/convert_subagent.sh ~/.claude/agents/my-agent.md
   ```

## What This Skill Does

- Explains differences between Claude Code and OpenCode agent systems
- Provides step-by-step conversion workflow
- Shows field mapping and format conversion
- Includes comprehensive examples
- Offers automated conversion script

## When to Use This Skill

Use this skill when:
- Migrating from Claude Code to OpenCode
- Converting existing subagent definitions
- Learning the differences between the two systems
- Needing reference for agent configuration formats

## Files in This Skill

- `SKILL.md` - Main skill documentation with workflow and patterns
- `EXAMPLES.md` - Detailed conversion examples with before/after
- `scripts/convert_subagent.sh` - Automated conversion tool
- `README.md` - This file

## Key Concepts

### Format Differences

**Claude Code:**
```yaml
---
name: agent-name
description: What it does
tools: Tool1, Tool2, Tool3
model: sonnet
---
```

**OpenCode:**
```yaml
---
description: What it does
mode: subagent
tools:
  tool1: true
  tool2: true
  tool3: true
model: anthropic/claude-sonnet-4-20250514
temperature: 0.2
permission:
  edit: ask
  bash: ask
---
```

### Major Additions in OpenCode

1. **Mode field:** Explicitly set agent type (primary/subagent/all)
2. **Temperature:** Control response variability
3. **Permissions:** Granular control beyond tool access
4. **Tool format:** Object with boolean values instead of comma-separated list

### Agent Types

- **Primary agents:** Main assistants you interact with (switch with Tab key)
- **Subagents:** Specialized assistants invoked with @ mention or automatically

## Usage Examples

### Convert a single agent:
```bash
./scripts/convert_subagent.sh .claude/agents/code-reviewer.md
```

### Convert to specific directory:
```bash
./scripts/convert_subagent.sh \
  ~/.claude/agents/debugger.md \
  ~/.config/opencode/agent/
```

### Manual conversion:
Just read the SKILL.md and follow the step-by-step workflow.

## Tips

1. Start with read-only agents (lowest risk)
2. Test each converted agent before converting more
3. Use the permission system for safety
4. Adjust temperature based on agent purpose:
   - 0.0-0.2: Focused, analytical (code review, security)
   - 0.2-0.4: Balanced (debugging, testing)
   - 0.4-0.7: Creative (documentation, brainstorming)

## Common Issues

**Agent not appearing:**
- Check file location (`.opencode/agent/` or `~/.config/opencode/agent/`)
- Verify frontmatter YAML is valid
- Ensure `description` field exists

**Tools not working:**
- Verify object format (not comma-separated)
- Check permissions aren't blocking
- Ensure lowercase tool names

**Behavior differs:**
- Adjust `temperature` setting
- Review `permission` configuration
- Verify system prompt is identical

## Related Documentation

- OpenCode Agents: https://opencode.ai/docs/agents/
- Claude Code Subagents: https://code.claude.com/docs/en/sub-agents

## Contributing

Found an issue or have improvements? The skill files are in:
`~/.config/opencode/skills/converting-claude-subagents/`

Feel free to edit and enhance!
