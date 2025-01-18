return {
	"willothy/moveline.nvim",
	build = "make",
	config = function()
		local moveline = require("moveline")
		vim.keymap.set("v", "<M-k>", moveline.block_up)
		vim.keymap.set("v", "<M-j>", moveline.block_down)
	end,
}
