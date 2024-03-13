return {
	{
		"nvim-treesitter/nvim-treesitter",
		tag = "v0.9.1",
		dependencies = {
			{ "windwp/nvim-ts-autotag" },
		},
		opts = {
			highlight = { enable = true },
			autopairs = { enable = true },
			autotag = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"javascript",
				"typescript",
				"css",
				"gitignore",
				"graphql",
				"http",
				"json",
				"scss",
				"sql",
				"vim",
				"lua",
        'tsx',
			},
			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold" },
			},
		},
	},
}
