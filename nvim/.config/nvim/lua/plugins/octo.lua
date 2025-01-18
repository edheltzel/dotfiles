return {
	"pwntester/octo.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"ibhagwan/fzf-lua",
		"nvim-tree/nvim-web-devicons",
	},
	event = { { event = "BufReadCmd", pattern = "octo://*" } },
	cmd = {
		"Octo",
	},
	opts = function(_)
		vim.treesitter.language.register("markdown", "octo")
		vim.api.nvim_create_autocmd("ExitPre", {
			group = vim.api.nvim_create_augroup("octo_exit_pre", { clear = true }),
			callback = function()
				local keep = { "octo" }
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					if vim.tbl_contains(keep, vim.bo[buf].filetype) then
						vim.bo[buf].buftype = "" -- set buftype to empty to keep the window
					end
				end
			end,
		})
	end,
	init = function()
		-- Check if we're in a git repository
		local is_git = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null") == "true\n"
		if is_git then
			-- Force load Octo for git repositories
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					require("lazy").load({ plugins = { "octo.nvim" } })
				end,
				once = true,
			})
		end
	end,
	config = function()
		local wk = require("which-key")
		local prefix = "<Leader>O"
		-- Register the base Octo group immediately

		wk.add({
			{ prefix, group = "Octo", icon = "" },
			{ prefix .. "p", group = "Pull requests" },
			{ prefix .. "pm", group = "Merge current PR" },
			{ prefix .. "i", group = "Issues" },
			{ prefix .. "a", group = "Assignee" },
			{ prefix .. "c", group = "Comments" },
			{ prefix .. "e", group = "Reactions" },
			{ prefix .. "l", group = "Labels" },
			{ prefix .. "r", group = "Repo" },
			{ prefix .. "s", group = "Review" },
			{ prefix .. "t", group = "Threads" },
		})

		-- Assignee/Reviewer commands
		vim.keymap.set("n", prefix .. "aa", "<Cmd>Octo assignee add<CR>", { desc = "Assign a user" })
		vim.keymap.set("n", prefix .. "ap", "<Cmd>Octo reviewer add<CR>", { desc = "Assign a PR reviewer" })
		vim.keymap.set("n", prefix .. "ar", "<Cmd>Octo assignee remove<CR>", { desc = "Remove a user" })

		-- Comments commands
		vim.keymap.set("n", prefix .. "ca", "<Cmd>Octo comment add<CR>", { desc = "Add a new comment" })
		vim.keymap.set("n", prefix .. "cd", "<Cmd>Octo comment delete<CR>", { desc = "Delete a comment" })

		-- Reaction commands
		vim.keymap.set("n", prefix .. "e1", "<Cmd>Octo reaction thumbs_up<CR>", { desc = "Add 👍 reaction" })
		vim.keymap.set("n", prefix .. "e2", "<Cmd>Octo reaction thumbs_down<CR>", { desc = "Add 👎 reaction" })
		vim.keymap.set("n", prefix .. "e3", "<Cmd>Octo reaction eyes<CR>", { desc = "Add 👀 reaction" })
		vim.keymap.set("n", prefix .. "e4", "<Cmd>Octo reaction laugh<CR>", { desc = "Add 😄 reaction" })
		vim.keymap.set("n", prefix .. "e5", "<Cmd>Octo reaction confused<CR>", { desc = "Add 😕 reaction" })
		vim.keymap.set("n", prefix .. "e6", "<Cmd>Octo reaction rocket<CR>", { desc = "Add 🚀 reaction" })
		vim.keymap.set("n", prefix .. "e7", "<Cmd>Octo reaction heart<CR>", { desc = "Add ❤️ reaction" })
		vim.keymap.set("n", prefix .. "e8", "<Cmd>Octo reaction party<CR>", { desc = "Add 🎉 reaction" })

		-- Issues commands
		vim.keymap.set("n", prefix .. "ic", "<Cmd>Octo issue close<CR>", { desc = "Close current issue" })
		vim.keymap.set("n", prefix .. "il", "<Cmd>Octo issue list<CR>", { desc = "List open issues" })
		vim.keymap.set("n", prefix .. "io", "<Cmd>Octo issue browser<CR>", { desc = "Open current issue in browser" })
		vim.keymap.set("n", prefix .. "ir", "<Cmd>Octo issue reopen<CR>", { desc = "Reopen current issue" })
		vim.keymap.set("n", prefix .. "iu", "<Cmd>Octo issue url<CR>", { desc = "Copies URL of current issue" })

		-- Label commands
		vim.keymap.set("n", prefix .. "la", "<Cmd>Octo label add<CR>", { desc = "Assign a label" })
		vim.keymap.set("n", prefix .. "lc", "<Cmd>Octo label create<CR>", { desc = "Create a label" })
		vim.keymap.set("n", prefix .. "lr", "<Cmd>Octo label remove<CR>", { desc = "Remove a label" })

		-- Pull request commands
		vim.keymap.set("n", prefix .. "pc", "<Cmd>Octo pr close<CR>", { desc = "Close current PR" })
		vim.keymap.set("n", prefix .. "pd", "<Cmd>Octo pr diff<CR>", { desc = "Show PR diff" })
		vim.keymap.set("n", prefix .. "pl", "<Cmd>Octo pr changes<CR>", { desc = "List changed files in PR" })
		vim.keymap.set("n", prefix .. "pmd", "<Cmd>Octo pr merge delete<CR>", { desc = "Delete merge PR" })
		vim.keymap.set("n", prefix .. "pmm", "<Cmd>Octo pr merge commit<CR>", { desc = "Merge commit PR" })
		vim.keymap.set("n", prefix .. "pmr", "<Cmd>Octo pr merge rebase<CR>", { desc = "Rebase merge PR" })
		vim.keymap.set("n", prefix .. "pms", "<Cmd>Octo pr merge squash<CR>", { desc = "Squash merge PR" })
		vim.keymap.set("n", prefix .. "pn", "<Cmd>Octo pr create<CR>", { desc = "Create PR for current branch" })
		vim.keymap.set("n", prefix .. "po", "<Cmd>Octo pr browser<CR>", { desc = "Open current PR in browser" })
		vim.keymap.set("n", prefix .. "pp", "<Cmd>Octo pr checkout<CR>", { desc = "Checkout PR" })
		vim.keymap.set("n", prefix .. "pr", "<Cmd>Octo pr ready<CR>", { desc = "Mark draft as ready for review" })
		vim.keymap.set("n", prefix .. "ps", "<Cmd>Octo pr list<CR>", { desc = "List open PRs" })
		vim.keymap.set("n", prefix .. "pt", "<Cmd>Octo pr commits<CR>", { desc = "List PR commits" })
		vim.keymap.set("n", prefix .. "pu", "<Cmd>Octo pr url<CR>", { desc = "Copies URL of current PR" })

		-- Repo commands
		vim.keymap.set("n", prefix .. "rf", "<Cmd>Octo repo fork<CR>", { desc = "Fork repo" })
		vim.keymap.set("n", prefix .. "rl", "<Cmd>Octo repo list<CR>", { desc = "List repo user stats" })
		vim.keymap.set("n", prefix .. "ro", "<Cmd>Octo repo open<CR>", { desc = "Open current repo in browser" })
		vim.keymap.set("n", prefix .. "ru", "<Cmd>Octo repo url<CR>", { desc = "Copies URL of current repo" })

		-- Review commands
		vim.keymap.set("n", prefix .. "sc", "<Cmd>Octo review close<CR>", { desc = "Return to PR" })
		vim.keymap.set("n", prefix .. "sc", "<Cmd>Octo review comments<CR>", { desc = "View pending comments" })
		vim.keymap.set("n", prefix .. "sd", "<Cmd>Octo review discard<CR>", { desc = "Delete pending review" })
		vim.keymap.set("n", prefix .. "sf", "<Cmd>Octo review submit<CR>", { desc = "Submit review" })
		vim.keymap.set("n", prefix .. "sp", "<Cmd>Octo review commit<CR>", { desc = "Select commit to review" })
		vim.keymap.set("n", prefix .. "sr", "<Cmd>Octo review resume<CR>", { desc = "Resume review" })
		vim.keymap.set("n", prefix .. "ss", "<Cmd>Octo review start<CR>", { desc = "Start review" })

		-- Thread commands
		vim.keymap.set("n", prefix .. "ta", "<Cmd>Octo thread resolve<CR>", { desc = "Mark thread as resolved" })
		vim.keymap.set("n", prefix .. "td", "<Cmd>Octo thread unresolve<CR>", { desc = "Mark thread as unresolved" })

		-- Actions command
		vim.keymap.set("n", prefix .. "x", "<Cmd>Octo actions<CR>", { desc = "Run an action" })

		require("octo").setup({
			picker = "fzf-lua",
			picker_config = {
				use_emojis = true,
			},
		})
	end,
}
