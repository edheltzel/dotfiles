# Conversion Examples

This file contains detailed examples of converting Claude Code slash commands to OpenCode commands.

## Example 1: Simple Code Review Command

### Claude Code Format

File: `.claude/commands/review.md`

```markdown
---
description: Review code for quality and security
allowed-tools: Read, Grep, Glob
model: claude-3-5-sonnet-20241022
---

Review this code for:
- Code quality and maintainability
- Security vulnerabilities
- Performance issues
- Best practices

Provide constructive feedback.
```

### OpenCode Format

File: `.opencode/command/review.md`

```markdown
---
description: Review code for quality and security
agent: plan
model: anthropic/claude-3-5-sonnet-20241022
---

Review this code for:
- Code quality and maintainability
- Security vulnerabilities
- Performance issues
- Best practices

Provide constructive feedback.
```

### Key Changes
- Changed `allowed-tools: Read, Grep, Glob` to `agent: plan`
- Added `anthropic/` prefix to model string
- Command content unchanged

### Usage

Both systems: `/review`

---

## Example 2: Git Commit Command with Bash Execution

### Claude Code Format

File: `.claude/commands/commit.md`

```markdown
---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Create a git commit
model: inherit
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Based on the above changes, create a single git commit with an appropriate message.
```

### OpenCode Format

File: `.opencode/command/commit.md`

```markdown
---
description: Create a git commit
agent: build
model: inherit
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Based on the above changes, create a single git commit with an appropriate message.
```

### Key Changes
- Changed `allowed-tools: Bash(...)` to `agent: build`
- Shell command syntax (``` !`command` ```) unchanged
- Model inheritance preserved

### Usage

Both systems: `/commit`

---

## Example 3: PR Review with Arguments

### Claude Code Format

File: `.claude/commands/review-pr.md`

```markdown
---
argument-hint: [pr-number] [priority] [assignee]
description: Review pull request
allowed-tools: Read, Grep, Bash(gh:*)
---

Review PR #$1 with priority $2 and assign to $3.

Focus on:
- Security implications
- Performance impact
- Code style consistency
- Test coverage

Use !`gh pr view $1` to fetch PR details.
```

### OpenCode Format

File: `.opencode/command/review-pr.md`

```markdown
---
description: Review pull request [pr-number] [priority] [assignee]
agent: plan
---

Review PR #$1 with priority $2 and assign to $3.

Focus on:
- Security implications
- Performance impact
- Code style consistency
- Test coverage

Use !`gh pr view $1` to fetch PR details.
```

### Key Changes
- Removed `argument-hint` field
- Documented arguments in description instead
- Changed `allowed-tools` to `agent: plan`
- Argument placeholders (`$1`, `$2`, `$3`) unchanged
- Shell command with argument (`!`gh pr view $1``) unchanged

### Usage

Both systems: `/review-pr 456 high alice`

---

## Example 4: Test Runner Command

### Claude Code Format

File: `.claude/commands/test.md`

```markdown
---
description: Run tests with coverage
allowed-tools: Bash(npm:*), Bash(jest:*), Read
---

Run the test suite:
!`npm test -- --coverage`

Analyze the results and:
1. Identify failing tests
2. Suggest fixes for failures
3. Recommend ways to improve coverage
```

### OpenCode Format

File: `.opencode/command/test.md`

```markdown
---
description: Run tests with coverage
agent: build
---

Run the test suite:
!`npm test -- --coverage`

Analyze the results and:
1. Identify failing tests
2. Suggest fixes for failures
3. Recommend ways to improve coverage
```

### Key Changes
- Changed `allowed-tools` to `agent: build`
- Shell command syntax unchanged

### Usage

Both systems: `/test`

---

## Example 5: Documentation Generator

### Claude Code Format

File: `.claude/commands/docs.md`

```markdown
---
description: Generate documentation
allowed-tools: Read, Write, Grep, Glob
model: claude-3-5-haiku-20241022
---

Generate comprehensive documentation for $ARGUMENTS.

Include:
- Overview and purpose
- API reference
- Usage examples
- Configuration options

Save to docs/$ARGUMENTS.md
```

