local M = {
	"AckslD/messages.nvim",
	cmd = "Msg",
	event = "VeryLazy",
}

local config = function()
	require("messages").setup({
		command_name = "Msg",
		prepare_buffer = function(opts)
			local buf = vim.api.nvim_create_buf(false, true)
			vim.keymap.set("n", "q", vim.cmd.quit, { buffer = buf })
			vim.keymap.set("n", "<Esc>", vim.cmd.quit, { buffer = buf })
			return vim.api.nvim_open_win(buf, true, opts)
		end,
	})

	Msg = require("messages.api").capture_thing
end

M.config = config

return M
