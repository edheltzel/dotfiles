return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		-- LSP clients attached to buffer
		local clients_lsp = function()
			-- local bufnr = vim.api.nvim_get_current_buf()

			local clients = vim.lsp.get_clients()
			if next(clients) == nil then
				return ""
			end

			local c = {}
			for _, client in pairs(clients) do
				table.insert(c, client.name)
			end
			return " " .. table.concat(c, ", ")
		end

		-- Add this to your statusline configuration
		-- If you're using lualine, add this component:
		local function alternate_file()
			local alt_file = vim.fn.expand("#:t")
			if alt_file == "" then
				return ""
			end
			return "⟺  " .. alt_file
		end

		local config = {
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "|" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				always_show_tabline = true,
				globalstatus = false,
				refresh = {
					statusline = 100,
					tabline = 100,
					winbar = 100,
				},
			},
			sections = {
				lualine_a = { "mode" },
				-- lualine_b = { "branch", "filename" },
				-- lualine_c = { "clients_lsp", "diagnostics" },

				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename", alternate_file },

				lualine_x = { clients_lsp, "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		}

		lualine.setup(config)
	end,
}
