-- return {
-- 	{
-- 		"nvim-telescope/telescope.nvim",
-- 		dependencies = { "nvim-lua/plenary.nvim" },
-- 		config = function()
-- 			local builtin = require("telescope.builtin")
-- 			vim.keymap.set("n", ";f", builtin.find_files, {})
-- 			vim.keymap.set("n", ";r", builtin.live_grep, {})
-- 			vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { noremap = true, silent = true })
-- 		end,
-- 	},
-- }

return {
	"dmtrKovalenko/fff.nvim",
	build = function()
		require("fff.download").download_or_build_binary()
	end,
	opts = {
		debug = {
			enabled = false,
			show_scores = false,
		},
	},
	lazy = false,
	keys = {
		{
			";f",
			function()
				require("fff").find_files()
			end,
			desc = "FFFind files",
		},
		{
			";r",
			function()
				require("fff").live_grep()
			end,
			desc = "LiFFFe grep",
		},
		{
			";w",
			function()
				require("fff").live_grep({ query = vim.fn.expand("<cword>") })
			end,
			desc = "Search current word",
		},
	},
}
