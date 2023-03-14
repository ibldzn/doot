local M = {
	"mattn/emmet-vim",
	ft = {
		"css",
		"html",
		"javascriptreact",
		"less",
		"sass",
		"scss",
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
		pattern = {
			"css",
			"html",
			"javascriptreact",
			"less",
			"sass",
			"scss",
			"typescriptreact",
		},
		command = "EmmetInstall",
	})
end

M.init = init
M.config = config

return M
