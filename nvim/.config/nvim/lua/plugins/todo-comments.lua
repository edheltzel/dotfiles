return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("todo-comments").setup({})
		vim.keymap.set("n", "<Leader>ft", "<Cmd>TodoFzfLua<CR>", { desc = "Find Todo Comments" })
	end,
}
