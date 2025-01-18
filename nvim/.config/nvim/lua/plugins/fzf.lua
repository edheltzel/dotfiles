return {
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		keys = {
			{ "<leader>f<", "<cmd>FzfLua resume<cr>", desc = "Resume last command" },
			{
				"<leader>fb",
				function()
					require("fzf-lua").lgrep_curbuf({
						winopts = {
							height = 0.6,
							width = 0.5,
							preview = { vertical = "up:70%" },
						},
					})
				end,
				desc = "Grep current buffer",
			},
			{ "<leader><leader>", "<cmd>FzfLua buffers<cr>", desc = "Find buffers" },
			{ "<leader>fC", "<cmd>FzfLua commands<cr>", desc = "Find commands" },
			{ "<leader>fD", "<cmd>FzfLua lsp_workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
			{ "<leader>fc", "<cmd>FzfLua highlights<cr>", desc = "Find highlights" },
			{ "<leader>fd", "<cmd>FzfLua lsp_document_diagnostics<cr>", desc = "Document diagnostics" },
			{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
			{ "<leader>fg", "<cmd>FzfLua git_status<cr>", desc = "Find git" },
			{ "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help" },
			{ "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Find keymaps" },
			{ "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "Recently opened files" },
			{ "<leader>fw", "<cmd>FzfLua grep_visual<cr>", desc = "Grep", mode = "x" },
			{ "<leader>fw", "<cmd>FzfLua live_grep_glob<cr>", desc = "Grep" },
			{ "<leader>fr", "<cmd>FzfLua registers<cr>", desc = "Find registers" },
		},
		opts = function()
			local actions = require("fzf-lua.actions")
			local wk = require("which-key")

			wk.add({
				{ "<leader>f", group = "Find" }, -- group
			})

			return {
				-- Make stuff better combine with the editor.
				fzf_colors = {
					bg = { "bg", "Normal" },
					gutter = { "bg", "Normal" },
					info = { "fg", "Conditional" },
					scrollbar = { "bg", "Normal" },
					separator = { "fg", "Comment" },
				},
				fzf_opts = {
					["--info"] = "default",
					["--layout"] = "reverse-list",
				},
				keymap = {
					builtin = {
						["<C-/>"] = "toggle-help",
						["<C-a>"] = "toggle-fullscreen",
						["<C-i>"] = "toggle-preview",
						["<C-f>"] = "preview-page-down",
						["<C-b>"] = "preview-page-up",
					},
					fzf = {
						["alt-s"] = "toggle",
						["alt-a"] = "toggle-all",
						["ctrl-q"] = "select-all+accept",
					},
				},
				winopts = {
					height = 0.7,
					width = 0.55,
					preview = {
						scrollbar = false,
						layout = "flex",
						vertical = "up:40%",
					},
				},
				-- global_git_icons = true,
				-- Configuration for specific commands.
				files = {
					actions = {
						["ctrl-g"] = actions.toggle_ignore,
					},
				},
				grep = {
					-- header_prefix = icons.misc.search .. " ", // TODO: Add
				},
				helptags = {
					actions = {
						-- Open help pages in a vertical split.
						["default"] = actions.help_vert,
					},
				},
				lsp = {
					code_actions = {
						previewer = "codeaction_native",
						preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS --hunk-header-style='omit' --file-style='omit'",
					},
					symbols = {
						-- symbol_icons = icons.symbol_kinds, // TODO: Add
					},
				},
				oldfiles = {
					include_current_session = true,
					cwd_only = true,
					stat_file = true,
					winopts = {
						preview = { hidden = "hidden" },
					},
				},
				previewers = {
					builtin = {
						syntax_limit_b = 1024 * 100,
					},
				},
			}
		end,
	},
}
