---
description: List all available Atlas voice personalities
---

# Available Voice Personalities

Display all configured voice personalities with their characteristics.

!cat ~/.claude/voice-personalities.json | bun run -e "const data = JSON.parse(await Bun.stdin.text()); console.log('\n🎙️  Atlas Voice Personalities\n'); Object.entries(data.voices).forEach(([key, voice]) => console.log(\`  \${key.padEnd(12)} - \${voice.description}\`)); console.log('\nUse /atlas-voice <name> to switch personalities\n');"
