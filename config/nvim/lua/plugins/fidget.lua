local M = {
	"j-hui/fidget.nvim",
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
