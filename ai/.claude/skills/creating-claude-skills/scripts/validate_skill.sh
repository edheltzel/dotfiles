#!/bin/bash
# validate_skill.sh - Validate Claude Code skill structure and format
#
# Usage: validate_skill.sh <path-to-skill-directory>
#
# Validates:
# - SKILL.md exists
# - Frontmatter is valid YAML with required fields
# - Name follows conventions (lowercase, hyphens, max 64 chars, gerund form)
# - Description is non-empty and under 1024 chars
# - SKILL.md is under 500 lines
# - No reserved words in name/description

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counter for errors/warnings
ERRORS=0
WARNINGS=0

error() {
    echo -e "${RED}✗ ERROR: $1${NC}"
    ERRORS=$((ERRORS + 1))
}

warning() {
    echo -e "${YELLOW}⚠ WARNING: $1${NC}"
    WARNINGS=$((WARNINGS + 1))
}

success() {
    echo -e "${GREEN}✓ $1${NC}"
}

info() {
    echo "ℹ $1"
}

# Check if directory provided
if [ -z "$1" ]; then
    error "Usage: validate_skill.sh <path-to-skill-directory>"
    exit 1
fi

SKILL_DIR="$1"
SKILL_FILE="$SKILL_DIR/SKILL.md"

echo "Validating skill in: $SKILL_DIR"
echo "----------------------------------------"

# Check if SKILL.md exists
if [ ! -f "$SKILL_FILE" ]; then
    error "SKILL.md not found in $SKILL_DIR"
    exit 1
fi
success "SKILL.md exists"

# Check file is not empty
if [ ! -s "$SKILL_FILE" ]; then
    error "SKILL.md is empty"
    exit 1
fi
success "SKILL.md is not empty"

# Extract frontmatter (between first two --- lines)
FRONTMATTER=$(awk '/^---$/{if(++count==2) exit; if(count==1) next} count==1' "$SKILL_FILE")

if [ -z "$FRONTMATTER" ]; then
    error "No valid YAML frontmatter found (must be between --- delimiters)"
    exit 1
fi
success "YAML frontmatter found"

# Extract name from frontmatter
NAME=$(echo "$FRONTMATTER" | grep "^name:" | sed 's/^name: *//' | tr -d '"' | tr -d "'")

if [ -z "$NAME" ]; then
    error "No 'name' field in frontmatter"
else
    success "Name field exists: $NAME"

    # Validate name length
    NAME_LENGTH=${#NAME}
    if [ $NAME_LENGTH -gt 64 ]; then
        error "Name exceeds 64 characters (found $NAME_LENGTH)"
    else
        success "Name length OK ($NAME_LENGTH/64 chars)"
    fi

    # Validate name format (lowercase, letters, numbers, hyphens only)
    if [[ ! "$NAME" =~ ^[a-z0-9-]+$ ]]; then
        error "Name must be lowercase letters, numbers, and hyphens only (found: $NAME)"
    else
        success "Name format is valid"
    fi

    # Check for gerund form (ends in -ing)
    if [[ ! "$NAME" =~ -[a-z]*ing$ ]] && [[ ! "$NAME" =~ ^[a-z]*ing- ]]; then
        warning "Name should use gerund form (verb + -ing): '$NAME' doesn't appear to follow this convention"
    else
        success "Name appears to use gerund form"
    fi

    # Check for reserved words (warn only for skills about Claude itself)
    if [[ "$NAME" =~ anthropic|Anthropic ]]; then
        warning "Name contains 'anthropic' - ensure this is intentional"
    elif [[ "$NAME" =~ ^claude$|^anthropic$ ]]; then
        error "Name cannot be exactly 'claude' or 'anthropic'"
    else
        success "Name has no problematic reserved words"
    fi
fi

# Extract description from frontmatter
DESCRIPTION=$(echo "$FRONTMATTER" | grep "^description:" | sed 's/^description: *//')

if [ -z "$DESCRIPTION" ]; then
    error "No 'description' field in frontmatter"
else
    success "Description field exists"

    # Validate description length
    DESC_LENGTH=${#DESCRIPTION}
    if [ $DESC_LENGTH -gt 1024 ]; then
        error "Description exceeds 1024 characters (found $DESC_LENGTH)"
    else
        success "Description length OK ($DESC_LENGTH/1024 chars)"
    fi

    # Check for empty description
    if [ $DESC_LENGTH -lt 10 ]; then
        warning "Description is very short ($DESC_LENGTH chars) - should explain what and when"
    fi

    # Check for XML tags
    if [[ "$DESCRIPTION" =~ \<[^\>]+\> ]]; then
        error "Description contains XML tags"
    else
        success "Description has no XML tags"
    fi

    # Check for reserved words (warn only, as some skills about Claude itself are valid)
    if [[ "$DESCRIPTION" =~ anthropic|Anthropic ]]; then
        warning "Description contains 'anthropic' - ensure this is intentional"
    fi

    # Check if description explains WHEN to use
    if [[ ! "$DESCRIPTION" =~ [Uu]se\ when|[Ww]hen\ you|[Ff]or\ when ]]; then
        warning "Description should include 'Use when' or 'When you' to clarify usage"
    fi
fi

# Count lines in SKILL.md (excluding frontmatter)
BODY_LINES=$(awk '/^---$/{count++; next} count>=2' "$SKILL_FILE" | wc -l | tr -d ' ')

if [ "$BODY_LINES" -gt 500 ]; then
    error "SKILL.md body exceeds 500 lines (found $BODY_LINES) - consider moving content to reference files"
else
    success "SKILL.md body length OK ($BODY_LINES/500 lines)"
fi

# Check for common anti-patterns in content
BODY=$(awk '/^---$/{count++; next} count>=2' "$SKILL_FILE")

# Check for deeply nested references (paths with multiple slashes)
if echo "$BODY" | grep -qE 'cat [^/]+/[^/]+/[^/]+'; then
    warning "Found potentially deeply nested file references - keep references one level deep"
fi

# Check for absolute paths in cat commands (should be relative)
if echo "$BODY" | grep -qE 'cat /|cat ~'; then
    warning "Found absolute paths in cat commands - use relative paths from skill directory"
fi

# Check for Windows-style paths
if echo "$BODY" | grep -q '\\'; then
    warning "Found backslashes - use forward slashes for cross-platform compatibility"
fi

# Check if SKILL.md has examples section
if ! echo "$BODY" | grep -qi "^## Examples\|^## Example"; then
    warning "No Examples section found - consider adding concrete examples"
fi

# Summary
echo "----------------------------------------"
echo "Validation Summary:"
echo "  Errors: $ERRORS"
echo "  Warnings: $WARNINGS"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    success "All checks passed! Skill is valid."
    exit 0
elif [ $ERRORS -eq 0 ]; then
    info "No errors found, but $WARNINGS warning(s) to consider"
    exit 0
else
    error "Validation failed with $ERRORS error(s)"
    exit 1
fi