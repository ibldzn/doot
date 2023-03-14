local M = {
	"windwp/nvim-autopairs",
	dependencies = "hrsh7th/nvim-cmp",
	event = "InsertEnter",
}

local config = function()
	local autopairs = require("nvim-autopairs")
	local cmp = require("cmp")

	autopairs.setup({})

	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

M.config = config

return M
