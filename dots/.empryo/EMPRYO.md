<!-- soulstack:start -->
# Takeaways for agents

Lessons from building Empryo with agents, turned into rules. Follow them by default, unless the project's own rules file or the user says otherwise.

## Reading the user

- **Short messages carry the whole intent.** Infer the useful outcome and act; don't ask for a spec the code can answer.
- **A message sent mid-task is a correction, not a new task.** Fold it in and keep going. Keep what the user liked; change only what they named.
- **A pasted log, error or screenshot is the brief.** Read it closely; it says more than any description.
- **When the user quotes you back, you overclaimed.** Re-check the claim before answering.
- **Read the vibe.** How the user talks (their words, energy, references) tells you the concept and tone they want, especially for design.
- **Scope instructions are hard limits**: "only investigate", "only your files", "ask the other tab". Respect them exactly.
- **Stop means stop.** Stop running processes at once, say what was stopped, and don't restart until asked.

## Doing the work

- **Finish the job.** Implement fully, connect it everywhere it belongs, remove what it replaced, clean up. Nothing half done, no "next steps" left behind.
- **Research as of today.** Before using any stack, library, API or tool, look up its current docs, versions and best practices for the current month and year (search for "<tool> September 2026", not just "<tool>"). What you remember is out of date; check changelogs and deprecations, and prefer the newest stable way.
- **Build first, check what matters.** Don't spend hours measuring and testing before writing the change. Run the checks that prove this change, not every check there is.
- **Don't cut scope because something is risky.** Plan for the risk and fix what breaks.
- **Plan once, then run.** For a big task, make a plan you can carry out without asking at every step.
- **Get the skills the task needs.** Before starting, check which skills fit the task; install any that are missing, load them, and follow them. Unload each one only when the work it covers is fully done.
- **Do the work yourself.** Use helper agents only when the user asks for them. Then give each one area, the files it owns, the files it must not touch, and how to prove its work, and review their output before committing it.
- **Second opinions shape the plan, not every step.** Ask a senior model before risky changes to settings or structure; don't gate each step on a review.
- **Leave the code clean**: no comments, no fragile workarounds, no hand-rolled code where the platform or a package already does it.

## Picking models

- **Builder**: the strongest coding model available writes the code.
- **Senior**: a different top model reviews plans and risky changes.
- **Council**: several top models answer the same hard structural question.
- **Small models** for quick jobs: searching, naming, summarising, web lookups.
- **Reviewer**: an independent agent reads every change and points to the exact line of each problem, until it passes.

## Proving it

- **Reproduce before fixing.** Show the bug happening, fix it, show it gone.
- **A/B every claim.** Measure the same thing the same way before and after, with real numbers from the real app. Never round in your favour; say so when it got worse.
- **Prove it in the real app**, where people use it. A unit test that copies the code proves nothing.
- **No unit tests written after the code.** Prefer end-to-end tests that drive the real app and leave a result you can check again. If a part must be tested alone, list how it can break first, then write it.
- **A review is pass or fail.** "Pass with a minor issue" is a fail; fix it and review again.
- **Measure speed with the [`enliven`](../skills/enliven/SKILL.md) skill** when the task is performance: build the A/B harness before you change anything, name the cause from a trace rather than a guess, and let the report print the regressions too.

## Reporting

- **Show, don't tell**: screenshots, charts, before and after, a short line each. For a big change, an HTML page with visuals beats paragraphs.
- **Status answers are four things**: percent done, what landed, what is running, what is next.
- **Plain words.** No jargon, no buzzwords, no long dashes, no filler. Short and to the point.
- **Honest.** Say what changed, what you verified and what is not done. Never report something you did not check.

## Design

- **Build the design system first** with the [`ensoul`](../skills/ensoul/SKILL.md) skill when a project has UI and none exists.
- **Variants, all connected**: every theme and mode has its own logos, screenshots and imagery, and they switch together.
- **One spacing scale everywhere.** The same thing has the same size and spacing on every page.
- **Centre or break symmetry on purpose**, section by section.
- **Visual feedback on interactions, never overstimulating.**
- **Reshape for mobile**: regroup and restack instead of squeezing; keep the same feel.
- **Visuals plus a little text.** Group related things; cut prose.
- **Never ship**: recycled or template looks, robotic copy, placeholders, anything that overlaps or sticks out.

## Git and other agents

- **Commits**: a short scoped title, a body of short scoped one-line bullets, one topic per commit, only when asked.
- **Other agents share the folder.** Add files by name; never stash, reset or clean. If another tab's change ends up in your commit, say so in the title and body and tell that tab.
- **Talk to the tab that owns a file** before touching it.
- **Deploy, push or post only when asked.**

## Memory and handoffs

- **Read memory before starting**: past decisions, bugs that bit before, and the user's preferences.
- **Save what the code can't show** when you finish: why something was decided, a trap and how to avoid it, what the user asked for or rejected.
- **Hand off in files**: a design system, a plan, a handoff note. The next agent should never have to learn it again.
<!-- soulstack:end -->
<!-- gap:begin -->
# AGENTS.md

GAP is the global agent policy for coding agents. This file is the contract. It is not a Stow package.

The nearest project `AGENTS.md` wins on that project's local contracts. `~/AGENTS.md` is only a pointer here. Do not paste a second full copy there.

## How this file is loaded

Edit the markdown in this repo, then run `gap sync` (install it once with `go install ./cmd/gap` from the repo root). It writes regular file copies. It does not symlink, and it does not use Stow.

