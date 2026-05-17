return {
	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")

				local function opts(desc)
					return {
						desc = "nvim-tree: " .. desc,
						buffer = bufnr,
						noremap = true,
						silent = true,
						nowait = true,
					}
				end

				api.config.mappings.default_on_attach(bufnr)
				vim.keymap.set("n", "t", api.node.open.tab, opts("Tab"))
			end,
			actions = {
				open_file = {
					quit_on_open = true,
				},
			},
			sort = {
				sorter = "case_sensitive",
			},
			update_focused_file = {
				enable = true,
			},
			view = {
				side = "right",
				width = 30,
				relativenumber = false,
			},
			renderer = {
				group_empty = true,
			},
			filters = {
				dotfiles = false,
			},
			git = {
				enable = true,
				ignore = false,
			},
		},
	},
	{
		"DaikyXendo/nvim-material-icon",
	},
}
