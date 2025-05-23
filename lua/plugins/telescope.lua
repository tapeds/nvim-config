return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", ";f", builtin.find_files, {})
			vim.keymap.set("n", ";r", builtin.live_grep, {})
			vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { noremap = true, silent = true })
		end,
	},
}
