---
description: "Show Atlas system status and health. Usage: /atlas:status"
---

# Atlas System Status

Display the current status of your Personal AI Infrastructure.

!echo "🤖 Atlas System Status\n" && \
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" && \
echo "📍 PAI Directory: $PAI_DIR" && \
echo "🎯 Assistant: $DA" && \
echo "🌍 Source App: $PAI_SOURCE_APP" && \
echo "🕐 Timezone: $TIME_ZONE\n" && \
echo "Voice Server:" && \
(lsof -ti:3456 > /dev/null 2>&1 && echo "  ✅ Running on port 3456" || echo "  ❌ Not running") && \
echo "\nActive Skills:" && \
(ls -1 ~/.claude/skills/*/SKILL.md 2>/dev/null | wc -l | xargs echo "  📚 Skills loaded:" || echo "  ❌ No skills directory") && \
echo "\nHooks:" && \
(cat ~/.claude/settings.json 2>/dev/null | grep -c "hooks" | xargs echo "  🪝 Hook events configured:" || echo "  ❌ No hooks configured") && \
echo "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
