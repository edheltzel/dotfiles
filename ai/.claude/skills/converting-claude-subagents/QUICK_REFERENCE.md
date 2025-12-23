# Quick Reference: Claude Code → OpenCode Agent Conversion

## Field Mapping

| Claude Code | OpenCode | Notes |
|-------------|----------|-------|
| `name: agent-name` | Filename: `agent-name.md` | Name field removed in OpenCode markdown |
| `description: ...` | `description: ...` | **Required**, keep identical |
| `tools: Tool1, Tool2` | `tools: {tool1: true, tool2: true}` | Convert to object format |
| `model: sonnet` | `model: anthropic/claude-sonnet-4-20250514` | Full provider/model string |
| *(none)* | `mode: subagent` | **New:** Explicit agent type |
| *(none)* | `temperature: 0.2` | **New:** Response variability (0.0-1.0) |
| *(none)* | `permission: {...}` | **New:** Granular permissions |

## Directory Mapping

| Claude Code | OpenCode |
|-------------|----------|
| `.claude/agents/` | `.opencode/agent/` |
| `~/.claude/agents/` | `~/.config/opencode/agent/` |

## Tool Format Conversion

**Claude Code:**
```yaml
tools: Read, Grep, Glob, Bash
```

**OpenCode:**
```yaml
tools:
  read: true
  grep: true
  glob: true
  bash: true
  write: false   # Explicit disable
  edit: false    # Explicit disable
```

**Omitted tools field:** Inherits all tools (same in both systems)

## Temperature Guidelines

- **0.0-0.2**: Focused, precise (code review, security audit)
- **0.2-0.4**: Balanced (debugging, testing)
- **0.4-0.7**: Creative (documentation, brainstorming)

## Permission Options

```yaml
permission:
  edit: ask      # Options: ask | allow | deny
  bash:
    "git status": allow
    "git push": ask
    "*": ask
  webfetch: deny
```

## Common Patterns

### Read-Only Analyst
```yaml
mode: subagent
tools: {read: true, grep: true, glob: true}
permission: {edit: deny, bash: deny}
```

### Debugger with Edits
```yaml
mode: subagent
tools: {read: true, edit: true, bash: true, grep: true}
permission: {edit: ask, bash: ask}
```

### Full Development
```yaml
mode: primary
# tools: (omit to inherit all)
permission:
  bash: {"rm -rf*": ask, "git push": ask, "*": allow}
```

## Quick Commands

**Convert single agent:**
```bash
~/.config/opencode/skills/converting-claude-subagents/scripts/convert_subagent.sh \
  .claude/agents/my-agent.md
```

**View examples:**
```bash
cat ~/.config/opencode/skills/converting-claude-subagents/EXAMPLES.md
```

**Read full documentation:**
```bash
cat ~/.config/opencode/skills/converting-claude-subagents/SKILL.md
```

## Validation Checklist

- [ ] File in `.opencode/agent/` or `~/.config/opencode/agent/`
- [ ] No `name` field in frontmatter
- [ ] `description` field present
- [ ] `mode` set to `subagent`, `primary`, or `all`
- [ ] Tools in object format (not comma-separated)
- [ ] Model string valid for provider
- [ ] System prompt preserved exactly
- [ ] Test with `@agent-name`

## Common Issues

**Agent not appearing:**
- Check file location
- Verify YAML frontmatter is valid
- Ensure `description` field exists
- Check for `disable: true`

**Tools not working:**
- Use lowercase tool names
- Use object format, not comma-separated
- Check permissions aren't blocking

**Different behavior:**
- Adjust `temperature`
- Review `permission` settings
- Verify prompt is identical
