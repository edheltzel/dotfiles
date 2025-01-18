return {
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		config = function()
			require("ts_context_commentstring").setup({})
		end,
	},

	{
		"numToStr/Comment.nvim",
		config = function()
			local commentstring_avail, commentstring =
				pcall(require, "ts_context_commentstring.integrations.comment_nvim")
			require("Comment").setup({
				pre_hook = commentstring_avail and commentstring.create_pre_hook(),
			})
			vim.keymap.set("n", "<Leader>/", function()
				return require("Comment.api").call(
					"toggle.linewise." .. (vim.v.count == 0 and "current" or "count_repeat"),
					"g@$"
				)()
			end, { expr = true, silent = true, desc = "Toggle comment line" })
			vim.keymap.set(
				"x",
				"<Leader>/",
				"<Esc><Cmd>lua require('Comment.api').locked('toggle.linewise')(vim.fn.visualmode())<CR>",
				{ silent = true, desc = "Toggle comment" }
			)
		end,
	},
}
