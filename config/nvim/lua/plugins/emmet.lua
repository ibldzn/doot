local M = {
	"mattn/emmet-vim",
	ft = {
		"css",
		"html",
		"javascript",
		"javascriptreact",
		"less",
		"sass",
		"scss",
		"typescript",
		"typescriptreact",
	},
}

local init = function()
	vim.g.user_emmet_leader_key = ","
	vim.g.user_emmet_install_global = 0
end

local config = function()
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("Emmet", { clear = true }),
		pattern = M.ft,
		command = "EmmetInstall",
	})
end

M.init = init
M.config = config

return M
