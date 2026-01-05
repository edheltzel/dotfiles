---
description: "Show active Atlas hooks configuration. Usage: /atlas:hooks"
---

# Active Hooks

Display all configured hooks and their event listeners.

!echo "🪝 PAI Hooks Configuration\n" && \
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" && \
cat ~/.claude/settings.json | bun run -e "const data = JSON.parse(await Bun.stdin.text()); const hooks = data.hooks || {}; Object.entries(hooks).forEach(([event, configs]) => { console.log(\`\n\${event}:\`); configs.forEach(config => { config.hooks?.forEach(hook => { const cmd = hook.command?.split('/').pop() || 'unknown'; console.log(\`  • \${cmd}\`); }); }); }); console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');"
