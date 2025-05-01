return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	lazy = true,
	config = function()
		local conform = require("conform")
		local util = require("conform.util")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				swift = { "swiftformat" },
				javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
				typescript = { "biome", "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
				css = { "biome", "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
			},
			format_on_save = function(bufnr)
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				if bufname:match("/node_modules/") then
					return
				end

				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
			formatters = {
				prettier = {
					require_cwd = true,
					cwd = util.root_file({
						-- https://prettier.io/docs/en/configuration.html
						".prettierrc",
						".prettierrc.json",
						".prettierrc.yml",
						".prettierrc.yaml",
						".prettierrc.json5",
						".prettierrc.js",
						".prettierrc.cjs",
						".prettierrc.mjs",
						".prettierrc.toml",
						"prettier.config.js",
						"prettier.config.cjs",
						"prettier.config.mjs",
						-- "package.json",
					}),
				},
				prettierd = {
					require_cwd = true,
					cwd = util.root_file({
						-- https://prettier.io/docs/en/configuration.html
						".prettierrc",
						".prettierrc.json",
						".prettierrc.yml",
						".prettierrc.yaml",
						".prettierrc.json5",
						".prettierrc.js",
						".prettierrc.cjs",
						".prettierrc.mjs",
						".prettierrc.toml",
						"prettier.config.js",
						"prettier.config.cjs",
						"prettier.config.mjs",
						-- "package.json",
					}),
				},
				biome = {
					require_cwd = true,
					cwd = util.root_file({
						-- https://prettier.io/docs/en/configuration.html
						"biome.json",
						-- "package.json",
					}),
				},
			},
		})
	end,
}
