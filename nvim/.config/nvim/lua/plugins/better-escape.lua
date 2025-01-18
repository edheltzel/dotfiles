return {
	"max397574/better-escape.nvim",
	config = function()
		require("better_escape").setup({
			timeout = vim.o.timeoutlen,
			default_mappings = false,
			mappings = {
				i = {
					j = {
						k = "<Esc>",
						j = "<Esc>",
					},
				},
			},
		})
	end,
}
