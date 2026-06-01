return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		size = function(term)
			if term.direction == "horizontal" then
				return math.floor(vim.o.lines * 0.3)
			end
			return 15
		end,
		open_mapping = [[<C-\>]],
		hide_numbers = true,
		shade_terminals = true,
		shading_factor = 1,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		direction = "horizontal",
		close_on_exit = true,
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)
		local Terminal = require("toggleterm.terminal").Terminal
		local terms = require("toggleterm.terminal")
		local next_id = 1
		local last_focused_id = nil
		local suspend_tracking = false

		local function find_term(id)
			for _, term in ipairs(terms.get_all()) do
				if term.id == id then
					return term
				end
			end
			return nil
		end

		local function cur_term_id()
			local buf = vim.api.nvim_get_current_buf()
			for _, term in ipairs(terms.get_all()) do
				if term.bufnr == buf then
					return term.id
				end
			end
			return nil
		end

		-- remember the terminal we were last focused in, but ignore the
		-- transient focus changes that happen while terminals are being toggled
		vim.api.nvim_create_autocmd({ "TermEnter", "BufEnter" }, {
			callback = function()
				if suspend_tracking then
					return
				end
				local id = cur_term_id()
				if id then
					last_focused_id = id
				end
			end,
		})

		local function new_terminal()
			-- bring back any hidden/closed terminals so they sit side by side
			for _, term in ipairs(terms.get_all()) do
				if not term:is_open() then
					term:open()
				end
			end
			next_id = next_id + 1
			Terminal:new({
				id = next_id,
				direction = "horizontal",
			}):open()
		end

		local function exit_terminal_mode()
			if vim.bo.buftype == "terminal" then
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
			end
		end

		-- kill (shut down) the terminal the cursor is in
		local function kill_current_terminal()
			local id = cur_term_id()
			if not id then
				return
			end
			local t = find_term(id)
			if t then
				suspend_tracking = true
				t:shutdown()
				if last_focused_id == id then
					last_focused_id = nil
				end
				vim.schedule(function()
					suspend_tracking = false
				end)
			end
		end

		vim.keymap.set({ "n", "t" }, ";t", function()
			local all = terms.get_all()
			if #all == 0 then
				new_terminal()
				return
			end
			local any_open = false
			for _, term in ipairs(all) do
				if term:is_open() then
					any_open = true
					break
				end
			end
			if any_open then
				-- capture the terminal we're actually in BEFORE hiding,
				-- then suspend tracking so the teardown doesn't clobber it
				last_focused_id = cur_term_id() or last_focused_id
				suspend_tracking = true
				vim.cmd("ToggleTermToggleAll")
				vim.schedule(function()
					suspend_tracking = false
				end)
			else
				local target = last_focused_id
				suspend_tracking = true
				-- reopen in natural order so the layout is preserved
				vim.cmd("ToggleTermToggleAll")
				-- then re-focus the terminal we were last in
				vim.schedule(function()
					local t = find_term(target)
					if t and t:is_open() then
						t:focus()
						vim.schedule(function()
							vim.cmd("startinsert")
						end)
					end
					suspend_tracking = false
				end)
			end
		end, {
			silent = true,
			desc = "Toggle all terminals (focus last, keep layout)",
		})

		vim.keymap.set({ "n", "t" }, ";n", function()
			new_terminal()
		end, {
			silent = true,
			desc = "New horizontal terminal",
		})

		vim.keymap.set({ "n", "t" }, ";x", function()
			kill_current_terminal()
		end, {
			silent = true,
			desc = "Kill current terminal",
		})

		vim.keymap.set("t", "<Esc>", function()
			exit_terminal_mode()
		end, {
			silent = true,
			desc = "Exit terminal mode",
		})
	end,
}