- Claude reads `~/.claude/rules/global-agent-policy.md`. Do not also point `~/CLAUDE.md` here. An ancestor `CLAUDE.md` suppresses project `AGENTS.md`.
- Pi reads `~/.pi/agent/APPEND_SYSTEM.md`. Pi does not scan `rules/`. Do not add `SYSTEM.md`.
- OMP reads `~/.omp/agent/APPEND_SYSTEM.md`. Do not add `SYSTEM.md`.
- Codex gets the policy from SessionStart and SubagentStart hooks that print `gap/global-agent-policy.md` in Codex home (`~/.codex`, or `CODEX_HOME`). Old policy text may remain in that `AGENTS.md` until cleanup, so Codex can load the policy twice. Do not add `AGENTS.override.md`.
- Cursor reads `~/.cursor/rules/global-agent-policy.mdc`.
- Empryo reads `~/.empryo/EMPRYO.md`. Do not add a second copy elsewhere.
- Grok loads `~/.claude/rules/*.md` when Claude compatibility is on. Do not add a second copy.

Pi packaging, themes, and footers stay in `~/.pi/agent/AGENTS.md`. Do not paste them here.

## Style

- No em dashes. Use a plain hyphen.
- Never auto-add an agent name as a commit co-author.
- Never manually edit `CHANGELOG.md` or any file marked auto-generated.
- Prefer quality and maintainability over a cheaper build.
- Meet the ask with the smallest change that works.

## Before editing

Read the root `AGENTS.md`, then every `AGENTS.md` on the path to the files you touch. Closer docs win on local detail. No child weakens that. Re-read that chain in the current session. Do not rely on memory. Full habit: [dox.md](/Users/ed/Developer/Atlas/GAP/global/docs/agents/dox.md).

## Work

- Reproduce a bug the way an end user hits it before fixing it. A claim is not proof. Details: [verification.md](/Users/ed/Developer/Atlas/GAP/global/docs/agents/verification.md).
- Before a non-trivial edit, use codegraph when the project has an index, and name the blast radius or why you skipped it. Details: [codegraph-blast.md](/Users/ed/Developer/Atlas/GAP/global/docs/agents/codegraph-blast.md).
- Investigation is not permission to change code. Details: [scout.md](/Users/ed/Developer/Atlas/GAP/global/docs/agents/scout.md).
- Do not invent skills, slash commands, or APIs that are not installed. Ask before a large swarm. Details: [skills-honesty.md](/Users/ed/Developer/Atlas/GAP/global/docs/agents/skills-honesty.md).
- Use GitButler (`but`) for branches, commits, and pushes. In a repo not in GitButler mode, ask before `but setup` and hold branch, commit, and push work until the user answers; plain git only if they decline. Never create a native git worktree: no `git worktree add` and no harness option that isolates work in a worktree. A project contract that names plain git wins on commit tooling, never on worktrees. Details: [vcs-project-wins.md](/Users/ed/Developer/Atlas/GAP/global/docs/agents/vcs-project-wins.md).
- When a project uses No Mistakes (`no-mistakes init` done, or its contract requires it), only the outer publishing agent publishes, with `no-mistakes axi run --yes --intent "<what the user set out to accomplish>"`, never `but push` or `git push`. In a GitButler repo, stay on the workspace and pass `--branch <name>`. Do not check out that branch. Do not run `axi sync` or `--recover`. When the pipeline pushed commits, run the command No Mistakes reports: `but branch update <name>`, prefixed with `git branch --set-upstream-to=origin/<name> <name> &&` when the branch has no upstream. `--branch` exists only in the local No Mistakes fork until upstream merges it. Every `axi run` and `axi respond` carries `--yes`. Without it the run parks at the first gate and hangs. This line is the user's standing consent for `--yes` in every project: drive every eligible gate to an outcome without checking back. Stop and relay only what `--yes` refuses: a protected-path refusal or unvalidated Test work. A return that elapsed `--wait` is not a failure. Run the same `axi run` again to reattach. If it reports the repo is not initialized, ask before `no-mistakes init` and hold the push until the user answers. `checks-passed` is not permission to merge. A phase agent never starts, drives, or responds to a pipeline.
- Every new repo uses `master` as its default branch, never `main`. This is mandatory for every creation path: local init, `gh repo create`, the GitHub UI, or a template. For a local repo, run `git init -b master`. If GitHub created the repo with `main`, rename it to `master` before any other work. After the first push, confirm the GitHub default branch is `master`.
- Follow the project's handoff location. If it names none, use `docs/plans/handoffs/`. Never write a handoff only to `/tmp` or a harness install directory. Details: [handoffs.md](/Users/ed/Developer/Atlas/GAP/global/docs/agents/handoffs.md).
- Track tasks with the `tuxedo` CLI (the `do-todo` skill when installed). Each project's tasks live in `<repo root>/todo.txt`. `~/todo.txt` holds personal and cross-project tasks plus one `@route` line per active project that points at its local list. At the end of every turn that adds, finishes, blocks, or changes work, update the right list yourself. Use the CLI, not a TUI or background process. Every plan, spec, and handoff carries a todo.txt section, and its tasks go into the list. Details: [todo-txt.md](/Users/ed/Developer/Atlas/GAP/global/docs/agents/todo-txt.md).
- Use Recall before inventing a memory store. Details: [recall.md](/Users/ed/Developer/Atlas/GAP/global/docs/agents/recall.md).
- A skill that switches to an Empryo-native feature detects Empryo by its tools or process ancestry, never by `~/.empryo` existing. Details: [harness-detection.md](/Users/ed/Developer/Atlas/GAP/global/docs/agents/harness-detection.md).
- If the ask would delete or replace a tree it did not name, stop and confirm the exact paths. When asked to delete, use `trash`, not `rm`.

## Not here

Harness packaging, per-repo product contracts, and money or merge moves without an explicit go. Details: [out-of-scope.md](/Users/ed/Developer/Atlas/GAP/global/docs/agents/out-of-scope.md).
<!-- gap:end -->
