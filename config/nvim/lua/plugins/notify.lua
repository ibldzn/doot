local M = {
	"rcarriga/nvim-notify",
	event = "VeryLazy",
}

local keys = {
	{ "<leader>N", desc = "Notification" },
}

local config = function()
	local notify = require("notify")
	local wk = require("which-key")

	vim.notify = notify

	wk.register({
		["<leader>N"] = {
			name = "Notification",
			["d"] = { notify.dismiss, "Dismiss" },
			["h"] = { notify._print_history, "History" },
		},
	})
end

M.keys = keys
M.config = config

return M
