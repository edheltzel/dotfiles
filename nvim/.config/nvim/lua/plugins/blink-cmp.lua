return {
	"saghen/blink.cmp",
	event = { "LspAttach" },
	dependencies = { "rafamadriz/friendly-snippets", "giuxtaposition/blink-cmp-copilot", "zbirenbaum/copilot.lua" },

	version = "*",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		-- remember to enable your providers here
		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "buffer", "copilot", "dadbod", "codecompanion" },
			cmdline = function()
				local type = vim.fn.getcmdtype()
				-- Search forward and backward
				if type == "/" or type == "?" then
					return { "buffer" }
				end
				-- Commands
				if type == ":" then
					return { "cmdline" }
				end
				return {}
			end,

			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
				dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
				copilot = {
					name = "copilot",
					module = "blink-cmp-copilot",
					score_offset = 100,
					async = true,
					transform_items = function(_, items)
						local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
						local kind_idx = #CompletionItemKind + 1
						CompletionItemKind[kind_idx] = "Copilot"
						for _, item in ipairs(items) do
							item.kind = kind_idx
						end
						return items
					end,
				},
				lsp = {
					min_keyword_length = 0, -- Number of characters to trigger porvider
					score_offset = 100, -- Boost/penalize the score of the items
				},
				path = {
					min_keyword_length = 0,
				},
				snippets = {
					min_keyword_length = 1,
				},
				buffer = {
					min_keyword_length = 1,
					max_items = 1,
				},
				codecompanion = {
					name = "CodeCompanion",
					module = "codecompanion.providers.completion.blink",
					enabled = true,
				},
			},
		},
		keymap = {
			preset = "default",
		},
		fuzzy = {
			use_frecency = true,
		},
		appearance = {
			nerd_font_variant = "mono",
			kind_icons = {
				Copilot = "",
				Text = "󰉿",
				Method = "󰊕",
				Function = "󰊕",
				Constructor = "󰒓",

				Field = "󰜢",
				Variable = "󰆦",
				Property = "󰖷",

				Class = "󱡠",
				Interface = "󱡠",
				Struct = "󱡠",
				Module = "󰅩",

				Unit = "󰪚",
				Value = "󰦨",
				Enum = "󰦨",
				EnumMember = "󰦨",

				Keyword = "󰻾",
				Constant = "󰏿",

				Snippet = "󱄽",
				Color = "󰏘",
				File = "󰈔",
				Reference = "󰬲",
				Folder = "󰉋",
				Event = "󱐋",
				Operator = "󰪚",
				TypeParameter = "󰬛",
			},
		},

		completion = {
			menu = {
				border = "none",
				draw = {
					treesitter = { "lsp" },
					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
						{ "kind" },
					},
				},
				-- winhighlight = "Normal:NormalFloat,CursorLine:PmenuSel,Search:None",
			},
			accept = {
				auto_brackets = { enabled = true },
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				treesitter_highlighting = true,

				-- window = {
				-- 	border = "none",
				-- 	-- winhighlight = "Normal:NormalFloat,CursorLine:PmenuSel,Search:None",
				-- },
			},
			ghost_text = { enabled = true },
			list = {
				selection = function(ctx)
					return ctx.mode == "cmdline" and "auto_insert" or "preselect"
				end,
			},
		},
		signature = {
			enabled = true,
			window = {
				border = "none",
				-- winhighlight = "Normal:NormalFloat",
			},
		},
	},
	opts_extend = { "sources.default" },
}
