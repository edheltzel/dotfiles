# Atlas Voice System

> Text-to-speech notifications with personality-driven voice delivery

## Overview

The Atlas voice system provides spoken notifications when Claude Code completes tasks. It supports multiple TTS providers (ElevenLabs, Google Cloud TTS) and allows switching between different voice personalities.

**Two voice naming systems exist in the Atlas infrastructure:**

| System                 | Source                           | Voice Names                          |
| ---------------------- | -------------------------------- | ------------------------------------ |
| **Custom Hooks**       | `hooks/lib/prosody-enhancer.ts`  | pai, intern, engineer, architect, etc. |
| **Atlas Agents Skill** | `skills/Agents/Data/Traits.yaml` | Authoritative, Intense, Warm, etc.   |

Both systems resolve voice IDs from `ELEVENLABS_VOICE_${NAME}` environment variables in `~/.claude/.env`.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     Claude Code Session                          │
│                                                                   │
│  Task completes → Hook fires → Extract message → Send to server  │
└──────────────────────────────┬────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Hooks (bun scripts)                            │
├─────────────────────────────────────────────────────────────────┤
│  stop-hook-voice.ts         → Main agent completion              │
│  subagent-stop-hook-voice.ts → Subagent completion               │
│                                                                   │
│  lib/prosody-enhancer.ts    → Emotional markers, voice selection │
│  lib/voice-controller.ts    → CLI for /atlas-voice command       │
└──────────────────────────────┬────────────────────────────────────┘
                               │ HTTP POST /notify
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                Voice Server (port 8888)                          │
│                ~/.claude/voice/server.ts                         │
├─────────────────────────────────────────────────────────────────┤
│  • Receives notification requests with voice_id                  │
│  • Calls TTS API (ElevenLabs or Google)                         │
│  • Generates audio from text                                     │
│  • Plays audio (afplay on macOS, mpg123/mpv on Linux)           │
│  • Shows desktop notification                                    │
└─────────────────────────────────────────────────────────────────┘
```

## Voice Personalities

### Custom Hook Voices

Used by `stop-hook-voice.ts` and `subagent-stop-hook-voice.ts` when agents complete tasks or output `[AGENT:xxx]` tags.

| Voice Name   | Archetype    | Energy     | Description                       |
| ------------ | ------------ | ---------- | --------------------------------- |
| `pai`        | professional | expressive | Primary AI assistant (default)    |
| `intern`     | enthusiast   | chaotic    | Eager 176 IQ genius               |
| `engineer`   | wise-leader  | stable     | Fortune 10 principal engineer     |
| `architect`  | wise-leader  | stable     | PhD-level system designer         |
| `researcher` | analyst      | measured   | Comprehensive research specialist |
| `designer`   | critic       | measured   | Exacting UX/UI specialist         |
| `artist`     | enthusiast   | chaotic    | Visual content creator            |
| `pentester`  | enthusiast   | chaotic    | Offensive security specialist     |
| `writer`     | professional | expressive | Content creation specialist       |

### Atlas Agents Skill Voices

Used by `AgentFactory.ts` when composing dynamic agents from traits in `skills/Agents/Data/Traits.yaml`.

| Voice Name      | Characteristics                       | Use Case                  |
| --------------- | ------------------------------------- | ------------------------- |
| `Authoritative` | authoritative, measured, intellectual | Serious analysis          |
| `Professional`  | professional, balanced, neutral       | General use               |
| `Warm`          | warm, friendly, engaging              | Supportive interactions   |
| `Gentle`        | warm, calm, gentle                    | Empathetic guidance       |
| `Energetic`     | energetic, excited, dynamic           | Enthusiastic delivery     |
| `Dynamic`       | energetic, fast, charismatic          | Exciting content          |
| `Academic`      | intellectual, warm, academic          | Research and analysis     |
| `Sophisticated` | intellectual, sophisticated, smooth   | Nuanced discussion        |
| `Intense`       | edgy, gravelly, intense               | Adversarial/security work |
| `Gritty`        | edgy, raspy, authentic                | Skeptical analysis        |

### Voice Mapping (Atlas Agents to Custom Hook Voices)

Map Atlas Agents voices to your existing custom voices (same ElevenLabs voice ID, different names):

| Atlas Voice     | Maps To    | Rationale                 |
| --------------- | ---------- | ------------------------- |
| `AUTHORITATIVE` | engineer   | Wise, measured authority  |
| `PROFESSIONAL`  | engineer   | Balanced professional     |
| `WARM`          | designer   | Friendly, engaging        |
| `GENTLE`        | designer   | Calm, empathetic          |
| `ENERGETIC`     | intern     | High energy, enthusiastic |
| `DYNAMIC`       | artist     | Fast-paced, creative      |
| `ACADEMIC`      | researcher | Intellectual analysis     |
| `SOPHISTICATED` | architect  | Nuanced, deliberate       |
| `INTENSE`       | pentester  | Edgy, adversarial         |
| `GRITTY`        | pentester  | Skeptical, authentic      |

## Configuration

### 1. Environment Variables (`~/.claude/.env`)

```bash
# ============================================
# TTS PROVIDER CONFIGURATION
# ============================================
TTS_PROVIDER=elevenlabs  # or google

