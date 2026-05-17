return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local languages = require("config.languages")
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")
		local lspconfig_util = require("lspconfig.util")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local function root_pattern(...)
			local matcher = lspconfig_util.root_pattern(...)

			return function(bufnr, on_dir)
				local fname = vim.api.nvim_buf_get_name(bufnr)
				local root = matcher(fname)

				if root then
					on_dir(root)
				end
			end
		end

		local function root_pattern_or_file(...)
			local matcher = lspconfig_util.root_pattern(...)

			return function(bufnr, on_dir)
				local fname = vim.api.nvim_buf_get_name(bufnr)
				on_dir(matcher(fname) or vim.fs.dirname(fname))
			end
		end

		local function setup(server, config)
			config = config or {}
			config.capabilities = vim.tbl_deep_extend("force", capabilities, config.capabilities or {})
			vim.lsp.config(server, config)
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
			callback = function(event)
				local opts = { buffer = event.buf, silent = true }
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			end,
		})

		for server, config in pairs(languages.lsp_servers(root_pattern, root_pattern_or_file)) do
			setup(server, config)
		end
		pcall(vim.lsp.enable, "sourcekit")

		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("UserTerraformFormat", { clear = true }),
			pattern = { "*.tf", "*.tfvars" },
			callback = function(event)
				vim.lsp.buf.format({ bufnr = event.buf, timeout_ms = 1000 })
			end,
		})

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			ensure_installed = languages.mason_lsp_servers,
			automatic_enable = true,
		})

		mason_tool_installer.setup({
			ensure_installed = languages.mason_tools,
		})
	end,
}
