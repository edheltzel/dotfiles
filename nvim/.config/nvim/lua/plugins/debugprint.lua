local js_like = {
	left = 'console.info("',
	right = '")',
	mid_var = '", ',
	right_var = ")",
}

return {
	"andrewferrier/debugprint.nvim",
	opts = {
		keymaps = {
			normal = {
				plain_below = "gpp",
				plain_above = "gpP",
				variable_below = "gpv",
				variable_above = "gpV",
				variable_below_alwaysprompt = nil,
				variable_above_alwaysprompt = nil,
				textobj_below = "gpo",
				textobj_above = "gpO",
				toggle_comment_debug_prints = nil,
				delete_debug_prints = nil,
			},
			visual = {
				variable_below = "gpv",
				variable_above = "gpV",
			},
		},
		commands = {
			toggle_comment_debug_prints = "ToggleCommentDebugPrints",
			delete_debug_prints = "DeleteDebugPrints",
		},
		filetypes = {
			["javascript"] = js_like,
			["javascriptreact"] = js_like,
			["typescript"] = js_like,
			["typescriptreact"] = js_like,
		},
	},
}
