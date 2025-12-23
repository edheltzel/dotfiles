#!/bin/bash

# convert_command.sh - Convert a Claude Code slash command to OpenCode format
# Usage: ./convert_command.sh <source-file> [output-dir]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check for required argument
if [ $# -lt 1 ]; then
    echo -e "${RED}Error: Source file required${NC}"
    echo "Usage: $0 <source-file> [output-dir]"
    echo ""
    echo "Examples:"
    echo "  $0 .claude/commands/review.md"
    echo "  $0 ~/.claude/commands/commit.md .opencode/command/"
    exit 1
fi

SOURCE_FILE="$1"
OUTPUT_DIR="${2:-.opencode/command}"

# Check if source file exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo -e "${RED}Error: Source file not found: $SOURCE_FILE${NC}"
    exit 1
fi

# Get filename and create output directory
FILENAME=$(basename "$SOURCE_FILE")
mkdir -p "$OUTPUT_DIR"

OUTPUT_FILE="$OUTPUT_DIR/$FILENAME"

echo -e "${GREEN}Converting command:${NC} $SOURCE_FILE"
echo -e "${GREEN}Output to:${NC} $OUTPUT_FILE"
echo ""

# Create a temporary file for processing
TEMP_FILE=$(mktemp)

# Copy source to temp file
cp "$SOURCE_FILE" "$TEMP_FILE"

# Convert frontmatter fields
echo -e "${YELLOW}Converting frontmatter...${NC}"

# Remove argument-hint (not supported in OpenCode)
sed -i.bak '/^argument-hint:/d' "$TEMP_FILE"

# Remove disable-model-invocation (not supported in OpenCode)
sed -i.bak '/^disable-model-invocation:/d' "$TEMP_FILE"

# Convert allowed-tools to agent
# This is a simple heuristic - you may need to customize
if grep -q "^allowed-tools:" "$TEMP_FILE"; then
    echo -e "${YELLOW}  - Converting allowed-tools to agent${NC}"
    
    # Check if allowed-tools includes Write or Edit
    if grep "^allowed-tools:" "$TEMP_FILE" | grep -qi -e "Write" -e "Edit" -e "Bash"; then
        # Use build agent for modification commands
        sed -i.bak 's/^allowed-tools:.*/agent: build/' "$TEMP_FILE"
        echo -e "${GREEN}    Set agent: build${NC}"
    else
        # Use plan agent for read-only commands
        sed -i.bak 's/^allowed-tools:.*/agent: plan/' "$TEMP_FILE"
        echo -e "${GREEN}    Set agent: plan${NC}"
    fi
fi

# Convert model strings - add anthropic/ prefix if needed
if grep -q "^model:" "$TEMP_FILE"; then
    echo -e "${YELLOW}  - Converting model string${NC}"
    
    # Add anthropic/ prefix if not already present and not 'inherit'
    sed -i.bak '/^model:/s/\(model: \)\([^i][^ ]*\)/\1anthropic\/\2/' "$TEMP_FILE"
    
    # Show what was set
    MODEL=$(grep "^model:" "$TEMP_FILE" | cut -d' ' -f2-)
    echo -e "${GREEN}    Set model: $MODEL${NC}"
fi

# Extract and update description if argument-hint was present
if grep -q "^argument-hint:" "$SOURCE_FILE"; then
    HINT=$(grep "^argument-hint:" "$SOURCE_FILE" | cut -d':' -f2- | sed 's/^ *//')
    
    if grep -q "^description:" "$TEMP_FILE"; then
        echo -e "${YELLOW}  - Adding argument hint to description${NC}"
        sed -i.bak "s/^\(description:.*\)$/\1 $HINT/" "$TEMP_FILE"
        
        DESC=$(grep "^description:" "$TEMP_FILE" | cut -d':' -f2-)
        echo -e "${GREEN}    Updated description:$DESC${NC}"
    fi
fi

# Copy converted file to output
cp "$TEMP_FILE" "$OUTPUT_FILE"

# Clean up temp files
rm -f "$TEMP_FILE" "$TEMP_FILE.bak"

echo ""
echo -e "${GREEN}✓ Conversion complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Review the converted file: $OUTPUT_FILE"
echo "  2. Verify frontmatter is correct"
echo "  3. Test the command with: /${FILENAME%.md}"
echo "  4. Adjust agent or model if needed"
echo ""
echo -e "${YELLOW}Note: Command content (arguments, shell commands, file refs) preserved unchanged${NC}"
