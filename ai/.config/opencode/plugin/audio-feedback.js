export const AudioFeedbackPlugin = async ({ $ }) => {
	return {
		event: async ({ event }) => {
			// When agent needs approval/input from user
			if (event.type === "permission.updated") {
				await $`say -v 'Daniel (Enhanced)' "Ed, Bentley here, waiting for your approval"`.quiet();
			}

			// When agent has completed a task
			if (event.type === "session.idle") {
				await $`say -v 'Daniel (Enhanced)' "Ed, I've completed the task."`.quiet();
			}
		},
	};
};
