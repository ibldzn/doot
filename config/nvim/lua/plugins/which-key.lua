local M = {
	"folke/which-key.nvim",
}

local shared = require("config.shared")

local opts = {
	plugins = {
		spelling = {
			enabled = true,
			suggestions = 40,
		},
	},
	operators = {
		gc = "Comment",
		gb = "Block comment",
		ys = "Surround",
	},
	icons = {
		breadcrumb = "»",
		separator = "➜",
		group = "+",
	},
	window = {
		border = shared.window.border,
		position = "bottom",
		margin = { 2, 2, 2, 4 },
		padding = { 0, 0, 0, 0 },
		winblend = 0,
	},
	hidden = {
		"<silent>",
		"<cmd>",
		"<Cmd>",
		"<plug>",
		"<Plug>",
		"<CR>",
		"call",
		"lua",
		"^:",
		"^ ",
	},
	triggers_blacklist = {
		n = { "v", "<A-j>", "<A-S-j>", "<A-k>" },
		v = { "v", "<A-j>", "<A-S-j>", "<A-k>" },
		i = { "y" },
	},
}

local init = function()
	vim.opt.timeoutlen = 400
end

M.opts = opts
M.init = init

return M
