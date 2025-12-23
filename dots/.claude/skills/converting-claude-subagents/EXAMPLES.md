# Conversion Examples

This file contains detailed examples of converting Claude Code Subagents to OpenCode Agents.

## Example 1: Simple Code Reviewer (Read-Only)

### Claude Code Format

File: `.claude/agents/code-reviewer.md`

```markdown
---
name: code-reviewer
description: Reviews code for quality, security, and best practices
tools: Read, Grep, Glob
model: sonnet
---

You are a code reviewer. Focus on:
- Code quality and maintainability
- Security vulnerabilities
- Performance issues
- Best practices

Provide constructive feedback without making changes.
```

### OpenCode Format

File: `.opencode/agent/code-reviewer.md`

```markdown
---
description: Reviews code for quality, security, and best practices
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
tools:
  read: true
  grep: true
  glob: true
  write: false
  edit: false
  bash: false
permission:
  edit: deny
  bash: deny
---

You are a code reviewer. Focus on:
- Code quality and maintainability
- Security vulnerabilities
- Performance issues
- Best practices

Provide constructive feedback without making changes.
```

### Key Changes
- Removed `name` field (filename is the name)
- Converted tools from comma-separated to object format
- Added explicit `mode: subagent`
- Converted model alias to full string
- Added `temperature: 0.1` for focused analysis
- Added explicit `permission` denials for safety
- System prompt unchanged

---

## Example 2: Debugger with Edit Access

### Claude Code Format

File: `.claude/agents/debugger.md`

```markdown
---
name: debugger
description: Debugging specialist for errors and test failures. Use when code isn't working.
tools: Read, Edit, Bash, Grep, Glob
model: inherit
---

You are an expert debugger.

Process:
1. Understand the error
2. Locate the cause
3. Implement minimal fix
4. Verify the solution

Focus on root causes, not symptoms.
```

### OpenCode Format

File: `.opencode/agent/debugger.md`

```markdown
---
description: Debugging specialist for errors and test failures. Use when code isn't working.
mode: subagent
model: inherit
temperature: 0.2
tools:
  read: true
  edit: true
  bash: true
  grep: true
  glob: true
  write: false
permission:
  edit: ask
  bash:
    "git diff": allow
    "git status": allow
    "npm test": allow
    "npm run test*": allow
    "*": ask
---

You are an expert debugger.

Process:
1. Understand the error
2. Locate the cause
3. Implement minimal fix
4. Verify the solution

Focus on root causes, not symptoms.
```

### Key Changes
- Tools converted to object format
- Added `temperature: 0.2` for debugging creativity
- Added granular bash permissions (allow safe git/test commands)
- Set `edit: ask` for safety
- Kept `model: inherit` as-is

---

## Example 3: Test Runner with Full Bash Access

### Claude Code Format

File: `.claude/agents/test-runner.md`

```markdown
---
name: test-runner
description: Runs tests and fixes failures. Use proactively after code changes.
tools: Bash, Read, Edit, Grep
---

You are a test automation expert.

When code changes:
1. Run appropriate tests
2. Analyze failures
3. Fix issues while preserving test intent
4. Verify all tests pass
```

### OpenCode Format

File: `.opencode/agent/test-runner.md`

```markdown
---
description: Runs tests and fixes failures. Use proactively after code changes.
mode: subagent
temperature: 0.2
tools:
  bash: true
  read: true
  edit: true
  grep: true
  glob: false
  write: false
permission:
  bash:
    "npm test": allow
    "npm run test*": allow
    "jest*": allow
    "pytest*": allow
    "rspec*": allow
    "*": ask
  edit: ask
---

You are a test automation expert.

When code changes:
1. Run appropriate tests
2. Analyze failures
3. Fix issues while preserving test intent
4. Verify all tests pass
```

### Key Changes
- Converted tools format
- Added specific test command permissions
- Added `temperature: 0.2`
- Disabled `glob` (not in original tools)
- Permission system for granular control

---

## Example 4: Documentation Writer (Write-Only)

