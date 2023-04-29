local M = {
	"uga-rosa/ccc.nvim",
}

local shared = require("config.shared")

local cmd = {
	"CccConvert",
	"CccHighlighterDisable",
	"CccHighlighterEnable",
	"CccHighlighterToggle",
	"CccPick",
}

local keys = {
	{
		"<leader>c",
		desc = "Ccc",
	},
	{
		"<leader>ct",
		vim.cmd.CccHighlighterToggle,
		desc = "Toggle",
	},
	{
		"<leader>cp",
		vim.cmd.CccPick,
		desc = "Pick",
	},
	{
		"<leader>cc",
		vim.cmd.CccConvert,
		desc = "Convert",
	},
}

local opts = {
	highlighter = {
		excludes = {
			"NvimTree",
			"alpha",
			"dapui_breakpoints",
			"dapui_hover",
			"dapui_repl",
			"dapui_scopes",
			"dapui_stacks",
			"help",
			"lazy",
			"lspinfo",
			"mason",
			"packer",
		},
	},
	win_opts = {
		border = shared.window.border,
	},
}

M.cmd = cmd
M.keys = keys
M.opts = opts

return M
