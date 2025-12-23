# Conversion Scripts

This directory contains helper scripts for converting Claude Code slash commands to OpenCode format.

## convert_command.sh

Converts a single Claude Code slash command file to OpenCode format.

### Usage

```bash
./convert_command.sh <source-file> [output-dir]
```

### Arguments

- `<source-file>` - Path to Claude Code command file (required)
- `[output-dir]` - Output directory (optional, defaults to `.opencode/command`)

### Examples

**Convert a project command:**
```bash
./convert_command.sh .claude/commands/review.md
```

**Convert a user command:**
```bash
./convert_command.sh ~/.claude/commands/commit.md ~/.config/opencode/command/
```

**Convert with custom output directory:**
```bash
./convert_command.sh .claude/commands/test.md .opencode/command/
```

### What it does

The script automatically:
1. Copies the source file to the output directory
2. Removes `argument-hint` field (not supported in OpenCode)
3. Removes `disable-model-invocation` field (not supported)
4. Converts `allowed-tools` to appropriate `agent`:
   - `agent: build` if command includes Write, Edit, or Bash tools
   - `agent: plan` for read-only commands
5. Adds `anthropic/` prefix to model strings (if needed)
6. Appends argument hints to description
7. Preserves all command content (arguments, shell commands, file references)

### What it preserves

The script keeps these unchanged:
- Command content/template
- Argument placeholders (`$ARGUMENTS`, `$1`, `$2`, etc.)
- Shell commands (``` !`command` ```)
- File references (`@filename`)
- Description text (with argument hint appended)

### Manual review needed

After conversion, review and adjust:
- **Agent selection** - Script uses heuristics, you may need a different agent
- **Model string** - Verify provider prefix is correct
- **Permissions** - Ensure agent has necessary tool permissions
- **Subtask flag** - Add `subtask: true` if needed

### Make it executable

```bash
chmod +x convert_command.sh
```

## Batch conversion

To convert multiple commands at once:

```bash
# Convert all project commands
for file in .claude/commands/*.md; do
    ./convert_command.sh "$file"
done

# Convert all user commands  
for file in ~/.claude/commands/*.md; do
    ./convert_command.sh "$file" ~/.config/opencode/command/
done
```

## Testing

After conversion, test each command:

1. Open OpenCode TUI
2. Type `/command-name`
3. Verify it works as expected
4. Adjust agent, model, or subtask flag if needed

## Troubleshooting

**Script fails with "command not found":**
- Make sure script is executable: `chmod +x convert_command.sh`
- Run from the scripts directory or use full path

**Conversion looks wrong:**
- Review the output file manually
- Adjust frontmatter as needed
- Script uses heuristics that may need customization for your commands

**Agent selection is incorrect:**
- Edit the converted file
- Change `agent:` field to appropriate agent
- Or add `subtask: true` if needed

## See also

- [SKILL.md](../SKILL.md) - Complete conversion guide
- [QUICK_REFERENCE.md](../QUICK_REFERENCE.md) - Quick reference for manual conversion
- [EXAMPLES.md](../EXAMPLES.md) - Detailed conversion examples
