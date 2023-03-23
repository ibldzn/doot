local M = {
	"sindrets/diffview.nvim",
}

local cmd = {
	"DiffviewOpen",
	"DiffviewClose",
	"DiffviewRefresh",
	"DiffviewFileHistory",
	"DiffviewFocusFiles",
	"DiffviewToggleFiles",
}

local keys = {
	{ "<leader>v", mode = { "n", "x" }, desc = "Diffview" },
	{ "<leader>vo", vim.cmd.DiffviewOpen, desc = "Open" },
	{ "<leader>vq", vim.cmd.DiffviewClose, desc = "Close" },
	{ "<leader>vr", vim.cmd.DiffviewRefresh, desc = "Refresh" },
	{ "<leader>vh", vim.cmd.DiffviewFileHistory, desc = "File history" },
	{ "<leader>vf", vim.cmd.DiffviewFocusFiles, desc = "Focus file panel" },
	{ "<leader>vt", vim.cmd.DiffviewToggleFiles, desc = "Toggle file panel" },
	{ "<leader>vH", ":DiffviewFileHistory ", desc = "File history" },

	{ "<leader>vH", "<cmd>'<,'>DiffviewFileHistory<CR>", mode = "x", desc = "File history" },
}

local config = function()
	local diffview = require("diffview")
	diffview.setup({
		view = {
			merge_tool = {
				layout = "diff3_mixed",
			},
		},
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("DiffviewQuitShortcuts", { clear = true }),
		pattern = "Diffview*",
		callback = function()
			vim.keymap.set("n", "q", vim.cmd.DiffviewClose, { silent = true })
			vim.keymap.set("n", "<Esc>", vim.cmd.DiffviewClose, { silent = true })
		end,
	})
end

M.cmd = cmd
M.keys = keys
M.config = config

return M
