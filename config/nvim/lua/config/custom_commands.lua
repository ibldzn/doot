local M = {}

local setup = function()
	local add_command = vim.api.nvim_create_user_command
	add_command("CDC", "cd %:p:h", { desc = "Change directory to current file" })
	add_command("CDP", "cd -", { desc = "Change to previous directory" })
	add_command("EditConfig", "e $MYVIMRC | cd %:p:h", { desc = "Edit neovim configs" })
	add_command("RemoveTrailingWhitespaces", "%s/\\s\\+$//e", { desc = "Remove trailing whitespaces" })
end

M.setup = setup

return M
