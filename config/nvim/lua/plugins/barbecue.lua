local M = {
	"utilyre/barbecue.nvim",
	event = { "BufRead", "BufWinEnter", "BufNewFile" },
	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons", -- optional dependency
	},
	opts = {
		show_modified = true,
	},
}

return M
