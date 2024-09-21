return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
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
		})

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

		vim.api.nvim_set_keymap("n", ";t", "<cmd>lua toggle_term_by_id(1)<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("t", ";t", "<cmd>lua toggle_term_by_id(1)<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", ";g", "<cmd>lua toggle_term_by_id(2)<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("t", ";g", "<cmd>lua toggle_term_by_id(2)<CR>", { noremap = true, silent = true })
	end,
}
