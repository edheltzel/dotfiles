import { tool } from "@opencode-ai/plugin";

export default tool({
	description:
		"Get metadata for research/plan documents including date, git info, and timestamp for filename",
	args: {},
	async execute() {
		const errors: string[] = [];

		console.log("[spec_metadata] Starting...");

		const now = new Date();

		// Format: YYYY-MM-DD HH:MM:SS TZ
		console.log("[spec_metadata] Formatting date/time...");
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
			.replace(/(\d+)\/(\d+)\/(\d+),/, "$3-$1-$2");

		// Format for filename: YYYY-MM-DD_HH-MM-SS
		const filenameTs = now
			.toISOString()
			.slice(0, 19)
			.replace(/[T:]/g, (c) => (c === "T" ? "_" : "-"));

		// Get git info
		let gitCommit = "";
		let gitBranch = "";
		let repoName = "";

		console.log("[spec_metadata] Checking git repo...");
		try {
			const isGitRepo =
				await Bun.$`git rev-parse --is-inside-work-tree 2>/dev/null`
					.quiet()
					.text()
					.catch(() => "false");

			if (isGitRepo.trim() === "true") {
				console.log("[spec_metadata] Getting git info...");

				try {
					const repoRoot = (
						await Bun.$`git rev-parse --show-toplevel`.quiet().text()
					).trim();
					repoName = repoRoot.split("/").pop() || "";
				} catch (e) {
					errors.push(`Failed to get repo root: ${e}`);
				}

				try {
					gitBranch = (
						await Bun.$`git branch --show-current`.quiet().text()
					).trim();
					if (!gitBranch) {
						gitBranch = (
							await Bun.$`git rev-parse --abbrev-ref HEAD`.quiet().text()
						).trim();
					}
				} catch (e) {
					errors.push(`Failed to get branch: ${e}`);
				}

				try {
					gitCommit = (await Bun.$`git rev-parse HEAD`.quiet().text()).trim();
				} catch (e) {
					errors.push(`Failed to get commit: ${e}`);
				}
			} else {
				console.log("[spec_metadata] Not in a git repo");
			}
		} catch (e) {
			errors.push(`Git check failed: ${e}`);
		}

		console.log("[spec_metadata] Building response...");
		const lines = [`Current Date/Time (TZ): ${dateTimeTz}`];
		if (gitCommit) lines.push(`Current Git Commit Hash: ${gitCommit}`);
		if (gitBranch) lines.push(`Current Branch Name: ${gitBranch}`);
		if (repoName) lines.push(`Repository Name: ${repoName}`);
		lines.push(`Timestamp For Filename: ${filenameTs}`);

		if (errors.length > 0) {
			lines.push("");
			lines.push("Warnings:");
			errors.forEach((err) => lines.push(`  - ${err}`));
		}

		console.log("[spec_metadata] Complete!");
		return lines.join("\n");
	},
});
