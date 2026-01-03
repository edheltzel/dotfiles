---
name: Agents
description: Dynamic agent composition and management system. USE WHEN user says create custom agents, spin up custom agents, specialized agents, OR asks for agent personalities, available traits, agent voices. Handles custom agent creation, personality assignment, voice mapping, and parallel agent orchestration.
---

# Agents - Custom Agent Composition System

**Auto-routes when user mentions custom agents, agent creation, or specialized personalities.**

## Overview

The Agents skill provides complete agent composition and management:
- Dynamic agent composition from traits (expertise + personality + approach)
- Personality definitions and voice mappings
- Custom agent creation with unique voices
- Parallel agent orchestration patterns

## Workflow Routing

**Available Workflows:**
- **CREATECUSTOMAGENT** - Create specialized custom agents -> `Workflows/CreateCustomAgent.md`
- **LISTTRAITS** - Show available agent traits -> `Workflows/ListTraits.md`
- **SPAWNPARALLEL** - Launch parallel agents -> `Workflows/SpawnParallelAgents.md`

## Route Triggers

**CRITICAL: The word "custom" is the ABSOLUTE trigger - NO EXCEPTIONS:**

| User Says | What to Use | subagent_type | Why |
|-----------|-------------|---------------|-----|
| "**custom agents**", "create **custom** agents", "spin up **custom**" | AgentFactory | `general-purpose` | Unique prompts + unique voices |
| "agents", "launch agents", "bunch of agents" | Generic prompt | `Intern` | Same voice, parallel grunt work |
| "use [agent name]", "get [agent name] to" | Direct call | Named agent type | Pre-defined personality |

**CONSTITUTIONAL RULE FOR CUSTOM AGENTS:**
When user says "custom agents", you MUST:
1. Use AgentFactory to compose EACH agent with DIFFERENT traits
2. Use `subagent_type: "general-purpose"` - **NEVER** "Intern", "Designer", "Architect", etc.
3. Each agent gets their own voice from the trait-to-voice mapping

## Architecture

### Hybrid Agent Model

Two types of agents:

| Type | Definition | Best For |
|------|------------|----------|
| **Named Agents** | Persistent identities with backstories | Recurring work, voice output |
| **Dynamic Agents** | Task-specific specialists from traits | One-off tasks, parallel work |

### Components

**Data/Traits.yaml** - 28 composable traits with voice mappings
**Templates/DynamicAgent.hbs** - Agent prompt template
**Tools/AgentFactory.ts** - Dynamic composition engine
**AgentPersonalities.md** - Named agent definitions

## Usage

Just ask naturally:
- "I need a legal expert to review this contract"
- "Spin up 5 custom science agents"
- "Get me someone skeptical about security"

The skill routes to appropriate workflow automatically.

## Model Selection

| Task Type | Model | Why |
|-----------|-------|-----|
| Grunt work | `haiku` | 10-20x faster |
| Standard analysis | `sonnet` | Balanced |
| Deep reasoning | `opus` | Maximum intelligence |
