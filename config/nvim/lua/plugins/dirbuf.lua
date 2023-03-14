local M = {
	"elihunter173/dirbuf.nvim",
}

local cmd = {
	"Dirbuf",
	"DirbufSync",
	"DirbufQuit",
}

local keys = {
	{
		"<A-f>",
		vim.cmd.Dirbuf,
		desc = "Dirbuf",
	},
}

local config = function()
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("DirbufQuitShortcuts", { clear = true }),
		pattern = "dirbuf",
		callback = function()
			vim.keymap.set("n", "q", vim.cmd.DirbufQuit, { silent = true })
			vim.keymap.set("n", "<Esc>", vim.cmd.DirbufQuit, { silent = true })
		end,
	})
end

M.cmd = cmd
M.keys = keys
M.config = config

return M
