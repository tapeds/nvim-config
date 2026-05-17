return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = false,
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				local opts = { buffer = bufnr, silent = true }

				vim.keymap.set("n", "<leader>gb", gitsigns.blame_line, opts)
				vim.keymap.set("n", "<leader>gB", function()
					gitsigns.blame_line({ full = true })
				end, opts)
			end,
		},
	},
	{
		"f-person/git-blame.nvim",
		event = { "BufReadPre", "BufNewFile" },
	},
}