# ============================================
# ELEVENLABS CONFIGURATION
# ============================================
ELEVENLABS_API_KEY=your_api_key_here
ELEVENLABS_VOICE_DEFAULT=voice_id_fallback

# ============================================
# CUSTOM HOOK VOICES
# ============================================
ELEVENLABS_VOICE_PAI=<voice_id_1>
ELEVENLABS_VOICE_INTERN=<voice_id_2>
ELEVENLABS_VOICE_ENGINEER=<voice_id_3>
ELEVENLABS_VOICE_ARCHITECT=<voice_id_4>
ELEVENLABS_VOICE_RESEARCHER=<voice_id_5>
ELEVENLABS_VOICE_DESIGNER=<voice_id_6>
ELEVENLABS_VOICE_ARTIST=<voice_id_7>
ELEVENLABS_VOICE_PENTESTER=<voice_id_8>
ELEVENLABS_VOICE_WRITER=<voice_id_9>

# ============================================
# ATLAS AGENTS SKILL VOICES
# Point these to your existing voices
# ============================================
ELEVENLABS_VOICE_AUTHORITATIVE=<voice_id_3>   # same as ENGINEER
ELEVENLABS_VOICE_PROFESSIONAL=<voice_id_3>    # same as ENGINEER
ELEVENLABS_VOICE_WARM=<voice_id_6>            # same as DESIGNER
ELEVENLABS_VOICE_GENTLE=<voice_id_6>          # same as DESIGNER
ELEVENLABS_VOICE_ENERGETIC=<voice_id_2>       # same as INTERN
ELEVENLABS_VOICE_DYNAMIC=<voice_id_7>         # same as ARTIST
ELEVENLABS_VOICE_ACADEMIC=<voice_id_5>        # same as RESEARCHER
ELEVENLABS_VOICE_SOPHISTICATED=<voice_id_4>   # same as ARCHITECT
ELEVENLABS_VOICE_INTENSE=<voice_id_8>         # same as PENTESTER
ELEVENLABS_VOICE_GRITTY=<voice_id_8>          # same as PENTESTER

