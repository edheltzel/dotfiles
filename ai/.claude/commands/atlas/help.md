---
description: "Show all available Atlas commands. Usage: /atlas:help"
---

# Atlas Command Reference

Quick reference for all Atlas custom commands.

## Voice Management
- `/atlas:voice <name>` - Switch voice personality
- `/atlas:voices` - List all available voice personalities

## Skills
- `/atlas:art <task>` - Launch Art skill for visual content
- `/atlas:agents <task>` - Launch Agents skill for custom agents
- `/atlas:browser <task>` - Launch Browser skill for web automation
- `/atlas:prompting <task>` - Launch Prompting skill for meta-prompting
- `/atlas:skills` - List installed skills

## System Status
- `/atlas:status` - Show Atlas system status and health
- `/atlas:check` - Comprehensive system health check
- `/atlas:hooks` - Show active hooks configuration
- `/atlas:context` - Show current session context

## Observability
- `/atlas:observability [action]` - Start/stop/restart observability dashboard
  - Actions: `start`, `stop`, `restart`, `status` (default: start)

## Stack & Preferences
- `/atlas:stack-check` - Verify project uses Atlas stack preferences

## Pack Management
- `/atlas:pack` - List available PAI packs with install status
- `/atlas:pack install <name>` - Install a PAI pack
- `/atlas:docs [doc]` - Access PAI documentation

## Quick Actions
- `/atlas:help` - Show this help (you are here!)

---

**About Atlas:**
Personal AI Infrastructure - modular, self-contained functionality for your AI assistant.

**Core Philosophy:**
- First-person voice ("I" not "the system")
- TypeScript over Python
- bun (NEVER npm/yarn/pnpm)
- Markdown over HTML

**Assistant Identity:**
- Name: Atlas
- User: Ed
- Operating Environment: PAI on Claude Code

For full documentation: `/atlas:docs`
