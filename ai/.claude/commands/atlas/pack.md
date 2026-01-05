---
description: "Manage Atlas packs. Usage: /atlas:pack [list|install <name>]"
allowed-tools: [Read, Write, Edit, Bash]
---

# Atlas Pack Manager

Manage PAI packs for your Atlas system.

## Usage

- `/atlas:pack` - List all available and installed packs
- `/atlas:pack list` - Same as above
- `/atlas:pack install <name>` - Install a specific pack

## Arguments: $ARGUMENTS

---

**If no arguments or "list":** Display the pack list with installation status.

**If "install <pack-name>":** Install the specified pack by:
1. Reading the pack file from `~/Developer/ai-dev/PAI/Packs/<pack-name>.md`
2. Parsing and extracting all code files, settings, and env vars
3. Creating required directories and writing files
4. Merging settings.json entries (don't overwrite existing)
5. Verifying installation and reporting status

---

## Pack List

!echo "📦 Atlas Pack System\n" && \
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" && \
(if [ -d ~/Developer/ai-dev/PAI/Packs ]; then \
  installed=$(bun run ~/.claude/tools/detect-installed-packs.ts 2>/dev/null || echo ""); \
  cd ~/Developer/ai-dev/PAI/Packs && \
  echo "Feature Packs:" && \
  for pack in $(ls -1 kai-*-system.md 2>/dev/null | sed 's/.md$//'); do \
    if echo "$installed" | grep -q "^$pack$"; then \
      echo "  ✅ $pack"; \
    else \
      echo "     $pack"; \
    fi; \
  done && \
  echo "\nSkill Packs:" && \
  for pack in $(ls -1 kai-*-skill.md 2>/dev/null | sed 's/.md$//'); do \
    if echo "$installed" | grep -q "^$pack$"; then \
      echo "  ✅ $pack"; \
    else \
      echo "     $pack"; \
    fi; \
  done && \
  echo "\nCore Packs:" && \
  for pack in $(ls -1 kai-core-*.md 2>/dev/null | sed 's/.md$//'); do \
    if echo "$installed" | grep -q "^$pack$"; then \
      echo "  ✅ $pack"; \
    else \
      echo "     $pack"; \
    fi; \
  done && \
  echo "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" && \
  echo "✅ = Installed" && \
  echo "\nUse: /atlas:pack install <pack-name>" && \
  echo "Docs: ~/Developer/ai-dev/PAI/PACKS.md\n"; \
else \
  echo "❌ PAI repository not found at ~/Developer/ai-dev/PAI\n"; \
fi)
