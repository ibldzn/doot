local M = {
	"nvim-neotest/neotest",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-neotest/neotest-go",
		"rouge8/neotest-rust",
	},
}

local keys = {
	{ "<leader>n", desc = "Neotest" },
}

local config = function()
	local wk = require("which-key")
	local util = require("util")
	local neotest = require("neotest")

	local augroup = vim.api.nvim_create_augroup
	local autocmd = vim.api.nvim_create_autocmd

	autocmd("FileType", {
		group = augroup("NeotestConfig", { clear = true }),
		pattern = "neotest-output-panel",
		callback = util.wrap(vim.cmd.norm, "G"),
	})

	-- get neotest namespace (api call creates or returns namespace)
	local neotest_ns = vim.api.nvim_create_namespace("neotest")

	vim.diagnostic.config({
		virtual_text = {
			format = function(diagnostic)
				local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
				return message
			end,
		},
	}, neotest_ns)

	neotest.setup({
		quickfix = {
			open = false,
		},
		output = {
			open_on_run = false,
		},
		icons = {
			running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
		},
		strategies = {
			integrated = {
				width = 180,
			},
		},
		adapters = {
			require("neotest-go"),
			require("neotest-rust"),
		},
	})

	wk.register({
		["<leader>n"] = {
			name = "Neotest",
			["r"] = {
				function()
					neotest.run.run({ vim.fn.expand("%:p"), env = util.get_env() })
				end,
				"Run",
			},
			["s"] = {
				function()
					for _, adapter_id in ipairs(neotest.state.adapter_ids()) do
						neotest.run.run({ suite = true, adapter = adapter_id, env = util.get_env() })
					end
				end,
				"Suite",
			},
			["t"] = { neotest.run.stop, "Stop" },
			["n"] = {
				function()
					neotest.run.run({ env = util.get_env() })
				end,
				"Nearest",
			},
			["d"] = {
				function()
					neotest.run.run({ strategy = "dap", env = util.get_env() })
				end,
				"Debug",
			},
			["l"] = { neotest.run.run_last, "Run last" },
			["D"] = { util.wrap(neotest.run.run_last, { strategy = "dap" }), "Run last (Debug)" },
			["a"] = { neotest.run.attach, "Attach" },

			["o"] = {
				function()
					neotest.output.open({ silent = true, enter = true, last_run = true })
				end,
				"Open output (last run)",
			},
			["i"] = {
				function()
					neotest.output.open({ silent = true, enter = true })
				end,
				"Open output",
			},
			["O"] = {
				function()
					neotest.output.open({ silent = true, enter = true, short = true })
				end,
				"Open output (short)",
			},

			["p"] = { neotest.summary.toggle, "Toggle summary" },
			["m"] = { neotest.summary.run_marked, "Run marked" },
			["e"] = { neotest.output_panel.toggle, "Toggle output panel" },
		},
		["]n"] = { util.wrap(neotest.jump.next, { status = "failed" }), "Next failed test" },
		["[n"] = { util.wrap(neotest.jump.prev, { status = "failed" }), "Prev failed test" },
	})
end

M.keys = keys
M.config = config

return M