### OpenCode Format

File: `.opencode/command/docs.md`

```markdown
---
description: Generate documentation [component-name]
agent: build
model: anthropic/claude-3-5-haiku-20241022
---

Generate comprehensive documentation for $ARGUMENTS.

Include:
- Overview and purpose
- API reference
- Usage examples
- Configuration options

Save to docs/$ARGUMENTS.md
```

### Key Changes
- Added argument hint to description
- Changed `allowed-tools` to `agent: build`
- Added provider prefix to model
- `$ARGUMENTS` placeholder unchanged

### Usage

Both systems: `/docs Button`

---

## Example 6: File Analysis with References

### Claude Code Format

File: `.claude/commands/analyze.md`

```markdown
---
description: Analyze component architecture
allowed-tools: Read, Grep, Glob
---

Analyze the architecture of the component:

@src/components/$ARGUMENTS.tsx

Also check related files:
- @src/components/$ARGUMENTS.test.tsx
- @src/components/$ARGUMENTS.styles.ts

Provide insights on:
1. Component structure
2. Dependencies
3. Test coverage
4. Potential improvements
```

### OpenCode Format

File: `.opencode/command/analyze.md`

```markdown
---
description: Analyze component architecture [component-name]
agent: plan
---

Analyze the architecture of the component:

@src/components/$ARGUMENTS.tsx

Also check related files:
- @src/components/$ARGUMENTS.test.tsx
- @src/components/$ARGUMENTS.styles.ts

Provide insights on:
1. Component structure
2. Dependencies
3. Test coverage
4. Potential improvements
```

### Key Changes
- Added argument hint to description
- Changed `allowed-tools` to `agent: plan`
- File reference syntax (`@filename`) unchanged
- Argument in file path (`$ARGUMENTS`) unchanged

### Usage

Both systems: `/analyze Button`

---

## Example 7: Subagent Analysis (OpenCode Only)

### OpenCode Format

File: `.opencode/command/deep-analysis.md`

```markdown
---
description: Perform deep codebase analysis
agent: plan
subtask: true
model: anthropic/claude-3-5-sonnet-20241022
---

Perform a comprehensive analysis of the codebase:

1. Identify architectural patterns
2. Find potential performance bottlenecks
3. Detect security vulnerabilities
4. Suggest improvements

This is a deep analysis that should run as a separate task.
```

### Key Features
- `subtask: true` forces subagent invocation
- Runs in isolated context
- Doesn't pollute main conversation

### Usage

OpenCode: `/deep-analysis`

---

## Example 8: JSON Configuration Format

### OpenCode JSON Format

File: `opencode.json`

```json
{
  "$schema": "https://opencode.ai/config.json",
  "command": {
    "review": {
      "description": "Review code for quality and security",
      "template": "Review this code for:\n- Code quality and maintainability\n- Security vulnerabilities\n- Performance issues\n- Best practices\n\nProvide constructive feedback.",
      "agent": "plan",
      "model": "anthropic/claude-3-5-sonnet-20241022"
    },
    "commit": {
      "description": "Create a git commit",
      "template": "## Context\n\n- Current git status: !`git status`\n- Current git diff: !`git diff HEAD`\n\n## Your task\n\nCreate a git commit.",
      "agent": "build"
    }
  }
}
```

### Key Features
- Multiple commands in single file
- `template` field contains command content
- Useful for programmatic configuration
- All other fields work the same as markdown

---

## Example 9: Namespaced Commands

### Claude Code Format

File: `.claude/commands/frontend/component.md`

```markdown
---
description: Create new React component
---

Create a new React component named $ARGUMENTS with TypeScript support.
```

**Command:** `/component`
**Description shows:** "(project:frontend)"

### OpenCode Format

File: `.opencode/command/frontend/component.md`

