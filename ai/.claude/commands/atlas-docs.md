---
description: Quick access to Atlas documentation
---

# Atlas Documentation

Access Atlas system documentation and resources.

## Available Documentation

**Core Documentation:**
- 📖 README: `~/Developer/PAI/README.md`
- 📦 Packs System: `~/Developer/PAI/PACKS.md`
- 🏗️ Platform: `~/Developer/PAI/PLATFORM.md`
- 🔒 Security: `~/Developer/PAI/SECURITY.md`

**Tools & Templates:**
- 🛠️ Check Atlas State: `~/Developer/PAI/Tools/CheckPAIState.md`
- 📋 Pack Template: `~/Developer/PAI/Tools/PAIPackTemplate.md`
- 🎁 Bundle Template: `~/Developer/PAI/Tools/PAIBundleTemplate.md`

**Quick Actions:**
- View all packs: `/atlas-packs`
- System status: `/atlas-status`
- Health check: `/atlas-check`

## Read Documentation

To read a specific doc, use: `$ARGUMENTS`

!if [ -n "$1" ]; then \
  case "$1" in \
    readme|README) cat ~/Developer/PAI/README.md ;; \
    packs|PACKS) cat ~/Developer/PAI/PACKS.md ;; \
    platform|PLATFORM) cat ~/Developer/PAI/PLATFORM.md ;; \
    security|SECURITY) cat ~/Developer/PAI/SECURITY.md ;; \
    *) echo "Unknown doc: $1. Use readme, packs, platform, or security" ;; \
  esac; \
else \
  echo "Specify a doc to read: readme, packs, platform, or security"; \
fi
