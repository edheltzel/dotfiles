return {
	"nvim-neotest/neotest",
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-neotest/nvim-nio",
		"marilari88/neotest-vitest",
	},
	keys = {
		-- Main commands
		{
			"<leader>Tt",
			function()
				require("neotest").run.run()
			end,
			desc = "󰙨 Run test",
		},
		{
			"<leader>Td",
			function()
				require("neotest").run.run({ strategy = "dap" })
			end,
			desc = "󰃤 Debug test",
		},
		{
			"<leader>Tf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "󰙨 Run file tests",
		},
		{
			"<leader>Tp",
			function()
				require("neotest").run.run(vim.fn.getcwd())
			end,
			desc = "󰙨 Run project tests",
		},
		{
			"<leader>Ts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "󱂩 Toggle summary",
		},
		{
			"<leader>To",
			function()
				require("neotest").output.open()
			end,
			desc = "󰘥 Show output",
		},
		{
			"<leader>TO",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "󰁥 Toggle output panel",
		},

		-- Jump between tests
		{
			"]t",
			function()
				require("neotest").jump.next()
			end,
			desc = "Next test",
		},
		{
			"[t",
			function()
				require("neotest").jump.prev()
			end,
			desc = "Previous test",
		},

		-- Watch functionality
		{
			"<leader>Tw",
			function()
				require("neotest").watch.toggle()
			end,
			desc = "󱎫 Watch test",
		},
		{
			"<leader>TW",
			function()
				require("neotest").watch.toggle(vim.fn.expand("%"))
			end,
			desc = "󱎫 Watch file",
		},
		{
			"<leader>TP",
			function()
				require("neotest").watch.toggle(vim.fn.getcwd())
			end,
			desc = "󱎫 Watch project",
		},
		{
			"<leader>TS",
			function()
				--- NOTE: The proper type of the argument is missing in the documentation
				---@see https://github.com/nvim-neotest/neotest/blob/master/doc/neotest.txt#L626-L632
				---@diagnostic disable-next-line: missing-parameter
				require("neotest").watch.stop()
			end,
			desc = "󰓛 Stop watching",
		},
	},
	opts = function(_, opts)
		if vim.g.icons_enabled == false then
			opts.icons = {
				failed = "X",
				notify = "!",
				passed = "O",
				running = "*",
				skipped = "-",
				unknown = "?",
				watching = "W",
			}
		end
		opts.adapters = {
			require("neotest-vitest"),
		}
	end,
	config = function(_, opts)
		-- Configure diagnostic format
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
					return message
				end,
			},
		}, vim.api.nvim_create_namespace("neotest"))

		require("neotest").setup(opts)
	end,
}
