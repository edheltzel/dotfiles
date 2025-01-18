-- mason, write correct names only
vim.api.nvim_create_user_command("MasonInstallAll", function()
	vim.cmd(
		"MasonInstall lua-language-server vtsls biome tailwindcss-language-server emmet-language-server stylua prettierd"
	)
end, {})

-- Create highlight group for yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 200,
			on_visual = true,
		})
	end,
	desc = "Highlight yanked text",
})
