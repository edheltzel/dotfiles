#!/bin/bash
# Convert Claude Code Subagent to OpenCode Agent format
# Usage: ./convert_subagent.sh <source-file> [output-dir]

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check arguments
if [ $# -lt 1 ]; then
    echo -e "${RED}Error: Missing source file argument${NC}"
    echo "Usage: $0 <source-file> [output-dir]"
    echo ""
    echo "Examples:"
    echo "  $0 ~/.claude/agents/code-reviewer.md"
    echo "  $0 ./.claude/agents/debugger.md ./.opencode/agent/"
    exit 1
fi

SOURCE_FILE="$1"
OUTPUT_DIR="${2:-./.opencode/agent}"

# Verify source file exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo -e "${RED}Error: Source file not found: $SOURCE_FILE${NC}"
    exit 1
fi

# Extract agent name from filename
AGENT_NAME=$(basename "$SOURCE_FILE" .md)
OUTPUT_FILE="$OUTPUT_DIR/$AGENT_NAME.md"

echo -e "${GREEN}Converting Claude Code Subagent to OpenCode Agent${NC}"
echo "Source: $SOURCE_FILE"
echo "Target: $OUTPUT_FILE"
echo ""

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Parse frontmatter and body
IN_FRONTMATTER=false
FRONTMATTER=""
BODY=""
LINE_NUM=0

while IFS= read -r line; do
    LINE_NUM=$((LINE_NUM + 1))
    
    if [ $LINE_NUM -eq 1 ] && [ "$line" = "---" ]; then
        IN_FRONTMATTER=true
        continue
    fi
    
    if $IN_FRONTMATTER && [ "$line" = "---" ]; then
        IN_FRONTMATTER=false
        continue
    fi
    
    if $IN_FRONTMATTER; then
        FRONTMATTER="$FRONTMATTER$line"$'\n'
    else
        BODY="$BODY$line"$'\n'
    fi
done < "$SOURCE_FILE"

# Extract fields from frontmatter
DESCRIPTION=$(echo "$FRONTMATTER" | grep "^description:" | sed 's/^description: *//')
TOOLS=$(echo "$FRONTMATTER" | grep "^tools:" | sed 's/^tools: *//')
MODEL=$(echo "$FRONTMATTER" | grep "^model:" | sed 's/^model: *//')

# Validate required fields
if [ -z "$DESCRIPTION" ]; then
    echo -e "${RED}Error: Missing required 'description' field in source file${NC}"
    exit 1
fi

# Convert tools from comma-separated to YAML object
TOOLS_YAML=""
if [ -n "$TOOLS" ]; then
    echo -e "${YELLOW}Converting tools format...${NC}"
    # Split by comma and convert to YAML
    IFS=',' read -ra TOOL_ARRAY <<< "$TOOLS"
    TOOLS_YAML="tools:"
    for tool in "${TOOL_ARRAY[@]}"; do
        # Trim whitespace and convert to lowercase
        tool=$(echo "$tool" | xargs | tr '[:upper:]' '[:lower:]')
        TOOLS_YAML="$TOOLS_YAML"$'\n'"  $tool: true"
    done
    
    # Add common tools that should be explicitly disabled
    if [[ ! "$TOOLS" =~ [Ww]rite ]]; then
        TOOLS_YAML="$TOOLS_YAML"$'\n'"  write: false"
    fi
    if [[ ! "$TOOLS" =~ [Ee]dit ]]; then
        TOOLS_YAML="$TOOLS_YAML"$'\n'"  edit: false"
    fi
fi

# Build new frontmatter
NEW_FRONTMATTER="---"$'\n'
NEW_FRONTMATTER="${NEW_FRONTMATTER}description: $DESCRIPTION"$'\n'
NEW_FRONTMATTER="${NEW_FRONTMATTER}mode: subagent"$'\n'

if [ -n "$MODEL" ]; then
    NEW_FRONTMATTER="${NEW_FRONTMATTER}model: $MODEL"$'\n'
fi

# Add default temperature for consistency
NEW_FRONTMATTER="${NEW_FRONTMATTER}temperature: 0.2"$'\n'

if [ -n "$TOOLS_YAML" ]; then
    NEW_FRONTMATTER="${NEW_FRONTMATTER}$TOOLS_YAML"$'\n'
fi

# Add permission hints if tools include write/edit/bash
if [[ "$TOOLS" =~ [Ee]dit ]] || [[ "$TOOLS" =~ [Ww]rite ]] || [[ "$TOOLS" =~ [Bb]ash ]]; then
    NEW_FRONTMATTER="${NEW_FRONTMATTER}permission:"$'\n'
    
    if [[ "$TOOLS" =~ [Ee]dit ]]; then
        NEW_FRONTMATTER="${NEW_FRONTMATTER}  edit: ask"$'\n'
    fi
    
    if [[ "$TOOLS" =~ [Bb]ash ]]; then
        NEW_FRONTMATTER="${NEW_FRONTMATTER}  bash: ask"$'\n'
    fi
fi

NEW_FRONTMATTER="${NEW_FRONTMATTER}---"$'\n'

# Write output file
echo "$NEW_FRONTMATTER$BODY" > "$OUTPUT_FILE"

echo -e "${GREEN}✓ Conversion complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Review the converted file: $OUTPUT_FILE"
echo "  2. Adjust temperature if needed (current: 0.2)"
echo "  3. Refine permission settings based on your needs"
echo "  4. Test the agent with: @$AGENT_NAME"
echo ""
echo -e "${YELLOW}Note: Please review the conversion manually to ensure all settings are correct.${NC}"
