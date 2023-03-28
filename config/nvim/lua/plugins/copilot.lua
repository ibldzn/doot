local M = {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
}

local config = function()
	local copilot = require("copilot")

	copilot.setup({
		panel = {
			layout = {
				position = "right",
				ratio = 0.4,
			},
		},
		suggestion = {
			auto_trigger = true,
			keymap = {
				accept = "<Tab>",
				dismiss = "<C-q>",
			},
		},
	})

	vim.keymap.set("i", "<Tab>", function()
		local copilot_suggestion = require("copilot.suggestion")
		if copilot_suggestion.is_visible() then
			copilot_suggestion.accept()
		else
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
		end
	end, {
		silent = true,
	})
end

M.config = config

return M
