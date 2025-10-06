return {
	{
		"github/copilot.vim",
		config = function() end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		config = function()
			require("CopilotChat").setup({
				context = "buffer",

				mappings = {
					submit_prompt = {
						normal = "<CR>",
						insert = "<C-s>",
					},
				},
				window = {
					layout = "float",
					width = 0.8,
					height = 0.8,
					border = "rounded",
				},

				model = "gpt-4.1",
				temperature = 0.1,
				show_help = true,
				highlight_selection = true,
				auto_follow_cursor = true,
			})

			-- Fixed: Use correct parameter name for open function
			vim.keymap.set("n", "<leader>cc", function()
				require("CopilotChat").open()
			end, { noremap = true, silent = true })

			-- Additional useful keymaps
			vim.keymap.set("n", "<leader>cr", function()
				require("CopilotChat").reset()
			end, { noremap = true, silent = true, desc = "Reset CopilotChat" })
		end,
	},
}
