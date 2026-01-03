---
description: Install an Atlas pack into your system
allowed-tools: [Read, Write, Edit, Bash]
---

# Install PAI Pack

Install a PAI pack to add new capabilities to your AI system.

## Pack to Install

**Pack name:** $ARGUMENTS

## Installation Process

Please follow these steps:

1. **Read the pack file:**
   @~/Developer/PAI/Packs/$1.md

2. **Parse the pack contents:**
   - Extract all code files with their paths
   - Extract settings.json configuration
   - Extract environment variables
   - Note all installation steps

3. **Install the pack:**
   - Create required directories
   - Write all code files to their locations
   - Merge settings.json entries (don't overwrite existing config)
   - List any manual steps needed (env vars, etc.)

4. **Verify installation:**
   - Follow the pack's verification steps
   - Confirm all files are in place
   - Report installation status

**Note:** This will modify your ~/.claude directory. Make sure you understand what the pack does before installing.
