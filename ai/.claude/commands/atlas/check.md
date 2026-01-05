---
description: "Run comprehensive Atlas system health check. Usage: /atlas:check"
allowed-tools: [Read, Bash, Grep, Glob]
---

# Atlas System Health Check

Comprehensive health check of your Personal AI Infrastructure.

Please analyze and report on:

## 1. Directory Structure
- Verify ~/.claude exists with required subdirectories
- Check for hooks/, skills/, commands/ directories
- List any missing standard directories

## 2. Configuration
- Read ~/.claude/settings.json
- Verify all hook events are configured
- Check environment variables (DA, PAI_DIR, etc.)
- Validate voice-personalities.json exists

## 3. Hooks System
- List all hooks in ~/.claude/hooks/
- Check each hook file is executable/readable
- Verify TypeScript files compile (if bun available)
- Report any missing dependencies

## 4. Skills System
- List installed skills
- Verify each skill has SKILL.md
- Check skill-index.json (if exists)
- Report any incomplete skills

## 5. Voice System
- Check if voice server is running (port 8888)
- Verify voice-personalities.json configuration
- List configured personalities
- Check ElevenLabs integration

## 6. Custom Commands
- List custom commands in ~/.claude/commands/
- Verify command format and metadata
- Report any malformed commands

## 7. Dependencies
- Check for bun installation
- Verify required npm packages
- Check git repository status
- Report any missing tools

Provide a summary with:
- ✅ Working components
- ⚠️  Warnings for components needing attention
- ❌ Failed or missing components
- 📋 Recommended actions to fix issues
