return {
	"greggh/claude-code.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local claude_code = require("claude-code")

		claude_code.setup({
			window = {
				split_ratio = 0.3,
				position = "topleft vertical",
			},
			keymap = {
				toggle = {
					normal = "<C-,>",
					terminal = "<C-,>",
				},
				window_navigation = true,
				scrolling = true,
			},
		})
	end,
}
