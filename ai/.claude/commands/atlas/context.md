---
description: "Show current Atlas session context. Usage: /atlas:context"
---

# Current Session Context

Display the active PAI context for this session.

!echo "🎯 Atlas Session Context\n" && \
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" && \
echo "Identity:" && \
echo "  Assistant: $DA (Atlas)" && \
echo "  User: Ed\n" && \
echo "Environment:" && \
echo "  PAI_DIR: $PAI_DIR" && \
echo "  Source App: $PAI_SOURCE_APP" && \
echo "  Timezone: $TIME_ZONE\n" && \
echo "Active Session:" && \
echo "  Date: $(date '+%Y-%m-%d')" && \
echo "  Time: $(date '+%H:%M:%S %Z')" && \
echo "  Working Dir: $(pwd)\n" && \
echo "Stack Preferences:" && \
echo "  Language: TypeScript > Python" && \
echo "  Package Manager: bun (NEVER npm/yarn/pnpm)" && \
echo "  Runtime: Bun" && \
echo "  Markup: Markdown > HTML\n" && \
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
