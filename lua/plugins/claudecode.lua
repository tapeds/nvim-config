return {
	"greggh/claude-code.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local claude_code = require("claude-code")

		claude_code.setup({
			window = {
				split_ratio = 0.3,
				position = "vertical",
			},
		})

		local function resize_claude_window()
			local ratio = 0.3
			local width = math.floor(vim.o.columns * ratio)
			vim.cmd("vertical resize " .. width)
		end

		local function get_claude_buffer()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(buf) then
					local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
					local name = vim.api.nvim_buf_get_name(buf)
					if buftype == "terminal" and name:match("claude") then
						return buf
					end
				end
			end
			return nil
		end

		local function get_claude_window()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
				local name = vim.api.nvim_buf_get_name(buf)
				if buftype == "terminal" and name:match("claude") then
					return win, buf
				end
			end
			return nil, nil
		end

		local function safe_toggle()
			local win, _ = get_claude_window()

			if win then
				vim.api.nvim_win_close(win, false)
				return
			end

			local existing_buf = get_claude_buffer()
			if existing_buf then
				vim.cmd("botright vsplit")
				resize_claude_window()
				vim.api.nvim_win_set_buf(0, existing_buf)
				return
			end

			claude_code.toggle()

			vim.schedule(resize_claude_window)
		end

		vim.keymap.set("n", "<C-,>", safe_toggle, { desc = "Toggle Claude Code" })
		vim.keymap.set("t", "<C-,>", safe_toggle, { desc = "Toggle Claude Code" })
	end,
}
