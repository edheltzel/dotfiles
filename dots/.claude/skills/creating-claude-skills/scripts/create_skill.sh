#!/bin/bash
# create_skill.sh - Scaffold a new Claude Code skill
#
# Usage: create_skill.sh <skill-name> <description> [--personal|--project]
#
# Creates:
# - Skill directory structure
# - SKILL.md with frontmatter template
# - scripts/ subdirectory
#
# Flags:
#   --personal  Create in ~/.claude/skills/ (private to you)
#   --project   Create in .claude/skills/ (shared with team)
#
# If no flag is specified, auto-detects based on git repository presence
#
# Examples:
#   create_skill.sh generating-temporal-queries "Build temporal queries" --project
#   create_skill.sh my-workflow "Personal workflow helper" --personal

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() {
    echo -e "${GREEN}✓ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

notice() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check arguments
if [ -z "$1" ]; then
    echo "Usage: create_skill.sh <skill-name> <description> [--personal|--project]"
    echo ""
    echo "Flags:"
    echo "  --personal  Create in ~/.claude/skills/ (private to you)"
    echo "  --project   Create in .claude/skills/ (shared with team)"
    echo ""
    echo "If no flag is specified, auto-detects based on git repository."
    echo ""
    echo "Examples:"
    echo "  create_skill.sh generating-temporal-queries \"Build temporal queries\" --project"
    echo "  create_skill.sh my-workflow \"Personal workflow helper\" --personal"
    exit 1
fi

SKILL_NAME="$1"
DESCRIPTION="${2:-Add description here}"
LOCATION_FLAG="${3:-}"

# Validate skill name format
if [[ ! "$SKILL_NAME" =~ ^[a-z0-9-]+$ ]]; then
    echo "Error: Skill name must be lowercase letters, numbers, and hyphens only"
    exit 1
fi

# Check name length
if [ ${#SKILL_NAME} -gt 64 ]; then
    echo "Error: Skill name must be 64 characters or less (found ${#SKILL_NAME})"
    exit 1
fi

# Check for gerund form
if [[ ! "$SKILL_NAME" =~ -[a-z]*ing$ ]] && [[ ! "$SKILL_NAME" =~ ^[a-z]*ing- ]]; then
    warning "Name should use gerund form (verb + -ing): '$SKILL_NAME'"
fi

# Detect project context (look for .git directory)
IN_PROJECT=false
PROJECT_ROOT=""
if git rev-parse --show-toplevel >/dev/null 2>&1; then
    IN_PROJECT=true
    PROJECT_ROOT=$(git rev-parse --show-toplevel)
fi

# Determine location based on flag or auto-detection
LOCATION_TYPE=""
SKILLS_ROOT=""

case "$LOCATION_FLAG" in
    --personal)
        LOCATION_TYPE="personal"
        SKILLS_ROOT="$HOME/.claude/skills"
        notice "Creating personal skill in ~/.claude/skills/"
        ;;
    --project)
        if [ "$IN_PROJECT" = false ]; then
            echo "Error: --project flag used but no git repository detected."
            echo "You must be in a git repository to create a project skill."
            exit 1
        fi
        LOCATION_TYPE="project"
        SKILLS_ROOT="$PROJECT_ROOT/.claude/skills"
        notice "Creating project skill in $PROJECT_ROOT/.claude/skills/"
        ;;
    "")
        # Auto-detect based on git repository presence
        if [ "$IN_PROJECT" = true ]; then
            LOCATION_TYPE="project"
            SKILLS_ROOT="$PROJECT_ROOT/.claude/skills"
            notice "Auto-detected project context. Creating skill in .claude/skills/"
            notice "Use --personal flag to create in personal directory instead"
        else
            LOCATION_TYPE="personal"
            SKILLS_ROOT="$HOME/.claude/skills"
            notice "No project detected. Creating skill in ~/.claude/skills/"
        fi
        ;;
    *)
        echo "Error: Invalid flag '$LOCATION_FLAG'. Use --personal or --project"
        exit 1
        ;;
esac

echo ""

SKILL_DIR="$SKILLS_ROOT/$SKILL_NAME"

# Check if skill already exists
if [ -d "$SKILL_DIR" ]; then
    echo "Error: Skill directory already exists: $SKILL_DIR"
    exit 1
