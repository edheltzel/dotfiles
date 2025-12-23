---
description: Stage changes and create a git commit
agent: build
---

Create a git commit for the current changes.

## Steps

1. Run these commands in parallel to understand the current state:
   - `git status` - see all untracked and modified files
   - `git diff` - see unstaged changes
   - `git diff --cached` - see staged changes
   - `git log --oneline -5` - see recent commit message style

2. Analyze the changes and draft a commit message:
   - List files changed/added
   - Identify the type of change (feature, fix, refactor, docs, etc.)
   - Focus on the "why" not the "what"
   - Match the repository's existing commit message style
   - Keep it concise (1-2 sentences)

3. Stage and commit:
   - Stage relevant files (use `git add -A` for all, or be selective)
   - Run `git commit -m "your message"`
   - Run `git status` to confirm success

4. If the commit fails due to pre-commit hooks modifying files, retry once.

$ARGUMENTS
