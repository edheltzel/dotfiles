---
description: "List installed Atlas skills. Usage: /atlas:skills"
---

# Installed Skills

Display all installed Atlas skills with their descriptions.

!echo "📚 Atlas Skills System\n" && \
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" && \
(if [ -d ~/.claude/skills ]; then \
  for skill in ~/.claude/skills/*/SKILL.md; do \
    if [ -f "$skill" ]; then \
      skillname=$(basename $(dirname "$skill")); \
      description=$(grep -A1 "^description:" "$skill" | tail -1 | sed 's/description: *//'); \
      echo "  $skillname"; \
      if [ -n "$description" ]; then \
        echo "    $description"; \
      fi; \
      echo ""; \
    fi; \
  done; \
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"; \
else \
  echo "❌ No skills directory found\n"; \
fi)
