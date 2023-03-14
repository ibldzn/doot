local M = {
	"rcarriga/nvim-notify",
	event = "VeryLazy",
}

local keys = {
	{ "<leader>n", desc = "Notification" },
}

local config = function()
	local notify = require("notify")
	local wk = require("which-key")

	vim.notify = function(msg, ...)
		if not msg:find("No information available") then
			return notify(msg, ...)
		end
	end

	wk.register({
		["<leader>n"] = {
			name = "Notification",
			["d"] = { notify.dismiss, "Dismiss" },
			["h"] = { notify._print_history, "History" },
		},
	})
end

M.keys = keys
M.config = config

return M