```markdown
---
description: Create new React component
---

Create a new React component named $ARGUMENTS with TypeScript support.
```

**Command:** `/frontend/component`

### Key Difference

Claude Code: Subdirectory shown in description, not command name
OpenCode: Subdirectory is part of the command name

---

## Example 10: Complex Command with All Features

### Claude Code Format

File: `.claude/commands/deploy.md`

```markdown
---
allowed-tools: Bash(npm:*), Bash(git:*), Read, Write
argument-hint: [environment] [version]
description: Deploy application
model: claude-3-5-sonnet-20241022
---

# Deployment Command

Deploy to environment: $1
Version: $2

## Pre-deployment Checks

Current branch: !`git branch --show-current`
Git status: !`git status`
Package version: !`npm version`

## Build Configuration

Review build config: @package.json

## Deployment Steps

1. Run tests: !`npm test`
2. Build for production: !`npm run build`
3. Deploy to $1 environment
4. Tag release as v$2

Confirm all checks pass before proceeding.
```

### OpenCode Format

File: `.opencode/command/deploy.md`

```markdown
---
description: Deploy application [environment] [version]
agent: build
model: anthropic/claude-3-5-sonnet-20241022
---

# Deployment Command

Deploy to environment: $1
Version: $2

## Pre-deployment Checks

Current branch: !`git branch --show-current`
Git status: !`git status`
Package version: !`npm version`

## Build Configuration

Review build config: @package.json

## Deployment Steps

1. Run tests: !`npm test`
2. Build for production: !`npm run build`
3. Deploy to $1 environment
4. Tag release as v$2

Confirm all checks pass before proceeding.
```

### Key Changes
- Moved `argument-hint` to description
- Changed `allowed-tools` to `agent: build`
- Added provider to model string
- All special syntax preserved:
  - Positional arguments: `$1`, `$2`
  - Shell commands: ``` !`command` ```
  - File references: `@package.json`

### Usage

Both systems: `/deploy production 1.2.3`

---

## Batch Conversion Script

If you have multiple commands to convert, use a script:

```bash
#!/bin/bash
# batch_convert.sh - Convert all Claude Code commands to OpenCode

CLAUDE_DIR=".claude/commands"
OPENCODE_DIR=".opencode/command"

# Create output directory
mkdir -p "$OPENCODE_DIR"

# Convert each command
for file in "$CLAUDE_DIR"/*.md; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        echo "Converting: $filename"
        
        # Simple conversion - copy file and update frontmatter
        # This is a basic example - you may need to customize
        cp "$file" "$OPENCODE_DIR/$filename"
        
        # Use sed to replace common patterns
        sed -i '' 's/allowed-tools:.*/agent: build/' "$OPENCODE_DIR/$filename"
        sed -i '' '/argument-hint:/d' "$OPENCODE_DIR/$filename"
        sed -i '' 's/model: claude-/model: anthropic\/claude-/' "$OPENCODE_DIR/$filename"
        sed -i '' '/disable-model-invocation:/d' "$OPENCODE_DIR/$filename"
        
        echo "Converted to: $OPENCODE_DIR/$filename"
    fi
done

echo ""
echo "Batch conversion complete!"
echo "Review converted files in: $OPENCODE_DIR"
echo "Test each command before deleting originals"
```

**Usage:**
```bash
chmod +x batch_convert.sh
./batch_convert.sh
```

---

## Testing Converted Commands

After conversion, test each command:

1. **Invoke the command:**
   ```
   /command-name args
   ```

2. **Verify all features work:**
   - Arguments are substituted correctly
   - Shell commands execute and output is captured
   - File references load the correct files
   - Command runs with appropriate agent

3. **Check output quality:**
   - Compare responses to original Claude Code command
   - Adjust agent if behavior differs significantly

4. **Review permissions:**
   - Ensure agent has necessary tool permissions
   - Verify bash commands are allowed

5. **Document differences:**
   - Note any behavioral changes
   - Update description if needed
   - Adjust agent or add `subtask` flag as needed
