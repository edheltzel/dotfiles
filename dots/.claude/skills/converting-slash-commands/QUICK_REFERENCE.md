# Quick Reference: Claude Code → OpenCode Command Conversion

## Field Mapping

| Claude Code | OpenCode | Notes |
|-------------|----------|-------|
| `description: ...` | `description: ...` | Keep identical |
| `allowed-tools: Tool1, Tool2` | `agent: agent-name` | Convert to agent selection |
| `argument-hint: [args]` | N/A | Not supported (document in description) |
| `model: model-name` | `model: provider/model-name` | Add provider prefix |
| `disable-model-invocation: true` | N/A | Not supported |
| *(none)* | `subtask: true` | **New:** Force subagent invocation |
| *(none)* | `template: "..."` | **New:** JSON format only |

## Directory Mapping

| Claude Code | OpenCode |
|-------------|----------|
| `.claude/commands/` | `.opencode/command/` |
| `~/.claude/commands/` | `~/.config/opencode/command/` |

## Command Content

All these work the same in both systems:

| Feature | Syntax | Example |
|---------|--------|---------|
| All arguments | `$ARGUMENTS` | `Fix issue $ARGUMENTS` |
| Positional args | `$1`, `$2`, `$3` | `Review PR #$1 with priority $2` |
| Shell commands | ``` !`command` ``` | ``` !`git status` ``` |
| File references | `@filename` | `@src/components/Button.tsx` |

## Quick Conversion Templates

### Simple Command

**Claude Code:**
```yaml
---
description: Review code
allowed-tools: Read, Grep
---

Review this code for bugs.
```

**OpenCode:**
```yaml
---
description: Review code
agent: plan
---

Review this code for bugs.
```

### Command with Arguments

**Claude Code:**
```yaml
---
argument-hint: [component-name]
description: Create component
---

Create a React component named $ARGUMENTS.
```

**OpenCode:**
```yaml
---
description: Create component [name]
agent: build
---

Create a React component named $ARGUMENTS.
```

### Command with Shell Execution

**Claude Code:**
```yaml
---
allowed-tools: Bash(git*), Read
description: Git commit
---

Status: !`git status`
Create a commit.
```

**OpenCode:**
```yaml
---
description: Git commit
agent: build
---

Status: !`git status`
Create a commit.
```

### Subagent Command

**OpenCode only:**
```yaml
---
description: Deep analysis
agent: plan
subtask: true
---

Perform deep analysis of the codebase.
```

## Agent Selection Guide

Choose the right agent for your command:

| Command Purpose | Recommended Agent |
|----------------|-------------------|
| Code analysis/review | `plan` |
| Code modification | `build` |
| General tasks | `build` |
| Specialized task | Your custom agent |
| Force subagent | Add `subtask: true` |

## Model String Formats

**Claude Code:**
```yaml
model: claude-3-5-sonnet-20241022
```

**OpenCode:**
```yaml
model: anthropic/claude-3-5-sonnet-20241022
```

Add the provider prefix: `anthropic/`, `openai/`, etc.

## Namespacing Differences

**Claude Code:**
- File: `.claude/commands/frontend/component.md`
- Command: `/component`
- Description shows: "(project:frontend)"

**OpenCode:**
- File: `.opencode/command/frontend/component.md`
- Command: `/frontend/component`
- Subdirectory is part of command name

## Quick Conversion Steps

1. **Copy file** to `.opencode/command/` with same name
2. **Update frontmatter:**
   - Change `allowed-tools` to `agent`
   - Remove `argument-hint` (document in description)
   - Add provider to `model` string
   - Remove `disable-model-invocation`
3. **Keep content unchanged** - Arguments, shell commands, file refs work the same
4. **Test** with `/command-name`

## Common Issues

**Command not appearing:**
- Check file location (`.opencode/command/`)
- Verify YAML frontmatter is valid
- Restart OpenCode

**Arguments not working:**
- Use `$ARGUMENTS`, `$1`, `$2` (not other syntax)
- Pass arguments when invoking: `/cmd arg1 arg2`

**Shell commands not working:**
- Check syntax: ``` !`command` ```
- Ensure agent has bash permissions

**Model errors:**
- Use full provider/model format
- Check provider is configured
- Or use `model: inherit`

## Validation Checklist

- [ ] File in `.opencode/command/` or `~/.config/opencode/command/`
- [ ] Description field present (recommended)
- [ ] Model has provider prefix (if specified)
- [ ] Agent selected appropriately (if specified)
- [ ] Arguments preserved (`$ARGUMENTS`, `$1`, etc.)
- [ ] Shell commands preserved (``` !`command` ```)
- [ ] File references preserved (`@filename`)
- [ ] Tested with `/command-name`
