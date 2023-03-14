local M = {
	"sindrets/diffview.nvim",
	keys = { { "<leader>v", mode = { "n", "x" }, desc = "Diffview" } },
}

local config = function()
	local diffview = require("diffview")
	local wk = require("which-key")

	diffview.setup({
		view = {
			merge_tool = {
				layout = "diff3_mixed",
			},
		},
	})

	wk.register({
		["<leader>v"] = {
			name = "Diffview",
			["o"] = { vim.cmd.DiffviewOpen, "Open" },
			["q"] = { vim.cmd.DiffviewClose, "Close" },
			["r"] = { vim.cmd.DiffviewRefresh, "Refresh" },
			["h"] = { vim.cmd.DiffviewFileHistory, "File history" },
			["f"] = { vim.cmd.DiffviewFocusFiles, "Focus file panel" },
			["t"] = { vim.cmd.DiffviewToggleFiles, "Toggle file panel" },
			["H"] = { ":DiffviewFileHistory ", "File history" },
		},
	})

	wk.register({
		["<leader>v"] = {
			name = "Diffview",
			["H"] = { ":'<,'>DiffviewFileHistory<CR>", "File history" },
		},
	}, { mode = "x" })
end

M.config = config

return M
