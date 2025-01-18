return {
	"Wansmer/treesj",
	dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
	config = function()
		require("treesj").setup({})
		vim.keymap.set("n", "<Leader>lt", "<Cmd>TSJToggle<CR>", { desc = "Toggle code block" })
	end,
}
