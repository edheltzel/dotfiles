# Voice System Mapping

Two voice naming systems exist in the Atlas infrastructure. Both need corresponding environment variables in `~/.claude/.env`.

## Overview

| System | Source | Voice Names |
|--------|--------|-------------|
| **Custom Hooks** | `hooks/lib/prosody-enhancer.ts` | engineer, architect, pentester, etc. |
| **Atlas Agents Skill** | `skills/Agents/Data/Traits.yaml` | Authoritative, Intense, Warm, etc. |

Both systems call `ELEVENLABS_VOICE_${NAME}` from environment variables.

---

## Custom Hook Voices (Ed's System)

Used by `subagent-stop-hook-voice.ts` when agents output `[AGENT:xxx]` tags.

| Voice Name | Archetype | Energy | Description |
|------------|-----------|--------|-------------|
| `pai` | professional | expressive | Primary AI assistant |
| `intern` | enthusiast | chaotic | Eager 176 IQ genius |
| `engineer` | wise-leader | stable | Fortune 10 principal engineer |
| `architect` | wise-leader | stable | PhD-level system designer |
| `researcher` | analyst | measured | Comprehensive research specialist |
| `designer` | critic | measured | Exacting UX/UI specialist |
| `artist` | enthusiast | chaotic | Visual content creator |
| `pentester` | enthusiast | chaotic | Offensive security specialist |
| `writer` | professional | expressive | Content creation specialist |

**Environment variables:**
```bash
ELEVENLABS_VOICE_PAI=<voice_id>
ELEVENLABS_VOICE_INTERN=<voice_id>
ELEVENLABS_VOICE_ENGINEER=<voice_id>
ELEVENLABS_VOICE_ARCHITECT=<voice_id>
ELEVENLABS_VOICE_RESEARCHER=<voice_id>
ELEVENLABS_VOICE_DESIGNER=<voice_id>
ELEVENLABS_VOICE_ARTIST=<voice_id>
ELEVENLABS_VOICE_PENTESTER=<voice_id>
ELEVENLABS_VOICE_WRITER=<voice_id>
```

---

## Atlas Agents Skill Voices (Upstream)

Used by `AgentFactory.ts` when composing dynamic agents from traits.

| Voice Name | Characteristics | Use Case |
|------------|-----------------|----------|
| `Authoritative` | authoritative, measured, intellectual | Serious analysis |
| `Professional` | professional, balanced, neutral | General use |
| `Warm` | warm, friendly, engaging | Supportive interactions |
| `Gentle` | warm, calm, gentle | Empathetic guidance |
| `Energetic` | energetic, excited, dynamic | Enthusiastic delivery |
| `Dynamic` | energetic, fast, charismatic | Exciting content |
| `Academic` | intellectual, warm, academic | Research and analysis |
| `Sophisticated` | intellectual, sophisticated, smooth | Nuanced discussion |
| `Intense` | edgy, gravelly, intense | Adversarial/security work |
| `Gritty` | edgy, raspy, authentic | Skeptical analysis |

**Environment variables:**
```bash
ELEVENLABS_VOICE_AUTHORITATIVE=<voice_id>
ELEVENLABS_VOICE_PROFESSIONAL=<voice_id>
ELEVENLABS_VOICE_WARM=<voice_id>
ELEVENLABS_VOICE_GENTLE=<voice_id>
ELEVENLABS_VOICE_ENERGETIC=<voice_id>
ELEVENLABS_VOICE_DYNAMIC=<voice_id>
ELEVENLABS_VOICE_ACADEMIC=<voice_id>
ELEVENLABS_VOICE_SOPHISTICATED=<voice_id>
ELEVENLABS_VOICE_INTENSE=<voice_id>
ELEVENLABS_VOICE_GRITTY=<voice_id>
```

---

## Suggested Mapping

Map Atlas voices to your existing custom voices (same ElevenLabs voice ID, different names):

| Atlas Voice | Maps To | Rationale |
|-----------|---------|-----------|
| `AUTHORITATIVE` | engineer | Wise, measured authority |
| `PROFESSIONAL` | engineer | Balanced professional |
| `WARM` | designer | Friendly, engaging |
| `GENTLE` | designer | Calm, empathetic |
| `ENERGETIC` | intern | High energy, enthusiastic |
| `DYNAMIC` | artist | Fast-paced, creative |
| `ACADEMIC` | researcher | Intellectual analysis |
| `SOPHISTICATED` | architect | Nuanced, deliberate |
| `INTENSE` | pentester | Edgy, adversarial |
| `GRITTY` | pentester | Skeptical, authentic |

---

## Example .env Configuration

```bash
# ============================================
# ELEVENLABS CONFIGURATION
# ============================================
ELEVENLABS_API_KEY=your_api_key_here

# Default fallback voice
ELEVENLABS_VOICE_DEFAULT=<default_voice_id>

# ============================================
# CUSTOM HOOK VOICES (Ed's System)
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
# Atlas AGENTS SKILL VOICES (Upstream)
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
```

---

## How Voices Are Resolved

### Custom Hooks Flow
1. Subagent outputs: `🎯 COMPLETED: [AGENT:engineer] Task done`
2. `subagent-stop-hook-voice.ts` extracts `engineer`
3. `getVoiceId("engineer")` reads `ELEVENLABS_VOICE_ENGINEER`
4. Voice server speaks with that voice

### Atlas Agents Skill Flow
1. `AgentFactory.ts` composes agent with traits: `security, skeptical, adversarial`
2. Traits map to voice: `Intense`
3. Template includes voice ID from `ELEVENLABS_VOICE_INTENSE`
4. Agent prompt includes voice assignment

---

## Files Reference

| File | Purpose |
|------|---------|
| `~/.claude/.env` | All voice IDs stored here |
| `~/.claude/voice-personalities.json` | Voice settings (stability, similarity) |
| `~/.claude/hooks/lib/prosody-enhancer.ts` | Custom hook voice resolution |
| `~/.claude/skills/Agents/Data/Traits.yaml` | PAI trait-to-voice mappings |
