local M = {
	"mrjones2014/smart-splits.nvim",
	event = "WinNew",
	config = true,
}

local winshift = {
	"sindrets/winshift.nvim",
	config = true,
	keys = { { "<C-w>W", "<cmd>WinShift<CR>", desc = "Winshift" } },
}

local dependencies = {
	winshift,
}

local keys = {
	{ "<C-h>", "<cmd>SmartCursorMoveLeft<CR>", desc = "Move to left split" },
	{ "<C-j>", "<cmd>SmartCursorMoveDown<CR>", desc = "Move to below split" },
	{ "<C-k>", "<cmd>SmartCursorMoveUp<CR>", desc = "Move to above split" },
	{ "<C-l>", "<cmd>SmartCursorMoveRight<CR>", desc = "Move to right split" },

	{ "<A-h>", "<cmd>SmartResizeLeft<CR>", desc = "Resize left split" },
	{ "<A-j>", "<cmd>SmartResizeDown<CR>", desc = "Resize below split" },
	{ "<A-k>", "<cmd>SmartResizeUp<CR>", desc = "Resize above split" },
	{ "<A-l>", "<cmd>SmartResizeRight<CR>", desc = "Resize right split" },
}

M.keys = keys
M.dependencies = dependencies

return M
