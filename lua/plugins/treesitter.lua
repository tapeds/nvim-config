return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local configs = require("nvim-treesitter.configs")
		local parsers = require("nvim-treesitter.parsers").get_parser_configs()

		parsers.blade = {
			install_info = {
				url = "https://github.com/EmranMR/tree-sitter-blade",
				files = { "src/parser.c" },
				branch = "main",
			},
			filetype = "blade",
		}

		vim.filetype.add({
			pattern = {
				[".*%.blade%.php"] = "blade",
			},
		})

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
				"php",
			},
		})
	end,
}
