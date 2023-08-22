local M = {
	"j-hui/fidget.nvim",
	tag = "legacy",
}

local opts = {
	text = {
		spinner = "dots_negative",
		done = "",
		commenced = "",
		completed = "",
	},
	fmt = {
		stack_upwards = false,
	},
}

M.opts = opts

return M
