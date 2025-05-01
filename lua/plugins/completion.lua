return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
				}),
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				formatting = {
					format = function(entry, vim_item)
						local max_abbr_width = 35
						if vim_item.abbr and #vim_item.abbr > max_abbr_width then
							vim_item.abbr = string.sub(vim_item.abbr, 1, max_abbr_width) .. "..."
						end

						local max_menu_width = 15
						if vim_item.menu and #vim_item.menu > max_menu_width then
							vim_item.menu = string.sub(vim_item.menu, 1, max_menu_width) .. "..."
						end

						vim_item.menu = vim_item.menu
							or ({
								nvim_lsp = "[LSP]",
								luasnip = "[Snippet]",
								buffer = "[Buffer]",
							})[entry.source.name]
						return vim_item
					end,
				},
			})
		end,
	},
}
