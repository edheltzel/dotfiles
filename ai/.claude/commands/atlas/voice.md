---
description: "Switch Atlas voice personality. Usage: /atlas:voice <personality>"
---

# Voice Personality Switcher

Switch to a different voice personality based on the task at hand.

**Available voices:**
- **default** - Professional, expressive (default)
- **intern** - Enthusiastic, chaotic energy (176 IQ genius)
- **engineer** - Wise leader, stable (Fortune 10 principal)
- **architect** - Wise leader, deliberate (PhD-level system designer)
- **researcher** - Analyst, measured (comprehensive research)
- **designer** - Critic, measured (exacting UX/UI)
- **artist** - Enthusiast, chaotic (visual content creator)
- **pentester** - Enthusiast, chaotic (offensive security)
- **writer** - Professional, expressive (content creation)

## Usage

Switch to personality: `$ARGUMENTS`

!bun run ~/.claude/hooks/lib/voice-controller.ts --personality $1

---

**Note:** Voice will remain active for this session. Use `/atlas:voice pai` to return to default.
