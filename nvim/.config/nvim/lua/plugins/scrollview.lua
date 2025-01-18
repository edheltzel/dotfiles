return {
	"petertriho/nvim-scrollbar",
	config = function()
		require("scrollbar").setup({
			handlers = {
				gitsigns = true,
				search = true,
			},
		})
	end,
}
