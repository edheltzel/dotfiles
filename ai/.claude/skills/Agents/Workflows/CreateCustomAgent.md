# CreateCustomAgent Workflow

**Creates custom agents with unique personalities and voice IDs using AgentFactory.**

## When to Use

User says:
- "Create custom agents to do X"
- "Spin up custom agents for Y"
- "I need specialized agents with Z expertise"

**KEY TRIGGER: The word "custom" distinguishes from generic agents.**

## The Workflow

### Step 1: Determine Requirements

Extract from user's request:
- How many agents? (Default: 1)
- What's the task?
- Are specific traits mentioned?

### Step 2: Run AgentFactory for EACH Agent with DIFFERENT Traits

**CRITICAL: Each agent MUST have different trait combinations for unique voices.**

```bash
# Example for 3 custom research agents:

# Agent 1 - Enthusiastic Explorer
bun run $PAI_DIR/skills/Agents/Tools/AgentFactory.ts \
  --traits "research,enthusiastic,exploratory" \
  --task "Research quantum computing" \
  --output json

# Agent 2 - Skeptical Analyst
bun run $PAI_DIR/skills/Agents/Tools/AgentFactory.ts \
  --traits "research,skeptical,systematic" \
  --task "Research quantum computing" \
  --output json

# Agent 3 - Thorough Synthesizer
bun run $PAI_DIR/skills/Agents/Tools/AgentFactory.ts \
  --traits "research,analytical,synthesizing" \
  --task "Research quantum computing" \
  --output json
```

### Step 3: Launch Agents in Parallel

**CRITICAL: Use `subagent_type: "general-purpose"` - NEVER "Intern" for custom agents!**

Using "Intern" would override the custom voice. We need "general-purpose" to respect the voice_id from AgentFactory.

Use a SINGLE message with MULTIPLE Task calls:

```typescript
Task({
  description: "Research agent 1 - enthusiastic",
  prompt: <agent1_full_prompt>,
  subagent_type: "general-purpose",  // NEVER "Intern" for custom agents!
  model: "sonnet"
})
Task({
  description: "Research agent 2 - skeptical",
  prompt: <agent2_full_prompt>,
  subagent_type: "general-purpose",  // NEVER "Intern" for custom agents!
  model: "sonnet"
})
```

## Trait Variation Strategies

**For Research Tasks:**
- Agent 1: research + enthusiastic + exploratory -> Energetic voice
- Agent 2: research + skeptical + thorough -> Academic voice
- Agent 3: research + analytical + systematic -> Professional voice

**For Security Analysis:**
- Agent 1: security + adversarial + bold -> Intense voice
- Agent 2: security + skeptical + meticulous -> Gritty voice
- Agent 3: security + cautious + systematic -> Professional voice

## Model Selection

| Task Type | Model | Reason |
|-----------|-------|--------|
| Quick checks | `haiku` | 10-20x faster |
| Standard analysis | `sonnet` | Balanced |
| Deep reasoning | `opus` | Maximum intelligence |

## Common Mistakes

**WRONG: Using named agent types for custom agents**
```typescript
// WRONG - forces same voice on all custom agents!
Task({ prompt: <custom_prompt>, subagent_type: "Intern" })
Task({ prompt: <custom_prompt>, subagent_type: "Designer" })
```

**RIGHT: Using general-purpose for custom agents**
```typescript
// CORRECT - respects the custom voice from AgentFactory
Task({ prompt: <custom_prompt>, subagent_type: "general-purpose" })
```

**WRONG: Same traits for all agents**
```bash
bun run AgentFactory.ts --traits "research,analytical"  # Agent 1
bun run AgentFactory.ts --traits "research,analytical"  # Same voice!
```

**RIGHT: Vary traits for unique voices**
```bash
bun run AgentFactory.ts --traits "research,enthusiastic,exploratory"
bun run AgentFactory.ts --traits "research,skeptical,systematic"
```
