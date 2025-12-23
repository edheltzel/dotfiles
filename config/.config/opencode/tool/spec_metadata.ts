import { tool } from "@opencode-ai/plugin"

export default tool({
  description:
    "Get metadata for research/plan documents including date, git info, and timestamp for filename",
  args: {},
  async execute() {
    const now = new Date()

    // Format: YYYY-MM-DD HH:MM:SS TZ
    const dateTimeTz = now
      .toLocaleString("en-US", {
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit",
        hour12: false,
        timeZoneName: "short",
      })
      .replace(/(\d+)\/(\d+)\/(\d+),/, "$3-$1-$2")

    // Format for filename: YYYY-MM-DD_HH-MM-SS
    const filenameTs = now.toISOString().slice(0, 19).replace(/[T:]/g, (c) => (c === "T" ? "_" : "-"))

    // Get git info
    let gitCommit = ""
    let gitBranch = ""
    let repoName = ""

    try {
      const isGitRepo = await Bun.$`git rev-parse --is-inside-work-tree 2>/dev/null`.text()

      if (isGitRepo.trim() === "true") {
        const repoRoot = (await Bun.$`git rev-parse --show-toplevel`.text()).trim()
        repoName = repoRoot.split("/").pop() || ""
        gitBranch = (
          await Bun.$`git branch --show-current 2>/dev/null || git rev-parse --abbrev-ref HEAD`.text()
        ).trim()
        gitCommit = (await Bun.$`git rev-parse HEAD`.text()).trim()
      }
    } catch {
      // Not in a git repo, leave values empty
    }

    const lines = [`Current Date/Time (TZ): ${dateTimeTz}`]
    if (gitCommit) lines.push(`Current Git Commit Hash: ${gitCommit}`)
    if (gitBranch) lines.push(`Current Branch Name: ${gitBranch}`)
    if (repoName) lines.push(`Repository Name: ${repoName}`)
    lines.push(`Timestamp For Filename: ${filenameTs}`)

    return lines.join("\n")
  },
})