### Claude Code Format

File: `~/.claude/agents/docs-writer.md`

```markdown
---
name: docs-writer
description: Writes and maintains documentation
tools: Read, Write, Grep, Glob
model: haiku
---

You are a technical documentation specialist.

Create clear, comprehensive documentation:
- User-friendly language
- Proper structure and formatting
- Practical code examples
- Accurate technical details
```

### OpenCode Format

File: `~/.config/opencode/agent/docs-writer.md`

```markdown
---
description: Writes and maintains documentation
mode: subagent
model: anthropic/claude-haiku-4-20250514
temperature: 0.4
tools:
  read: true
  write: true
  grep: true
  glob: true
  edit: false
  bash: false
permission:
  write: ask
---

You are a technical documentation specialist.

Create clear, comprehensive documentation:
- User-friendly language
- Proper structure and formatting
- Practical code examples
- Accurate technical details
```

### Key Changes
- Global agent (in `~/.config/opencode/agent/`)
- Converted model alias to full string
- Added `temperature: 0.4` for creative writing
- Tools converted to object format
- Permission for write operations

---

## Example 5: Security Auditor (Analysis Only)

### Claude Code Format

File: `.claude/agents/security-auditor.md`

```markdown
---
name: security-auditor
description: Performs security audits. Use before deploying or when reviewing sensitive code.
tools: Read, Grep, Glob, Bash
model: opus
---

You are a security expert. Identify vulnerabilities:

Critical checks:
- Input validation
- Authentication/authorization
- Data exposure risks
- Dependency vulnerabilities
- Configuration security

Provide severity ratings and remediation steps.
```

### OpenCode Format

File: `.opencode/agent/security-auditor.md`

```markdown
---
description: Performs security audits. Use before deploying or when reviewing sensitive code.
mode: subagent
model: anthropic/claude-opus-4-20250514
temperature: 0.1
tools:
  read: true
  grep: true
  glob: true
  bash: true
  write: false
  edit: false
permission:
  bash:
    "git log*": allow
    "git diff*": allow
    "npm audit": allow
    "pip-audit": allow
    "*": ask
  edit: deny
  write: deny
---

You are a security expert. Identify vulnerabilities:

Critical checks:
- Input validation
- Authentication/authorization
- Data exposure risks
- Dependency vulnerabilities
- Configuration security

Provide severity ratings and remediation steps.
```

### Key Changes
- Used more powerful model for security analysis
- Very low temperature (0.1) for precise analysis
- Allowed security-relevant bash commands
- Strict denials on write/edit
- Specific audit tool permissions

---

## Example 6: Data Analyst with BigQuery

### Claude Code Format

File: `.claude/agents/data-scientist.md`

```markdown
---
name: data-scientist
description: SQL and BigQuery expert for data analysis
tools: Bash, Read, Write
model: sonnet
---

You are a data scientist specializing in SQL and BigQuery.

Workflow:
1. Understand analysis requirements
2. Write efficient SQL queries
3. Use BigQuery CLI (bq) when appropriate
4. Analyze and summarize results
5. Present findings clearly

Best practices:
- Optimize queries with proper filters
- Document complex logic with comments
- Format results for readability
- Provide actionable insights
```

### OpenCode JSON Format

File: `opencode.json`

```json
{
  "agent": {
    "data-scientist": {
      "description": "SQL and BigQuery expert for data analysis",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "temperature": 0.3,
      "prompt": "{file:./.opencode/prompts/data-scientist.txt}",
      "tools": {
        "bash": true,
        "read": true,
        "write": true,
        "edit": false,
        "grep": false,
        "glob": false
      },
      "permission": {
        "bash": {
          "bq*": "allow",
          "psql*": "allow",
          "mysql*": "allow",
          "*": "ask"
        },
        "write": "ask"
      }
    }
  }
}
```

And create: `.opencode/prompts/data-scientist.txt`

