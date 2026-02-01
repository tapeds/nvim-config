return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			highlight = { enable = true },
			sync_install = false,
			auto_install = true,
			ensure_installed = {
				"javascript",
				"typescript",
				"css",
				"html",
				"go",
				"gitignore",
				"graphql",
				"http",
				"json",
				"scss",
				"sql",
				"vim",
				"lua",
				"tsx",
				"svelte",
				"hcl",
				"terraform",
			},
		})
	end,
}
