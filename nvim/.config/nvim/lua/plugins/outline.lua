return {
	"hedyhli/outline.nvim",
	config = function()
		-- Example mapping to toggle outline
		vim.keymap.set("n", "<leader>ls", "<cmd>Outline<CR>", { desc = "Toggle Symbols Outline" })

		require("outline").setup({
			outline_window = {
				-- Where to open the split window: right/left
				position = "left",
				-- The default split commands used are 'topleft vs' and 'botright vs'
				-- depending on `position`. You can change this by providing your own
				-- `split_command`.
				-- `position` will not be considered if `split_command` is non-nil.
				-- This should be a valid vim command used for opening the split for the
				-- outline window. Eg, 'rightbelow vsplit'.
				-- Width can be included (with will override the width setting below):
				-- Eg, `topleft 20vsp` to prevent a flash of windows when resizing.
				split_command = nil,

				-- Percentage or integer of columns
				width = 25,
				-- Whether width is relative to the total width of nvim
				-- When relative_width = true, this means take 25% of the total
				-- screen width for outline window.
				relative_width = true,

				-- Auto close the outline window if goto_location is triggered and not for
				-- peek_location
				auto_close = false,
				-- Automatically scroll to the location in code when navigating outline window.
				auto_jump = false,
				-- boolean or integer for milliseconds duration to apply a temporary highlight
				-- when jumping. false to disable.
				jump_highlight_duration = 300,
				-- Whether to center the cursor line vertically in the screen when
				-- jumping/focusing. Executes zz.
				center_on_jump = true,

				-- Vim options for the outline window
				show_numbers = false,
				show_relative_numbers = false,
				wrap = false,

				-- true/false/'focus_in_outline'/'focus_in_code'.
				-- The last two means only show cursorline when the focus is in outline/code.
				-- 'focus_in_outline' can be used if the outline_items.auto_set_cursor
				-- operations are too distracting due to visual contrast caused by cursorline.
				show_cursorline = true,
				-- Enable this only if you enabled cursorline so your cursor color can
				-- blend with the cursorline, in effect, as if your cursor is hidden
				-- in the outline window.
				-- This makes your line of cursor have the same color as if the cursor
				-- wasn't focused on the outline window.
				-- This feature is experimental.
				hide_cursor = false,

				-- Whether to auto-focus on the outline window when it is opened.
				-- Set to false to *always* retain focus on your previous buffer when opening
				-- outline.
				-- If you enable this you can still use bangs in :Outline! or :OutlineOpen! to
				-- retain focus on your code. If this is false, retaining focus will be
				-- enforced for :Outline/:OutlineOpen and you will not be able to have the
				-- other behaviour.
				focus_on_open = true,
				-- Winhighlight option for outline window.
				-- See :help 'winhl'
				-- To change background color to "CustomHl" for example, use "Normal:CustomHl".
				winhl = "",
			},

			outline_items = {
				-- Show extra details with the symbols (lsp dependent) as virtual next
				show_symbol_details = true,
				-- Show corresponding line numbers of each symbol on the left column as
				-- virtual text, for quick navigation when not focused on outline.
				-- Why? See this comment:
				-- https://github.com/simrat39/symbols-outline.nvim/issues/212#issuecomment-1793503563
				show_symbol_lineno = false,
				-- Whether to highlight the currently hovered symbol and all direct parents
				highlight_hovered_item = true,
				-- Whether to automatically set cursor location in outline to match
				-- location in code when focus is in code. If disabled you can use
				-- `:OutlineFollow[!]` from any window or `<C-g>` from outline window to
				-- trigger this manually.
				auto_set_cursor = true,
				-- Autocmd events to automatically trigger these operations.
				auto_update_events = {
					-- Includes both setting of cursor and highlighting of hovered item.
					-- The above two options are respected.
					-- This can be triggered manually through `follow_cursor` lua API,
					-- :OutlineFollow command, or <C-g>.
					follow = { "CursorMoved" },
					-- Re-request symbols from the provider.
					-- This can be triggered manually through `refresh_outline` lua API, or
					-- :OutlineRefresh command.
					items = { "InsertLeave", "WinEnter", "BufEnter", "BufWinEnter", "TabEnter", "BufWritePost" },
				},
			},

			-- Options for outline guides which help show tree hierarchy of symbols
			guides = {
				enabled = true,
				markers = {
					-- It is recommended for bottom and middle markers to use the same number
					-- of characters to align all child nodes vertically.
					bottom = "└",
					middle = "├",
					vertical = "│",
				},
			},

			symbol_folding = {
				-- Depth past which nodes will be folded by default. Set to false to unfold all on open.
				autofold_depth = 1,
				-- When to auto unfold nodes
				auto_unfold = {
					-- Auto unfold currently hovered symbol
					hovered = true,
					-- Auto fold when the root level only has this many nodes.
					-- Set true for 1 node, false for 0.
					only = true,
				},
				markers = { "", "" },
			},

			preview_window = {
				-- Automatically open preview of code location when navigating outline window
				auto_preview = false,
				-- Automatically open hover_symbol when opening preview (see keymaps for
				-- hover_symbol).
				-- If you disable this you can still open hover_symbol using your keymap
				-- below.
				open_hover_on_preview = false,
				width = 50, -- Percentage or integer of columns
				min_width = 50, -- Minimum number of columns
				-- Whether width is relative to the total width of nvim.
				-- When relative_width = true, this means take 50% of the total
				-- screen width for preview window, ensure the result width is at least 50
				-- characters wide.
				relative_width = true,
				height = 50, -- Percentage or integer of lines
				min_height = 10, -- Minimum number of lines
				-- Similar to relative_width, except the height is relative to the outline
				-- window's height.
				relative_height = true,
				-- Border option for floating preview window.
				-- Options include: single/double/rounded/solid/shadow or an array of border
				-- characters.
				-- See :help nvim_open_win() and search for "border" option.
				border = "single",
				-- winhl options for the preview window, see ':h winhl'
				winhl = "NormalFloat:",
				-- Pseudo-transparency of the preview window, see ':h winblend'
				winblend = 0,
				-- Experimental feature that let's you edit the source content live
				-- in the preview window. Like VS Code's "peek editor".
				live = false,
			},

			-- These keymaps can be a string or a table for multiple keys.
			-- Set to `{}` to disable. (Using 'nil' will fallback to default keys)
			keymaps = {
				show_help = "?",
				close = { "<Esc>", "q" },
				-- Jump to symbol under cursor.
				-- It can auto close the outline window when triggered, see
				-- 'auto_close' option above.
				goto_location = "<Cr>",
				-- Jump to symbol under cursor but keep focus on outline window.
				peek_location = "o",
				-- Visit location in code and close outline immediately
				goto_and_close = "<S-Cr>",
				-- Change cursor position of outline window to match current location in code.
				-- 'Opposite' of goto/peek_location.
				restore_location = "<C-g>",
				-- Open LSP/provider-dependent symbol hover information
				hover_symbol = "<C-space>",
				-- Preview location code of the symbol under cursor
				toggle_preview = "K",
				rename_symbol = "r",
				code_actions = "a",
				-- These fold actions are collapsing tree nodes, not code folding
				fold = "h",
				unfold = "l",
				fold_toggle = "<Tab>",
				-- Toggle folds for all nodes.
				-- If at least one node is folded, this action will fold all nodes.
				-- If all nodes are folded, this action will unfold all nodes.
				fold_toggle_all = "<S-Tab>",
				fold_all = "W",
				unfold_all = "E",
				fold_reset = "R",
				-- Move down/up by one line and peek_location immediately.
				-- You can also use outline_window.auto_jump=true to do this for any
				-- j/k/<down>/<up>.
				down_and_jump = "<C-j>",
				up_and_jump = "<C-k>",
			},

			providers = {
				priority = { "lsp", "coc", "markdown", "norg" },
				-- Configuration for each provider (3rd party providers are supported)
				lsp = {
					-- Lsp client names to ignore
					blacklist_clients = {},
				},
				markdown = {
					-- List of supported ft's to use the markdown provider
					filetypes = { "markdown" },
				},
			},

			symbols = {
				-- Filter by kinds (string) for symbols in the outline.
				-- Possible kinds are the Keys in the icons table below.
				-- A filter list is a string[] with an optional exclude (boolean) field.
				-- The symbols.filter option takes either a filter list or ft:filterList
				-- key-value pairs.
				-- Put  exclude=true  in the string list to filter by excluding the list of
				-- kinds instead.
				-- Include all except String and Constant:
				--   filter = { 'String', 'Constant', exclude = true }
				-- Only include Package, Module, and Function:
				--   filter = { 'Package', 'Module', 'Function' }
				-- See more examples below.
				filter = nil,
				icon_fetcher = nil,
				-- 3rd party source for fetching icons. This is used as a fallback if
				-- icon_fetcher returned an empty string.
				-- Currently supported values: 'lspkind'
				icon_source = nil,
				-- The next fallback if both icon_fetcher and icon_source has failed, is
				-- the custom mapping of icons specified below. The icons table is also
				-- needed for specifying hl group.
				icons = {
					File = { icon = "󰈔", hl = "Identifier" },
					Module = { icon = "󰆧", hl = "Include" },
					Namespace = { icon = "󰅪", hl = "Include" },
					Package = { icon = "󰏗", hl = "Include" },
					Class = { icon = "𝓒", hl = "Type" },
					Method = { icon = "ƒ", hl = "Function" },
					Property = { icon = "", hl = "Identifier" },
					Field = { icon = "󰆨", hl = "Identifier" },
					Constructor = { icon = "", hl = "Special" },
					Enum = { icon = "ℰ", hl = "Type" },
					Interface = { icon = "󰜰", hl = "Type" },
					Function = { icon = "", hl = "Function" },
					Variable = { icon = "", hl = "Constant" },
					Constant = { icon = "", hl = "Constant" },
					String = { icon = "𝓐", hl = "String" },
					Number = { icon = "#", hl = "Number" },
					Boolean = { icon = "⊨", hl = "Boolean" },
					Array = { icon = "󰅪", hl = "Constant" },
					Object = { icon = "⦿", hl = "Type" },
					Key = { icon = "🔐", hl = "Type" },
					Null = { icon = "NULL", hl = "Type" },
					EnumMember = { icon = "", hl = "Identifier" },
					Struct = { icon = "𝓢", hl = "Structure" },
					Event = { icon = "🗲", hl = "Type" },
					Operator = { icon = "+", hl = "Identifier" },
					TypeParameter = { icon = "𝙏", hl = "Identifier" },
					Component = { icon = "󰅴", hl = "Function" },
					Fragment = { icon = "󰅴", hl = "Constant" },
					TypeAlias = { icon = " ", hl = "Type" },
					Parameter = { icon = " ", hl = "Identifier" },
					StaticMethod = { icon = " ", hl = "Function" },
					Macro = { icon = " ", hl = "Function" },
				},
			},
		})
	end,
}