# ============================================
# GOOGLE CLOUD TTS (alternative provider)
# ============================================
GOOGLE_API_KEY=your_google_api_key
GOOGLE_TTS_VOICE=en-US-Neural2-J
```

### 2. Voice Personalities (`~/.claude/voice-personalities.json`)

Defines voice characteristics for each personality:

```json
{
  "default_volume": 0.8,
  "voices": {
    "pai": {
      "voice_id": "${ELEVENLABS_VOICE_PAI}",
      "stability": 0.38,
      "similarity_boost": 0.75,
      "description": "Professional, expressive - primary AI assistant"
    },
    "intern": {
      "voice_id": "${ELEVENLABS_VOICE_INTERN}",
      "stability": 0.30,
      "similarity_boost": 0.85,
      "description": "Enthusiastic, chaotic energy - eager 176 IQ genius"
    }
  }
}
```

**Parameters:**
- `stability` (0.0-1.0): Lower = more expressive/chaotic, Higher = more stable
- `similarity_boost` (0.0-1.0): How close to the original voice clone

### 3. Prosody Settings

The prosody enhancer adds emotional markers based on content:

| Pattern | Emotion | Marker |
|---------|---------|--------|
| "breakthrough", "eureka" | excited | `[excited]` |
| "finally", "we did it" | celebration | `[celebration]` |
| "I see", "that's why" | insight | `[insight]` |
| "completed", "fixed" | success | `[success]` |
| "bug", "error" | debugging | `[debugging]` |
| "urgent", "critical" | urgent | `[urgent]` |

## Commands

### Switch Voice Personality

```bash
/atlas-voice <personality>
```

**Available personalities:**
- `pai` - Professional, expressive (default)
- `intern` - Enthusiastic, chaotic energy
- `engineer` - Wise leader, stable
- `architect` - Deliberate, PhD-level
- `researcher` - Analyst, measured
- `designer` - Critic, exacting
- `artist` - Enthusiast, creative
- `pentester` - Enthusiast, chaotic
- `writer` - Professional, expressive

**Example:**
```bash
/atlas-voice intern    # Switch to intern voice
/atlas-voice pai       # Back to default
```

### List All Personalities

```bash
/atlas-voices
```

## How It Works

### Custom Hooks Flow

1. **Task completes** - SessionStop or SubagentStop hook fires
2. **Hook reads transcript** - Extracts the completion message
3. **Prosody enhancement** - Adds emotional markers based on content (e.g., `[success]`)
4. **Personality check** - Reads `~/.claude/state/current-personality.txt`
5. **Voice ID lookup** - Loads `~/.claude/.env`, gets `ELEVENLABS_VOICE_<PERSONALITY>`
6. **POST to server** - `{ title, message, voice_id, voice_enabled: true }`
7. **Server generates speech** - Calls ElevenLabs or Google TTS API
8. **Audio plays** - Via system audio player

**Example with [AGENT:xxx] tags:**
1. Subagent outputs: `COMPLETED: [AGENT:engineer] Task done`
2. `subagent-stop-hook-voice.ts` extracts `engineer`
3. `getVoiceId("engineer")` reads `ELEVENLABS_VOICE_ENGINEER`
4. Voice server speaks with that voice

### Atlas Agents Skill Flow

1. `AgentFactory.ts` composes agent with traits: `security, skeptical, adversarial`
2. Traits map to voice: `Intense`
3. Template includes voice ID from `ELEVENLABS_VOICE_INTENSE`
4. Agent prompt includes voice assignment

### Personality Switching Flow

1. User runs `/atlas-voice intern`
2. Command executes: `bun run ~/.claude/hooks/lib/voice-controller.ts --personality intern`
3. Controller writes "intern" to `~/.claude/state/current-personality.txt`
4. When next task completes, hook fires
5. `prosody-enhancer.ts` calls `getVoiceId('pai')`
6. `getVoiceId()` reads state file, sees "intern"
7. Loads `.env`, returns `ELEVENLABS_VOICE_INTERN` value
8. Voice server uses that voice ID for TTS

## TTS Providers

### ElevenLabs (Default)
- High quality voices
- Voice cloning support
- ~10,000 characters/month free tier
- Best for: Custom voice personalities

### Google Cloud TTS
- Lower quality but more generous free tier
- 4M characters/month (Standard), 1M (Neural2)
- No voice cloning
- Best for: High volume usage

**To switch providers:**
```bash
# In ~/.claude/.env
TTS_PROVIDER=google  # or elevenlabs
```

## Troubleshooting

### Voice Not Changing When Switching Personalities

**Check 1:** Verify state file is being written:
```bash
cat ~/.claude/state/current-personality.txt
```

**Check 2:** Verify env vars are set:
```bash
grep ELEVENLABS_VOICE ~/.claude/.env
```

**Check 3:** Test voice ID lookup:
```bash
bun -e "
import { getVoiceId } from '\$HOME/.claude/hooks/lib/prosody-enhancer.ts';
console.log('Voice ID:', getVoiceId('pai'));
"
```

### Voice Server Not Running

**Check process:**
```bash
lsof -ti:8888
curl http://localhost:8888/health
```

**Start manually:**
```bash
bun run ~/.claude/voice/server.ts
```

### No Audio Playing

**macOS:** Ensure `afplay` is available (built-in)

**Linux:** Install audio player:
```bash
# Ubuntu/Debian
sudo apt install mpg123
# or
sudo apt install mpv
```

### API Key Issues

**ElevenLabs:**
```bash
# Check key is set
grep ELEVENLABS_API_KEY ~/.claude/.env

# Test API directly
curl -H "xi-api-key: YOUR_KEY" https://api.elevenlabs.io/v1/user
```

**Google:**
```bash
# Ensure Cloud Text-to-Speech API is enabled in Google Cloud Console
# Check key
grep GOOGLE_API_KEY ~/.claude/.env
```

## Adding New Personalities

1. **Create ElevenLabs voice** (or use existing)
2. **Add to `.env`:**
   ```bash
   ELEVENLABS_VOICE_NEWPERSONALITY=voice_id_here
   ```
3. **Add to `voice-personalities.json`:**
   ```json
   "newpersonality": {
     "voice_id": "${ELEVENLABS_VOICE_NEWPERSONALITY}",
     "stability": 0.5,
     "similarity_boost": 0.75,
     "description": "Description here"
   }
   ```
4. **Update `voice-controller.ts`** - add to `VALID_PERSONALITIES` array
5. **Update `prosody-enhancer.ts`** - add to `validPersonalities` in `getCurrentPersonality()`

## Key Files Reference

| File                                       | Purpose                                |
| ------------------------------------------ | -------------------------------------- |
| `~/.claude/.env`                           | All voice IDs stored here              |
| `~/.claude/voice-personalities.json`       | Voice settings (stability, similarity) |
| `~/.claude/voice/server.ts`                | HTTP server handling TTS requests      |
| `~/.claude/state/current-personality.txt`  | Persists selected personality          |
| `~/.claude/hooks/stop-hook-voice.ts`       | Voice notification on main agent stop  |
| `~/.claude/hooks/subagent-stop-hook-voice.ts` | Voice notification on subagent stop |
| `~/.claude/hooks/lib/prosody-enhancer.ts`  | Emotional markers, voice selection     |
| `~/.claude/hooks/lib/voice-controller.ts`  | CLI for switching personalities        |
| `~/.claude/skills/Agents/Data/Traits.yaml` | Atlas trait-to-voice mappings          |

## Related Documentation

- **PAI Pack:** `~/Developer/ai-dev/PAI/Packs/kai-voice-system.md`
- **Commands Reference:** `_ATLAS_COMMANDS.md`
- **Atlas Commands:** `/atlas-voice`, `/atlas-voices`
