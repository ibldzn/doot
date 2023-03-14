local M = {
	"nvim-telescope/telescope.nvim",
	keys = { { "<leader>f", desc = "Find" } },
}

local telescope_dap = {
	"nvim-telescope/telescope-dap.nvim",
	config = function()
		local telescope = require("telescope")
		local wk = require("which-key")

		telescope.load_extension("dap")

		wk.register({
			["<leader>d"] = {
				name = "Debug",
				["s"] = { ":Telescope dap frames<CR>", "Stack frames" },
				["l"] = { ":Telescope dap list_breakpoints<CR>", "List breakpoints" },
			},
		})
	end,
}

local telescope_project = {
	"ahmedkhalf/project.nvim",
	config = function()
		local project = require("project_nvim")
		local telescope = require("telescope")
		local wk = require("which-key")

		project.setup({})

		telescope.load_extension("projects")

		wk.register({
			["<leader>f"] = {
				name = "Find",
				["p"] = { telescope.extensions.projects.projects, "Projects" },
			},
		})
	end,
}

local trouble = {
	"folke/trouble.nvim",
}

local dependencies = {
	telescope_dap,
	telescope_project,
	trouble,
}

local find_files = function(no_ignore)
	local telescope_builtin = require("telescope.builtin")
	local fd_cmd = {
		"fd",
		"--type",
		"file",
		"--hidden",
		"--exclude",
		".git",
	}

	telescope_builtin.find_files({
		find_command = fd_cmd,
		no_ignore = no_ignore,
	})
end

local config = function()
	local telescope = require("telescope")
	local telescope_builtin = require("telescope.builtin")
	local trouble = require("trouble.providers.telescope")
	local wk = require("which-key")
	local util = require("util")

	telescope.setup({
		defaults = {
			vimgrep_arguments = {
				"rg",
				"--hidden",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
			},
			mappings = {
				i = { ["<C-t>"] = trouble.open_with_trouble },
				n = { ["<C-t>"] = trouble.open_with_trouble },
			},
			sorting_strategy = "ascending",
			layout_strategy = "horizontal",
			layout_config = {
				horizontal = {
					prompt_position = "top",
					width = {
						padding = 8,
					},
					height = {
						padding = 3,
					},
					preview_cutoff = 120,
				},
			},
			borderchars = {
				prompt = {
					"█",
					"█",
					"█",
					"█",
					"█",
					"█",
					"",
					"",
				},
				results = {
					"█",
					"█",
					"█",
					"█",
					"",
					"",
					"█",
					"█",
				},
				preview = {
					"█",
					"█",
					"█",
					"▐",
					"▐",
					"",
					"",
					"▐",
				},
			},
			prompt_prefix = " ",
			selection_caret = " ",
		},
	})

	wk.register({
		["<leader>"] = {
			["f"] = {
				name = "Find",
				["f"] = { util.wrap(find_files, false), "Files" },
				["a"] = { util.wrap(find_files, true), "Ignored files" },
				["o"] = { telescope_builtin.oldfiles, "Old files" },
				["b"] = { telescope_builtin.buffers, "Buffers" },
				["h"] = { telescope_builtin.help_tags, "Help" },
				["c"] = { telescope_builtin.commands, "Commands" },
				["m"] = { telescope_builtin.keymaps, "Key mappings" },
				["i"] = { telescope_builtin.highlights, "Highlight groups" },
				["g"] = { telescope_builtin.git_status, "Git status" },
				["d"] = {
					util.wrap(telescope_builtin.diagnostics, { bufnr = 0 }),
					"Document diagnostics",
				},
				["D"] = { telescope_builtin.diagnostics, "Workspace diagnostics" },
				["s"] = { telescope_builtin.lsp_document_symbols, "LSP document symbols" },
				["S"] = { telescope_builtin.lsp_workspace_symbols, "LSP workspace symbols" },
				["w"] = { telescope_builtin.live_grep, "Live grep" },
				["W"] = { telescope_builtin.grep_string, "Grep string under cursor" },
				["r"] = { telescope_builtin.resume, "Resume" },
				["z"] = { telescope_builtin.current_buffer_fuzzy_find, "Fuzzy find current buffer" },
			},
		},
	})
end

M.config = config
M.dependencies = dependencies

return M
