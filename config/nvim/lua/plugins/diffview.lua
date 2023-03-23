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
	{ "<leader>vo", "<cmd>DiffviewOpen<CR>", desc = "Open" },
	{ "<leader>vq", "<cmd>DiffviewClose<CR>", desc = "Close" },
	{ "<leader>vr", "<cmd>DiffviewRefresh<CR>", desc = "Refresh" },
	{ "<leader>vh", "<cmd>DiffviewFileHistory<CR>", desc = "File history" },
	{ "<leader>vf", "<cmd>DiffviewFocusFiles<CR>", desc = "Focus file panel" },
	{ "<leader>vt", "<cmd>DiffviewToggleFiles<CR>", desc = "Toggle file panel" },
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
