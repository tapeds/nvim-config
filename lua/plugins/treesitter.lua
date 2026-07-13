return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",

	config = function()
		local languages = require("config.languages")

		require("nvim-treesitter").setup({
			ensure_installed = languages.treesitter,
			auto_install = true,
			sync_install = false,
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local ok = pcall(vim.treesitter.start, args.buf)
				if not ok then
					return
				end
			end,
		})
	end,
}
