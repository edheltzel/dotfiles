return {
	-- Changed windows position to right, excluded some directories
	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = {
			close_if_last_window = true,
			window = {
				position = "right",
				width = 40,
			},
			default_component_configs = {
				file_size = {
					enabled = true,
					required_width = 64, -- min width of window required to show this column
				},
				type = {
					enabled = true,
					required_width = 122, -- min width of window required to show this column
				},
				last_modified = {
					enabled = true,
					required_width = 88, -- min width of window required to show this column
				},
				created = {
					enabled = true,
					required_width = 110, -- min width of window required to show this column
				},
				symlink_target = {
					enabled = false,
				},
			},
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = true,
					hide_hidden = true, -- only works on Windows for hidden files/directories
					hide_by_name = {
						"node_modules",
						".git",
					},
					hide_by_pattern = { -- uses glob style patterns
						--"*.meta",
						--"*/src/*/tsconfig.json",
					},
					always_show = { -- remains visible even if other settings would normally hide it
						--".gitignored",
					},
					never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
						".DS_Store",
						--"thumbs.db"
					},
					never_show_by_pattern = { -- uses glob style patterns
						--".null-ls_*",
					},
				},
			},
		},
	},
}
