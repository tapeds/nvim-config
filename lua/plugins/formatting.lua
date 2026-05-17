return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	lazy = true,
	config = function()
		local languages = require("config.languages")
		local conform = require("conform")
		local util = require("conform.util")

		conform.setup({
			formatters_by_ft = languages.formatters_by_ft,
			format_on_save = function(bufnr)
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				if bufname:match("/node_modules/") then
					return
				end

				return { timeout_ms = 1000, lsp_format = "never" }
			end,
			formatters = {
				prettier = {
					require_cwd = true,
					cwd = util.root_file(languages.prettier_root_files),
				},
				prettierd = {
					require_cwd = true,
					cwd = util.root_file(languages.prettier_root_files),
				},
				biome = {
					require_cwd = true,
					cwd = util.root_file(languages.biome_root_files),
				},
			},
		})
	end,
}
