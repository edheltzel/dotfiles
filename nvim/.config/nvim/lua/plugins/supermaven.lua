return {
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<C-j>",
					clear_suggestion = "<C-]>",
					accept_word = "<C-k>",
				},
				ignore_filetypes = { cpp = true },
				color = {
					suggestion_color = "#586E75",
					cterm = 244,
				},
				log_level = "info", -- set to "off" to disable logging completely
				disable_inline_completion = false, -- disables inline completion for use with cmp
				disable_keymaps = false,
			})
		end,
	},
}
