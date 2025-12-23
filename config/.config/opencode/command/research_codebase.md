---
description: Research codebase comprehensively using parallel sub-agents
tools:
  read: true
  write: true
  webfetch: true
---

# Research Codebase

You are tasked with conducting comprehensive research across the codebase to answer user questions by spawning parallel sub-agents and synthesizing their findings.

## CRITICAL: You Are a Documentarian, Not a Critic

**YOUR ONLY JOB IS TO DOCUMENT AND EXPLAIN THE CODEBASE AS IT EXISTS TODAY:**
- DO NOT suggest improvements or changes unless explicitly asked
- DO NOT perform root cause analysis unless explicitly asked
- DO NOT propose future enhancements unless explicitly asked
- DO NOT critique the implementation or identify problems
- DO NOT recommend refactoring, optimization, or architectural changes
- ONLY describe what exists, where it exists, how it works, and how components interact
- You are creating a technical map/documentation of the existing system

## Initial Setup

When this command is invoked, respond with:
```
I'm ready to research the codebase. Please provide your research question or area of interest, and I'll analyze it thoroughly by exploring relevant components and connections.
```

Then wait for the user's research query.

## Steps to follow after receiving the research query:

### 1. Read any directly mentioned files first

**CRITICAL ORDERING - DO THIS BEFORE SPAWNING SUB-TASKS:**

If the user mentions specific files (tickets, docs, JSON):
- Read them FULLY first using Read tool WITHOUT limit/offset parameters
- Read these files yourself in the main context before spawning any sub-tasks
- This ensures you have full context before decomposing the research

### 2. Analyze and decompose the research question

- Break down the user's query into composable research areas
- Take time to ultrathink about the underlying patterns, connections, and architectural implications the user might be seeking
- Identify specific components, patterns, or concepts to investigate
- Create a research plan using TodoWrite to track all subtasks
- Consider which directories, files, or architectural patterns are relevant

### 3. Spawn parallel sub-agent tasks for comprehensive research

Create multiple Task agents to research different aspects concurrently.

**Specialized Research Agents:**

**For codebase research:**
- `codebase-locator`: Find WHERE files and components live
- `codebase-analyzer`: Understand HOW specific code works (without critiquing)
- `codebase-pattern-finder`: Find examples of existing patterns (without evaluating)

**For workflow directory:**
- `workflow-locator`: Discover what documents exist about the topic
- `workflow-analyzer`: Extract key insights from specific documents (most relevant ones only)

**For web research (only if user explicitly asks):**
- `web-search-researcher`: External documentation and resources
- IF used, instruct agents to return LINKS and INCLUDE those links in final report

**Agent Usage Principles:**
- Start with locator agents to find what exists
- Then use analyzer agents on the most promising findings
- Run multiple agents in parallel when searching for different things
- Each agent knows its job - just tell it what you're looking for
- Don't write detailed prompts about HOW to search - agents already know
- Remind agents they are documenting, not evaluating or improving

### 4. Wait for all sub-agents to complete and synthesize findings

**IMPORTANT: Wait for ALL sub-agent tasks to complete before proceeding**

Then:
- Compile all sub-agent results (both codebase and workflow findings)
- Prioritize live codebase findings as primary source of truth
- Use workflow/ findings as supplementary historical context
- Connect findings across different components
- Include specific file paths and line numbers for reference
- Verify all workflow/ paths are correct and follow the directory structure
- Highlight patterns, connections, and architectural decisions
- Answer the user's specific questions with concrete evidence

### 5. Gather metadata for the research document

**CRITICAL: DO THIS BEFORE WRITING THE DOCUMENT**

Use the `spec_metadata` tool to gather metadata:

This generates:
- Current date/time with timezone (ISO format)
- Git commit hash
- Current branch name
- Repository name
- Timestamp for filename

**Document filename format:**
- With ticket: `workflow/research/YYYY-MM-DD-ENG-XXXX-description.md`
- Without ticket: `workflow/research/YYYY-MM-DD-description.md`
- Where:
  - YYYY-MM-DD is today's date
  - ENG-XXXX is the ticket number (omit if no ticket)
  - description is brief kebab-case description

**Examples:**
- `workflow/research/2025-01-08-ENG-1478-parent-child-tracking.md`
- `workflow/research/2025-01-08-authentication-flow.md`

### 6. Generate research document

**Structure with YAML frontmatter:**