```
You are a data scientist specializing in SQL and BigQuery.

Workflow:
1. Understand analysis requirements
2. Write efficient SQL queries
3. Use BigQuery CLI (bq) when appropriate
4. Analyze and summarize results
5. Present findings clearly

Best practices:
- Optimize queries with proper filters
- Document complex logic with comments
- Format results for readability
- Provide actionable insights
```

### Key Changes
- Used JSON format for programmatic access
- Moved prompt to separate file
- Added specific database CLI permissions
- Temperature tuned for analytical work
- Only enabled necessary tools

---

## Example 7: Primary Build Agent (Full Access)

### Claude Code Format

File: `.claude/agents/builder.md`

```markdown
---
name: builder
description: Full-featured development agent for building features
# No tools field = inherits all
model: sonnet
---

You are a software engineer with complete development access.

Capabilities:
- Read and modify all files
- Run any commands
- Install dependencies
- Commit changes
- Run tests

Use best judgment and ask before potentially destructive operations.
```

### OpenCode Format

File: `.opencode/agent/builder.md`

```markdown
---
description: Full-featured development agent for building features
mode: primary
model: anthropic/claude-sonnet-4-20250514
temperature: 0.3
# No tools field = inherits all tools
permission:
  bash:
    "rm -rf*": ask
    "git push*": ask
    "npm publish": ask
    "*": allow
  edit: allow
  write: allow
---

You are a software engineer with complete development access.

Capabilities:
- Read and modify all files
- Run any commands
- Install dependencies
- Commit changes
- Run tests

Use best judgment and ask before potentially destructive operations.
```

### Key Changes
- Set `mode: primary` (not subagent)
- No tools restriction (inherits all)
- Safety permissions for destructive commands
- Higher temperature for creative development
- Agent can be switched to with Tab key

---

## Batch Conversion Example

If you have multiple subagents to convert, use a script:

```bash
#!/bin/bash
# batch_convert.sh - Convert all Claude Code subagents

CLAUDE_DIR=".claude/agents"
OPENCODE_DIR=".opencode/agent"

# Create output directory
mkdir -p "$OPENCODE_DIR"

# Convert each subagent
for file in "$CLAUDE_DIR"/*.md; do
    if [ -f "$file" ]; then
        echo "Converting: $file"
        ~/.config/opencode/skills/converting-claude-subagents/scripts/convert_subagent.sh \
            "$file" \
            "$OPENCODE_DIR"
        echo ""
    fi
done

echo "Batch conversion complete!"
echo "Review converted files in: $OPENCODE_DIR"
```

---

## Complex Permission Example

For agents that need very specific bash permissions:

```yaml
---
description: DevOps agent with controlled deployment access
mode: subagent
tools:
  bash: true
  read: true
  edit: true
  write: true
permission:
  bash:
    # Git operations
    "git status": allow
    "git diff*": allow
    "git log*": allow
    "git pull": ask
    "git push": ask
    
    # Build operations
    "npm run build": allow
    "npm run test": allow
    "npm install": ask
    
    # Deployment (require approval)
    "npm run deploy*": ask
    "kubectl*": ask
    "docker*": ask
    
    # Dangerous operations (explicitly denied)
    "rm -rf*": deny
    "sudo*": deny
    
    # Everything else requires approval
    "*": ask
  
  edit:
    "package.json": ask
    "*.config.js": ask
    "*": allow
  
  write: ask
---
```

This provides fine-grained control over what the agent can do without supervision.

---

## Testing Converted Agents

After conversion, test each agent:

1. **Invoke the agent:**
   ```
   @agent-name help me analyze this code
   ```

2. **Verify tool access:**
   - Try operations that should work
   - Verify restricted operations are blocked or prompt for approval

3. **Check behavior:**
   - Compare responses to original Claude Code agent
   - Adjust temperature if behavior differs significantly

4. **Review permissions:**
   - Ensure destructive operations require approval
   - Verify safe operations are allowed

5. **Document differences:**
   - Note any behavioral changes
   - Update description if needed
   - Adjust tools or permissions based on testing
