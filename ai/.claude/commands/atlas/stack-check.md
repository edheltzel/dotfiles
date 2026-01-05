---
description: "Verify project uses Atlas stack preferences. Usage: /atlas:stack-check"
allowed-tools: [Read, Glob, Grep]
---

# Stack Preference Check

Verify this project follows Atlas stack preferences.

**Checking for:**
- ✅ TypeScript over Python
- ✅ bun (not npm/yarn/pnpm)
- ✅ Bun runtime
- ✅ Markdown over HTML

Please analyze the current project and check:

1. **Package Manager**: Look for package.json and check if it uses bun
   - Check for `bun.lockb` (good) vs `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml` (bad)

2. **Language Preference**:
   - Count TypeScript files vs Python files
   - Check if package.json scripts use `bun` commands

3. **Documentation**:
   - Verify README and docs use `.md` files, not `.html`

Report any violations of stack preferences and suggest corrections.