fi

# Create directory structure
mkdir -p "$SKILL_DIR/scripts"
info "Created $SKILL_DIR"
info "Created $SKILL_DIR/scripts"

# Create SKILL.md with template
cat > "$SKILL_DIR/SKILL.md" << 'EOF'
---
name: SKILL_NAME_PLACEHOLDER
description: DESCRIPTION_PLACEHOLDER
---

# TITLE_PLACEHOLDER

Brief overview of what this skill does (1-2 sentences).

## Quick Reference

**Key information users need immediately**

## Core Workflow

### Step 1: [Action Name]

What to do in this step.

```ruby
# Example code showing codebase conventions
# - Use keyword shorthand: method(param:)
# - Use bin/rails commands
```

### Step 2: [Next Action]

Continue the workflow.

**Validation:**
```bash
bundle exec rspec spec/path/to/spec
```

### Step 3: [Final Step]

Complete the workflow.

## Codebase-Specific Conventions

- Ruby keyword shorthand: `method(date:, people:)` not `method(date: date, people: people)`
- Commands: Always use `bin/rails` not `rails`
- [Other conventions specific to this skill]

## Examples

### Example 1: [Use Case]

```ruby
# Show concrete example from codebase
class Example
  def method(param:)
    # Implementation
  end
end
```

### Example 2: [Another Use Case]

```ruby
# Another concrete example
```

## Validation Checklist

- [ ] Item to verify
- [ ] Another check
- [ ] Final validation

## Common Issues

**Issue:** [Common problem users encounter]
**Solution:** [How to fix it]

## References

For detailed information:
```bash
cat REFERENCE.md  # Description of what's in reference file
```
EOF

# Replace placeholders
sed -i '' "s/SKILL_NAME_PLACEHOLDER/$SKILL_NAME/g" "$SKILL_DIR/SKILL.md"
sed -i '' "s/DESCRIPTION_PLACEHOLDER/$DESCRIPTION/g" "$SKILL_DIR/SKILL.md"

# Create title (capitalize first letter of each word)
TITLE=$(echo "$SKILL_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
sed -i '' "s/TITLE_PLACEHOLDER/$TITLE/g" "$SKILL_DIR/SKILL.md"

info "Created $SKILL_DIR/SKILL.md"

# Create README for scripts directory
cat > "$SKILL_DIR/scripts/README.md" << 'EOF'
# Scripts

Add utility scripts here for deterministic operations.

## Guidelines

- Scripts should solve problems, not punt to Claude
- Include error handling
- Document why constants have specific values
- Use forward slashes for paths (cross-platform)

## Example

```bash
#!/bin/bash
# validate_something.sh
# Validates some aspect of the skill
```
EOF

info "Created $SKILL_DIR/scripts/README.md"

# Determine validation script path based on skill location
if [ "$LOCATION_TYPE" = "personal" ]; then
    VALIDATE_SCRIPT="~/.claude/skills/creating-claude-skills/scripts/validate_skill.sh"
    RELATIVE_DIR="~/.claude/skills/$SKILL_NAME"
else
    # For project skills, use relative path from project root
    VALIDATE_SCRIPT="./.claude/skills/creating-claude-skills/scripts/validate_skill.sh"
    RELATIVE_DIR=".claude/skills/$SKILL_NAME"
fi

# Summary
echo ""
echo "=========================================="
echo "Skill scaffolded successfully!"
echo "=========================================="
echo ""
echo "Location: $SKILL_DIR"
echo "Type: $LOCATION_TYPE"
echo ""

if [ "$LOCATION_TYPE" = "project" ]; then
    echo "Note: This skill will be shared with your team via git."
    echo "      Don't forget to commit and push!"
    echo ""
fi

echo "Next steps:"
echo "  1. Edit $RELATIVE_DIR/SKILL.md"
echo "  2. Add concrete examples from your codebase"
echo "  3. Create reference files if needed (keep SKILL.md under 500 lines)"
echo "  4. Add utility scripts in scripts/ directory"
echo "  5. Validate: $VALIDATE_SCRIPT $SKILL_DIR"
echo ""
echo "Quick edit:"
echo "  code $SKILL_DIR/SKILL.md"
echo ""