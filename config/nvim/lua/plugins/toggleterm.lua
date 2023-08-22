local M = {
	"akinsho/toggleterm.nvim",
}

local toggle_lazygit = function()
	local Terminal = require("toggleterm.terminal").Terminal
	local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
	lazygit:toggle(nil, "tab")
end

local keys = {
	{ "<C-t>", "<cmd>ToggleTerm direction=float<CR>", mode = { "n", "t" }, desc = "Toggle terminal" },
	{ "<leader>gg", toggle_lazygit, desc = "Toggle Lazygit" },
}

local opts = {
	shade_terminals = false,
	float_opts = {
		border = "shadow",
		winblend = 0,
	},
	winbar = {
		enabled = true,
	},
}

M.keys = keys
M.opts = opts

return M
