---
type: documentation
category: methodology
description: Prompt engineering standards based on Anthropic's Claude 4.x best practices, context engineering principles, and empirical research.
---

# Prompt Engineering Standards

**Foundation:** Based on Anthropic's Claude 4.x Best Practices (November 2025), context engineering principles, and 1,500+ academic papers.

**Philosophy:** Universal principles of semantic clarity and structure that work regardless of model, with specific optimizations for Claude 4.x behavioral patterns.

---

# Core Philosophy

**Context engineering** is the set of strategies for curating and maintaining the optimal set of tokens during LLM inference.

**Primary Goal:** Find the smallest possible set of high-signal tokens that maximize the likelihood of desired outcomes.

---

# Claude 4.x Behavioral Characteristics

## Communication Style Changes

- **More direct reporting:** Claude 4.5 provides fact-based progress updates
- **Conversational efficiency:** Natural language without unnecessary elaboration
- **Request verbosity explicitly:** Add "provide a quick summary of the work you've done"

## Attention to Detail

- **Example sensitivity:** Claude 4.x pays close attention to details in examples
- **Misaligned examples encourage unintended behaviors**
- Ensure examples match desired outcomes exactly

## Tool Usage Patterns

- **Opus 4.5 may overtrigger tools:** Dial back aggressive language
- **Change:** "CRITICAL: You MUST use this tool" → "Use this tool when..."

## Extended Thinking Sensitivity

When extended thinking is disabled:
- **Avoid:** "think", "think about", "think through"
- **Use instead:** "consider", "believe", "evaluate", "reflect", "assess"

---

# Key Principles

## 0. Markdown Only - NO XML Tags

**CRITICAL: Use markdown for ALL prompt structure. Never use XML tags.**

## 1. Be Explicit with Instructions

Claude 4.x requires clear, specific direction.

## 2. Add Context and Motivation

Explain *why* certain behavior matters.

## 3. Tell Instead of Forbid

Frame instructions positively rather than as prohibitions.

## 4. Context is a Finite Resource

Every token depletes attention capacity. Treat context as precious.

## 5. Optimize for Signal-to-Noise Ratio

Focus on high-value tokens that drive desired outcomes.

---

# Empirical Foundation

**Research validates that prompt structure has measurable, significant impact:**

- **Performance Range:** 10-90% variation based on structure choices
- **Few-Shot Examples:** +25% to +90% improvement (optimal: 1-3 examples)
- **Structured Organization:** Consistent performance gains
- **Full Component Integration:** +25% improvement on complex tasks

**Sources:** 1,500+ academic papers, Microsoft PromptBench, Amazon Alexa production testing.

---

# The Ultimate Prompt Template

## Full Template

```markdown
# [Task Name]

## Context & Motivation
[WHY this matters - Claude generalizes from reasoning provided]

## Background
[Minimal essential context - every token costs attention]

## Instructions
1. [First clear, actionable directive]
2. [Second directive]
3. [Third directive]

## Examples
**Example 1: [Scenario]**
- Input: [Representative input]
- Output: [Exact desired output]

## Constraints
- **Success:** [What defines successful completion]
- **Failure:** [What defines failure]

## Output Format
[Explicit specification]

## Tools
- `tool_name(params)` - Use when [specific condition]
```

## Section Selection Matrix

| Task Type | Required | Recommended |
|-----------|----------|-------------|
| Simple Query | Instructions, Output Format | Context |
| Complex Implementation | Context, Instructions, Output Format, Tools | Examples, Constraints |
| Research/Analysis | Context, Instructions, Constraints | Examples |
| Agentic Coding | Context, Instructions, Tools, Verification | Constraints |

---

# Anti-Patterns to Avoid

- **Verbose Explanations** - Be direct
- **Negative-Only Constraints** - Tell what TO do
- **Aggressive Tool Language** - Use soft framing
- **Misaligned Examples** - Check carefully
- **Example Overload** - 1-3 examples optimal
- **Using "Think" with Extended Thinking Disabled** - Use "consider" instead

---

# References

**Primary Sources:**
- Anthropic: "Claude 4.x Best Practices" (November 2025)
- Anthropic: "Effective Context Engineering for AI Agents"
- Daniel Miessler's Fabric System (January 2024)
- "The Prompt Report" - arXiv:2406.06608 (58 techniques)
- "The Prompt Canvas" - arXiv:2412.05127 (100+ papers)