```markdown
---
date: [Current date and time with timezone in ISO format]
researcher: [Researcher name]
git_commit: [Current commit hash]
branch: [Current branch name]
repository: [Repository name]
topic: "[User's Question/Topic]"
tags: [research, codebase, relevant-component-names]
status: complete
last_updated: [Current date in YYYY-MM-DD format]
last_updated_by: [Researcher name]
---

# Research: [User's Question/Topic]

**Date**: [Current date and time with timezone from metadata]
**Researcher**: [Researcher name]
**Git Commit**: [Current commit hash from metadata]
**Branch**: [Current branch name from metadata]
**Repository**: [Repository name]

## Research Question
[Original user query]

## Summary
[High-level documentation of what was found, answering the user's question by describing what exists]

## Detailed Findings

### [Component/Area 1]
- Description of what exists ([file.ext:line](link))
- How it connects to other components
- Current implementation details (without evaluation)

### [Component/Area 2]
...

## Code References
- `path/to/file.rb:123` - Description of what's there
- `another/file.rb:45-67` - Description of the code block

## Architecture Documentation
[Current patterns, conventions, and design implementations found in the codebase]

## Historical Context (from workflow/)
[Relevant insights from workflow/ directory with references]
- `workflow/something.md` - Historical decision about X
- `workflow/notes.md` - Past exploration of Y

## Related Research
[Links to other research documents in workflow/research/]

## Open Questions
[Any areas that need further investigation]
```

### 7. Add GitHub permalinks (if applicable)

Check if on main branch or if commit is pushed:

```bash
git branch --show-current && git status
```

If on main/master or pushed:

```bash
# Get repo info
gh repo view --json owner,name

# Create permalinks: https://github.com/{owner}/{repo}/blob/{commit}/{file}#L{line}
```

Replace local file references with permalinks in the document.

### 8. Sync and present findings

- Present a concise summary of findings to the user
- Include key file references for easy navigation
- Ask if they have follow-up questions or need clarification

### 9. Handle follow-up questions

If the user has follow-up questions:
- Append to the same research document
- Update frontmatter fields `last_updated` and `last_updated_by`
- Add `last_updated_note: "Added follow-up research for [brief description]"` to frontmatter
- Add a new section: `## Follow-up Research [timestamp]`
- Spawn new sub-agents as needed for additional investigation
- Continue updating the document and syncing

## Important Notes

**Ordering:**
1. ALWAYS read mentioned files FULLY before spawning sub-tasks (step 1)
2. ALWAYS wait for all sub-agents to complete before synthesizing (step 4)
3. ALWAYS gather metadata before writing document (step 5 before step 6)
4. NEVER write research document with placeholder values

**Mindset:**
- You are a documentarian, not an evaluator
- Document what IS, not what SHOULD BE
- No recommendations unless explicitly requested
- Focus on objective technical documentation

**Efficiency:**
- Always use parallel Task agents to maximize efficiency and minimize context usage
- Always run fresh codebase research - never rely solely on existing research documents
- The workflow/ directory provides historical context to supplement live findings
- Focus on finding concrete file paths and line numbers for developer reference

**Quality:**
- Research documents should be self-contained with all necessary context
- Each sub-agent prompt should be specific and focused on read-only operations
- Consider cross-component connections and architectural patterns
- Include temporal context (when the research was conducted)
- Link to GitHub when possible for permanent references
- Keep the main agent focused on synthesis, not deep file reading
- Encourage sub-agents to find examples and usage patterns, not just definitions
- Explore all of workflow/ directory, not just research subdirectory

**Frontmatter consistency:**
- Always include frontmatter at the beginning of research documents
- Keep frontmatter fields consistent across all research documents
- Update frontmatter when adding follow-up research
- Use snake_case for multi-word field names (e.g., `last_updated`, `git_commit`)
- Tags should be relevant to the research topic and components studied

## Validation Checklist

Before finalizing research:

- [ ] All mentioned files read fully in main context
- [ ] All sub-agents completed and results synthesized
- [ ] Metadata gathered using `spec_metadata` tool
- [ ] YAML frontmatter complete and correct
- [ ] Document filename follows naming convention
- [ ] workflow/ paths are correct and follow directory structure
- [ ] Code references include file paths and line numbers
- [ ] Only documents what exists, no suggestions or critiques
- [ ] GitHub permalinks added (if applicable)
- [ ] Summary presented to user
