local M = {
	"kylechui/nvim-surround",
}

local keys = {
	{ "ys", mode = "n" },
	{ "ds", mode = "n" },
	{ "cs", mode = "n" },
	{ "S", mode = "x" },
}

local config = function()
	local surround = require("nvim-surround")

	---@diagnostic disable-next-line: redundant-parameter
	surround.setup({
		keymaps = {
			insert = "ys",
			insert_line = "yss",
			visual = "S",
			delete = "ds",
			change = "cs",
		},
		highlight = { -- Highlight before inserting/changing surrounds
			duration = 0,
		},
		move_cursor = false,
	})

	vim.keymap.del("i", "ys")
	vim.keymap.del("i", "yss")
end

M.keys = keys
M.config = config

return M
