---
description: List available Atlas packs for installation
---

# Available PAI Packs

Browse the PAI Pack System - modular, self-contained functionality that upgrades your AI system.

## Available Packs

!echo "📦 PAI Pack System\n" && \
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" && \
(if [ -d ~/Developer/PAI/Packs ]; then \
  cd ~/Developer/PAI/Packs && \
  echo "Feature Packs:" && \
  ls -1 kai-*-system.md 2>/dev/null | sed 's/.md$//' | sed 's/^/  • /' && \
  echo "\nSkill Packs:" && \
  ls -1 kai-*-skill.md 2>/dev/null | sed 's/.md$//' | sed 's/^/  • /' && \
  echo "\nCore Packs:" && \
  ls -1 kai-core-*.md 2>/dev/null | sed 's/.md$//' | sed 's/^/  • /' && \
  echo "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" && \
  echo "\nUse /atlas-install <pack-name> to install a pack" && \
  echo "View docs: ~/Developer/PAI/PACKS.md\n"; \
else \
  echo "❌ PAI repository not found at ~/Developer/PAI\n"; \
fi)
