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
}

local config = function()
	local ccc = require("ccc")
	local wk = require("which-key")

	ccc.setup({
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
				"lspinfo",
				"mason",
				"packer",
			},
		},
		win_opts = {
			border = shared.window.border,
		},
	})

	vim.defer_fn(vim.cmd.CccHighlighterEnable, 0)

	wk.register({
		["<leader>c"] = {
			name = "Ccc",
			["t"] = { vim.cmd.CccHighlighterToggle, "Toggle" },
			["p"] = { vim.cmd.CccPick, "Pick" },
			["c"] = { vim.cmd.CccConvert, "Convert" },
		},
	})
end

M.cmd = cmd
M.keys = keys
M.config = config

return M
