local M = {}

M.prettier_root_files = {
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
}

M.eslint_root_files = {
	"eslint.config.js",
	"eslint.config.mjs",
	"eslint.config.cjs",
	".eslintrc",
	".eslintrc.js",
	".eslintrc.cjs",
	".eslintrc.yaml",
	".eslintrc.yml",
	".eslintrc.json",
}

M.biome_root_files = {
	"biome.json",
	"biome.jsonc",
}

M.tailwind_root_files = {
	"tailwind.config.cjs",
	"tailwind.config.js",
	"tailwind.config.ts",
	"postcss.config.js",
	"postcss.config.cjs",
	"postcss.config.mjs",
}

M.typescript_root_files = {
	"tsconfig.json",
	"jsconfig.json",
	"package.json",
}

M.go_root_files = {
	"go.work",
	"go.mod",
}

M.treesitter = {
	"javascript",
	"typescript",
	"tsx",
	"css",
	"html",
	"go",
	"php",
	"gitignore",
	"graphql",
	"http",
	"json",
	"scss",
	"sql",
	"vim",
	"lua",
	"svelte",
	"hcl",
	"terraform",
}

M.formatters_by_ft = {
	lua = { "stylua" },
	swift = { "swiftformat" },
	javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
	javascriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
	typescript = { "biome", "prettierd", "prettier", stop_after_first = true },
	typescriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
	css = { "biome", "prettierd", "prettier", stop_after_first = true },
	html = { "prettierd", "prettier", stop_after_first = true },
	json = { "biome", "prettierd", "prettier", stop_after_first = true },
	yaml = { "prettierd", "prettier", stop_after_first = true },
	markdown = { "prettierd", "prettier", stop_after_first = true },
	php = { "php_cs_fixer" },
}

M.mason_lsp_servers = {
	"vtsls",
	"eslint",
	"cssls",
	"html",
	"gopls",
	"tailwindcss",
	"lua_ls",
	"biome",
	"emmet_language_server",
	"svelte",
	"terraformls",
	"intelephense",
}

M.mason_tools = {
	"prettierd",
	"prettier",
	"stylua",
	"php-cs-fixer",
}

function M.lsp_servers(root_pattern, root_pattern_or_file)
	return {
		eslint = {
			root_dir = root_pattern(unpack(M.eslint_root_files)),
			settings = {
				workingDirectories = { mode = "auto" },
			},
			on_attach = function(_, bufnr)
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = vim.api.nvim_create_augroup("UserEslintFixAll", { clear = false }),
					buffer = bufnr,
					callback = function()
						if vim.fn.exists(":EslintFixAll") == 2 then
							vim.cmd("silent! EslintFixAll")
						end
					end,
				})
			end,
		},
		vtsls = {
			root_dir = root_pattern_or_file(unpack(M.typescript_root_files)),
			init_options = {
				preferences = {
					importModuleSpecifier = "non-relative",
					importModuleSpecifierPreference = "non-relative",
				},
			},
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
		biome = {
			root_dir = root_pattern(unpack(M.biome_root_files)),
			single_file_support = false,
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
		},
		tailwindcss = {
			root_dir = root_pattern(unpack(M.tailwind_root_files)),
		},
		cssls = {},
		html = {},
		svelte = {},
		intelephense = {},
		csharp_ls = {},
		terraformls = {
			filetypes = { "terraform", "tf" },
		},
		gopls = {
			root_dir = root_pattern(unpack(M.go_root_files)),
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
		},
		emmet_language_server = {
			filetypes = { "html", "templ" },
		},
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
						groupSeverity = {
							strong = "Warning",
							strict = "Warning",
						},
						groupFileStatus = {
							ambiguity = "Opened",
							await = "Opened",
							codestyle = "None",
							duplicate = "Opened",
							global = "Opened",
							luadoc = "Opened",
							redefined = "Opened",
							strict = "Opened",
							strong = "Opened",
							["type-check"] = "Opened",
							unbalanced = "Opened",
							unused = "Opened",
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
		sourcekit = {
			on_attach = function(_, bufnr)
				vim.diagnostic.enable(false, { bufnr = bufnr })
			end,
			workspace = {
				didChangeWatchedFiles = {
					dynamicRegistration = true,
				},
			},
		},
	}
end

return M
