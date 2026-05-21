return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",

	config = function()
		local languages = require("config.languages")

		require("nvim-treesitter.configs").setup({
			highlight = { enable = true },
			sync_install = false,
			auto_install = true,
			ensure_installed = languages.treesitter,
		})
	end,
}
