local M = {
	"windwp/nvim-spectre",
	keys = { { "<leader>s", desc = "Search/Replace" } },
}

local opts = {
	live_update = true,
	mapping = {
		["toggle_regex"] = {
			map = "tr",
			cmd = "<cmd>lua require('spectre').change_options('noregex')<CR>",
			desc = "toggle regex",
		},
	},
	find_engine = {
		["rg"] = {
			cmd = "rg",
			args = {
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
			},
			options = {
				["ignore-case"] = {
					value = "--ignore-case",
					icon = "[I]",
					desc = "ignore case",
				},
				["hidden"] = {
					value = "--hidden",
					desc = "hidden file",
					icon = "[H]",
				},
				["noregex"] = {
					value = "-F",
					desc = "disable regex",
					icon = "[R]",
				},
			},
		},
	},
}

local config = function()
	local spectre = require("spectre")
	local wk = require("which-key")
	local util = require("util")

	wk.register({
		["<leader>"] = {
			["s"] = {
				name = "Search/Replace",
				["p"] = { spectre.open, "Project" },
				["f"] = { spectre.open_file_search, "File" },
			},
		},
	})

	wk.register({
		["<leader>"] = {
			["s"] = {
				name = "Search/Replace",
				["p"] = { spectre.open_visual, "Project" },
				["f"] = { util.wrap(spectre.open_visual, { path = vim.fn.expand("%") }), "File" },
			},
		},
	}, {
		mode = "v",
	})
end

M.opts = opts
M.config = config

return M
