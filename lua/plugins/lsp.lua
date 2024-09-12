return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	opts = {
		inlay_hints = { enabled = true },
		servers = {
			eslint = {
				root_dir = function(...)
					return require("lspconfig.util").root_pattern("package.json")(...)
				end,
				settings = {
					workingDirectories = { mode = "auto" },
				},
			},
			biome = {
				single_file_support = false,
				root_dir = function(...)
					return require("lspconfig.util").root_pattern("biome.json", "biome.jsonc")(...)
				end,
			},
			cssls = {},
			tailwindcss = {
				root_dir = function(...)
					return require("lspconfig.util").root_pattern(
						"tailwind.config.cjs",
						"tailwind.config.js",
						"postcss.config.js"
					)(...)
				end,
			},
			tsserver = {
				root_dir = function(...)
					return require("lspconfig.util").root_pattern("tsconfig.json", "jsconfig.json", "package.json")(...)
				end,
				single_file_support = false,
				settings = {
					typescript = {
						autoClosingTags = true,
						inlayHints = {
							includeInlayParameterNameHints = "literal",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = false,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
						preferences = {
							importModuleSpecifier = "non-relative",
							importModuleSpecifierPreference = "non-relative",
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
				},
			},
			gopls = {
				root_dir = function(...)
					return require("lspconfig.util").root_pattern("go.work", "go.mod")(...)
				end,
			},
			html = {},
			lua_ls = {
				single_file_support = true,
				settings = {
					Lua = {
						workspace = {
							checkThirdParty = false,
						},
						completion = {
							workspaceWord = true,
							callSnippet = "Both",
						},
						misc = {
							parameters = {},
						},
						hint = {
							enable = true,
							setType = false,
							paramType = true,
							paramName = "Disable",
							semicolon = "Disable",
							arrayIndex = "Disable",
						},
						doc = {
							privateName = { "^_" },
						},
						type = {
							castNumberToInteger = true,
						},
						diagnostics = {
							disable = { "incomplete-signature-doc", "trailing-space" },
							-- enable = false,
							groupSeverity = {
								strong = "Warning",
								strict = "Warning",
							},
							groupFileStatus = {
								["ambiguity"] = "Opened",
								["await"] = "Opened",
								["codestyle"] = "None",
								["duplicate"] = "Opened",
								["global"] = "Opened",
								["luadoc"] = "Opened",
								["redefined"] = "Opened",
								["strict"] = "Opened",
								["strong"] = "Opened",
								["type-check"] = "Opened",
								["unbalanced"] = "Opened",
								["unused"] = "Opened",
							},
							unusedLocalExclude = { "_*" },
						},
						format = {
							enable = false,
							defaultConfig = {
								indent_style = "space",
								indent_size = "2",
								continuation_indent_size = "2",
							},
						},
					},
				},
			},
			setup = {},
		},
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")
		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		lspconfig.eslint.setup({
			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					command = "EslintFixAll",
				})
			end,
		})

		lspconfig.tsserver.setup({
			capabilities = capabilities,
		})

		lspconfig.lua_ls.setup({
			capabilities = capabilities,
		})

		lspconfig.tailwindcss.setup({
			capabilities = capabilities,
		})

		lspconfig.cssls.setup({
			capabilities = capabilities,
		})

		lspconfig.gopls.setup({
			capabilities = capabilities,
			cmd = { "gopls" },
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
		})

		lspconfig.biome.setup({
			filetypes = {
				"javascript",
				"javascriptreact",
				"json",
				"jsonc",
				"typescript",
				"typescript.tsx",
				"typescriptreact",
				"astro",
				"svelte",
				"vue",
				"css",
			},
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
			ensure_installed = {
				"tsserver",
				"cssls",
				"html",
				"gopls",
				"tailwindcss",
				"lua_ls",
				"biome",
			},
			automatic_installation = true,
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettierd",
				"prettier",
				"eslint_d",
				"stylua",
				"eslint",
			},
		})
	end,
}
