local M = {}

local setup = function()
	local wk_ok, wk = pcall(require, "which-key")
	local map = vim.keymap.set

	if not wk_ok then
		vim.notify("which-key isn't installed", vim.log.levels.ERROR)
		return
	end

	for _, mode in ipairs({ "n", "v" }) do
		map(mode, "j", "gj", { noremap = true })
		map(mode, "gj", "j", { noremap = true })
		map(mode, "k", "gk", { noremap = true })
		map(mode, "gk", "k", { noremap = true })
	end

	map("n", "dd", function()
		return vim.api.nvim_get_current_line():match("^%s*$") and '"_dd' or "dd"
	end, { noremap = true, expr = true, desc = "Smart dd" })

	map("c", "<CR>", function()
		local cmdtype = vim.fn.getcmdtype()
		if cmdtype == "/" or cmdtype == "?" then
			return "<CR>zzzv"
		else
			return "<CR>"
		end
	end, { noremap = true, expr = true, desc = "Center first search result" })

	wk.register({
		["c"] = { '"_c', "Delete and enter insert mode" },
		["C"] = { '"_C', "Delete until end of line and enter insert mode" },
		["S"] = {
			name = "Split",
			["H"] = { "<C-w>t<C-w>K", "Vertical to horizontal" },
			["V"] = { "<C-w>t<C-w>H", "Horizontal to vertical" },
			["h"] = { vim.cmd.split, "Horizontal" },
			["v"] = { vim.cmd.vsplit, "Vertical" },
		},
		["<Tab>"] = { vim.cmd.bnext, "Next buffer" },
		["<S-Tab>"] = { vim.cmd.bprev, "Previous buffer" },
		["<C-s>"] = { vim.cmd.write, "Save file" },
		["<C-q>"] = { "<C-w>q", "Close window" },
		["<C-d>"] = { "<C-d>zz", "Scroll down" },
		["<C-u>"] = { "<C-u>zz", "Scroll up" },
		["n"] = { "nzzzv", "Next search occurence" },
		["N"] = { "Nzzzv", "Next search occurence" },
		["<Esc>"] = { vim.cmd.nohl, "Clear search highlights" },
		["<leader>"] = {
			["S"] = {
				[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
				"Replace word under cursor in current buffer",
			},
			["q"] = { ":bd!<CR>", "Delete current buffer" },
			["Q"] = { ":%bd|e#|bd#<CR>", "Delete all buffer except current one" },
			["<leader>"] = { "<C-^>", "Goto previous buffer" },
			["t"] = {
				name = "Toggle",
				["f"] = {
					function()
						vim.g.format_on_save = not vim.g.format_on_save
						vim.notify(vim.g.format_on_save and "Formatting enabled" or "Formatting disabled")
					end,
					"Formatting",
				},
				["s"] = { ":set spell!<CR>", "Spelling" },
				["w"] = { ":set wrap!<CR>", "Wrapping" },
			},
		},
		["gx"] = {
			function()
				-- Basic URL opener
				local url = string.match(vim.fn.expand("<cfile>"), "https?://[%w-_%.%?%.:/%+=&]+[^ >\"',;`]*")
				if url ~= nil then
					if vim.fn.has("mac") == 1 then
						vim.fn.jobstart({ "open", url }, { detach = true })
					elseif vim.fn.has("unix") == 1 then
						vim.fn.jobstart({ "xdg-open", url }, { detach = true })
					else
						vim.notify("url_opener doesn't work on this OS", vim.log.levels.ERROR)
					end
				else
					vim.notify("No URL under the cursor", vim.log.levels.ERROR)
				end
			end,
			"Open URL under the cursor",
		},
	})

	wk.register({
		["<C-s>"] = { "<Esc>:w<CR>a", "Save file" },

		["<C-r>"] = { "<C-r><C-o>", 'Insert register "literally"' },
		["<C-v>"] = { "<C-r><C-o>+", "Paste system clipboard" },

		["<C-a>"] = { "<Esc>^i", "Move to the beginning of the line" },
		["<C-e>"] = { "<End>", "Move to the end of the line" },

		["<C-h>"] = { "<Left>", "Move left" },
		["<C-l>"] = { "<Right>", "Move right" },
		["<C-j>"] = { "<Down>", "Move down" },
		["<C-k>"] = { "<Up>", "Move up" },
	}, { mode = "i" })

	wk.register({
		["<A-u>"] = { "<Esc>:m .-2<CR>==gi", "Move current line up" },
		["<A-d>"] = { "<Esc>:m .+1<CR>==gi", "Move current line down" },
	}, { mode = "i" })

	wk.register({
		["<A-u>"] = { ":m .-2<CR>==", "Move current line up" },
		["<A-d>"] = { ":m .+1<CR>==", "Move current line down" },
	}, { mode = "n" })

	wk.register({
		["y"] = { "myy`y", "Yank without moving cursor" },
		["c"] = { '"_c', "Delete and enter insert mode" },
		["C"] = { '"_C', "Delete until end of line and enter insert mode" },
		["<C-c>"] = { '"+y', "Copy to system clipboard" },
		["<A-u>"] = { ":m'<-2<CR>gv=gv", "Move current line up" },
		["<A-d>"] = { ":m'>+1<CR>gv=gv", "Move current line down" },
		["<"] = { "<gv", "Un-indent line(s)" },
		[">"] = { ">gv", "Indent line(s)" },
	}, { mode = "v" })

	wk.register({
		-- Do not override register after (p)asting in visual mode, see `:h v_P`
		["p"] = { "P", "Paste" },
	}, { mode = "x" })

	wk.register({
		["<C-x>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "Escape terminal mode" },
	}, { mode = "t" })
end

M.setup = setup

return M
