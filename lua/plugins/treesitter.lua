return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },

	opts = function()
		local languages = require("config.languages")

		return {
			highlight = { enable = true },
			sync_install = false,
			auto_install = true,
			ensure_installed = languages.treesitter,
		}
	end,
}
