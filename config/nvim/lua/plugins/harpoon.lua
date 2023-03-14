local M = {
	"ThePrimeagen/harpoon",
	dependencies = "nvim-lua/plenary.nvim",
}

local keys = {
	{
		"<A-1>",
		function()
			require("harpoon.ui").nav_file(1)
		end,
		desc = "Harpoon File 1",
	},
	{
		"<A-2>",
		function()
			require("harpoon.ui").nav_file(2)
		end,
		desc = "Harpoon File 2",
	},
	{
		"<A-3>",
		function()
			require("harpoon.ui").nav_file(3)
		end,
		desc = "Harpoon File 3",
	},
	{
		"<A-4>",
		function()
			require("harpoon.ui").nav_file(4)
		end,
		desc = "Harpoon File 4",
	},
	{
		"<A-[>",
		function()
			require("harpoon.ui").nav_prev()
		end,
		desc = "Harpoon Next File",
	},
	{
		"<A-]>",
		function()
			require("harpoon.ui").nav_next()
		end,
		desc = "Harpoon Prev File",
	},
	{
		"<leader>h",
		desc = "Harpoon",
	},
}

local config = function()
	local harpoon = require("harpoon")
	local harpoon_mark = require("harpoon.mark")
	local harpoon_ui = require("harpoon.ui")
	local shared = require("config.shared")
	local util = require("util")
	local wk = require("which-key")

	---@diagnostic disable-next-line: redundant-parameter
	harpoon.setup({
		menu = {
			borderchars = shared.window.plenary_border,
		},
	})

	wk.register({
		["<leader>h"] = {
			name = "Harpoon",
			["a"] = { util.wrap(harpoon_mark.add_file), "Add file" },
			["e"] = { util.wrap(harpoon_ui.toggle_quick_menu), "Toggle UI" },
		},
	})
end

M.keys = keys
M.config = config

return M
