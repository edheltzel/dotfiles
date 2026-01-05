---
description: "Quick access to Atlas documentation. Usage: /atlas:docs [readme|packs|platform|security]"
---

# Atlas Documentation

Access Atlas system documentation and resources.

## Available Documentation

**Core Documentation:**
- 📖 README: `~/Developer/ai-dev/PAI/README.md`
- 📦 Packs System: `~/Developer/ai-dev/PAI/PACKS.md`
- 🏗️ Platform: `~/Developer/ai-dev/PAI/PLATFORM.md`
- 🔒 Security: `~/Developer/ai-dev/PAI/SECURITY.md`

**Tools & Templates:**
- 🛠️ Check Atlas State: `~/Developer/ai-dev/PAI/Tools/CheckPAIState.md`
- 📋 Pack Template: `~/Developer/ai-dev/PAI/Tools/PAIPackTemplate.md`
- 🎁 Bundle Template: `~/Developer/ai-dev/PAI/Tools/PAIBundleTemplate.md`

**Quick Actions:**
- View all packs: `/atlas:packs`
- System status: `/atlas:status`
- Health check: `/atlas:check`

## Read Documentation

To read a specific doc, use: `$ARGUMENTS`

!if [ -n "$1" ]; then \
  case "$1" in \
    readme|README) cat ~/Developer/ai-dev/PAI/README.md ;; \
    packs|PACKS) cat ~/Developer/ai-dev/PAI/PACKS.md ;; \
    platform|PLATFORM) cat ~/Developer/ai-dev/PAI/PLATFORM.md ;; \
    security|SECURITY) cat ~/Developer/ai-dev/PAI/SECURITY.md ;; \
    *) echo "Unknown doc: $1. Use readme, packs, platform, or security" ;; \
  esac; \
else \
  echo "Specify a doc to read: readme, packs, platform, or security"; \
fi
