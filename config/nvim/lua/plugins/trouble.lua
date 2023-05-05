local M = {
	"folke/trouble.nvim",
}

local todo_comments = {
	"folke/todo-comments.nvim",
	opts = {
		signs = false,
		keywords = {
			FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
			STOPSHIP = { icon = " ", color = "error" },
			HACK = { icon = " ", color = "warning", alt = { "XXX" } },
			TODO = { icon = " ", color = "info", alt = { "todo!" } },
			PERF = { icon = "󰅒 ", color = "info" },
			NOTE = { icon = "󰍨 ", color = "hint", alt = { "INFO" } },
		},
		merge_keywords = false,
		highlight = {
			before = "",
			keyword = "fg",
			after = "",
			pattern = [[.*<(KEYWORDS)]], -- pattern or table of patterns, used for highlightng (vim regex)
			comments_only = true, -- uses treesitter to match keywords in comments only
		},
		colors = {
			error = { "DiagnosticError" },
			warning = { "DiagnosticWarn" },
			info = { "Todo" },
			hint = { "DiagnosticHint" },
			default = { "Identifier", "#7C3AED" },
		},
		search = {
			pattern = [[\b(KEYWORDS)]], -- ripgrep regex
		},
	},
}

local icons = { "nvim-tree/nvim-web-devicons" }

local dependencies = {
	icons,
	todo_comments,
}

local keys = {
	{ "<A-LeftMouse>", "<LeftMouse><cmd>Trouble lsp_type_definitions<CR>", desc = "LSP type definition" },
	{ "<leader>tr", "<cmd>TroubleToggle<CR>", desc = "Toggle list UI" },
	{ "<leader>ld", "<cmd>Trouble document_diagnostics<CR>", desc = "List document diagnostics" },
	{ "<leader>lD", "<cmd>Trouble workspace_diagnostics<CR>", desc = "List workspace diagnostics" },
	{ "<leader>lt", "<cmd>Trouble todo<CR>", desc = "List TODOs" },
}

local opts = {
	indent_lines = false,
	position = "bottom",
	width = 60,
	icons = false,
	fold_open = "",
	fold_closed = "",
	auto_jump = { -- TODO: fix
		-- "lsp_definitions",
		-- "lsp_type_definitions",
	},
	signs = {
		other = "",
		error = "",
		warning = "",
		information = "",
		hint = "",
	},
}

M.keys = keys
M.opts = opts
M.dependencies = dependencies

return M
