local M = {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufRead", "BufWinEnter", "BufNewFile" },
	dependencies = {
		"windwp/nvim-ts-autotag",
		"nvim-treesitter/playground",
		"nvim-treesitter/nvim-treesitter-context",
		{ "JoosepAlviste/nvim-ts-context-commentstring", opts = {} },
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	build = ":TSUpdate",
}

local init = function()
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
end

local config = function()
	local wk = require("which-key")
	local shared = require("config.shared")
	local ts_config = require("nvim-treesitter.configs")
	local ts_context = require("treesitter-context")
	local filetypes = {
		"bash",
		"c",
		"cmake",
		"comment",
		"cpp",
		"css",
		"dockerfile",
		"gitcommit",
		"go",
		"gomod",
		"graphql",
		"html",
		"http",
		"java",
		"javascript",
		"json",
		"kotlin",
		"latex",
		"lua",
		"markdown",
		"markdown_inline",
		"meson",
		"nix",
		"php",
		"prisma",
		"proto",
		"python",
		"query",
		"rust",
		"sql",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"yaml",
		"zig",
	}

	local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
	parser_config.blade = {
		install_info = {
			url = "https://github.com/EmranMR/tree-sitter-blade",
			files = { "src/parser.c" },
			branch = "main",
		},
		filetype = "blade",
	}

	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		group = vim.api.nvim_create_augroup("BladeFiltypeRelated", { clear = true }),
		pattern = "*.blade.php",
		callback = function()
			vim.bo.filetype = "blade"
		end,
	})

	ts_config.setup({
		ensure_installed = filetypes,
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<CR>",
				scope_incremental = "<CR>",
				node_incremental = "<Tab>",
				node_decremental = "<S-Tab>",
			},
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		matchup = {
			enable = true,
		},
		playground = {
			enable = true,
		},
		autotag = {
			enable = true,
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["ac"] = { query = "@call.outer", desc = "around function call" },
					["ic"] = { query = "@call.inner", desc = "inner function call" },
					["al"] = { query = "@loop.outer", desc = "around loop" },
					["il"] = { query = "@loop.inner", desc = "inner loop" },
					["af"] = { query = "@function.outer", desc = "around function" },
					["if"] = { query = "@function.inner", desc = "inner function" },
					["aC"] = { query = "@conditional.outer", desc = "around conditional" },
					["iC"] = { query = "@conditional.inner", desc = "inner conditional" },
				},
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "<c-v>", -- blockwise
				},
			},
			lsp_interop = {
				enable = true,
				border = shared.window.border,
				peek_definition_code = {
					["<leader>k"] = "@function.outer",
					["<leader>K"] = "@class.outer",
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]f"] = { query = "@function.outer", desc = "Next method start" },
				},
				goto_next_end = {
					["]F"] = { query = "@function.outer", desc = "Next method end" },
				},
				goto_previous_start = {
					["[f"] = { query = "@function.outer", desc = "Previous method start" },
				},
				goto_previous_end = {
					["[F"] = { query = "@function.outer", desc = "Previous method end" },
				},
			},
		},
	})

	ts_context.setup({
		mode = "topline",
		truncate_side = "outer",
		max_lines = 2,
		categories = {
			default = {
				["if"] = false,
				["switch"] = false,
				["loop"] = false,
				["lambda"] = false,
			},
		},
	})

	wk.register({
		["<leader>t"] = {
			name = "Toggle",
			["t"] = { vim.cmd.TSPlaygroundToggle, "Treesitter playground" },
		},
	})
end

M.init = init
M.config = config

return M
