return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		size = 15,
		open_mapping = [[<C-\>]],
		hide_numbers = true,
		shade_filetypes = {},
		shade_terminals = true,
		shading_factor = 1,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		direction = "float",
		close_on_exit = true,
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)

		function _G.toggle_term_by_id(id)
			local Terminal = require("toggleterm.terminal").Terminal
			local term = require("toggleterm.terminal").get(id)
			if term then
				term:toggle()
			else
				local new_term = Terminal:new({ id = id, direction = "float", hidden = true })
				new_term:toggle()
			end
		end

		vim.keymap.set({ "n", "t" }, ";t", function()
			_G.toggle_term_by_id(1)
		end, { silent = true })
		vim.keymap.set({ "n", "t" }, ";g", function()
			_G.toggle_term_by_id(2)
		end, { silent = true })
	end,
}
