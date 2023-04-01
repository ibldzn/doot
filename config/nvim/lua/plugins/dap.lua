local M = {
	"mfussenegger/nvim-dap",
	keys = { { "<leader>d", desc = "Debug" } },
}

local nvim_dap_ui = {
	"rcarriga/nvim-dap-ui",
	name = "dapui",
	opts = {
		mappings = {
			expand = { "<CR>", "<Tab>" },
		},
		icons = { expanded = "▾", collapsed = "▸" },
		layouts = {
			{
				elements = {
					{ id = "scopes", size = 0.45 },
					{ id = "breakpoints", size = 0.3 },
					{ id = "stacks", size = 0.25 },
				},
				size = 0.25,
				position = "left",
			},
			{
				elements = {
					{ id = "console", size = 0.5 },
					{ id = "repl", size = 0.5 },
				},
				size = 0.25,
				position = "bottom",
			},
		},
		floating = {
			max_height = nil,
			max_width = nil,
			mappings = {
				close = { "q", "<Esc>" },
			},
		},
		controls = {
			enabled = true,
			element = "console",
			icons = {
				pause = "",
				play = "",
				step_into = "",
				step_over = "",
				step_out = "",
				step_back = "",
				run_last = "",
				terminate = "",
			},
		},
		windows = { indent = 1 },
		render = {
			max_type_length = nil,
			max_value_lines = nil,
		},
	},
}

local nvim_dap_virtual_text = {
	"theHamsta/nvim-dap-virtual-text",
	config = true,
}

local nvim_dap_go = {
	"leoluz/nvim-dap-go",
	name = "dap-go",
	config = true,
}

local nvim_dap_python = {
	"mfussenegger/nvim-dap-python",
	name = "dap-python",
	config = function()
		require("dap-python").setup(nil, { include_configs = true })
	end,
}

local dependencies = {
	nvim_dap_ui,
	nvim_dap_virtual_text,
	nvim_dap_go,
	nvim_dap_python,
}

local setup_adapters = function()
	local dap = require("dap")

	dap.adapters.lldb = {
		type = "executable",
		command = "lldb-vscode",
		name = "lldb",
	}

	dap.adapters.node2 = {
		type = "executable",
		command = "node",
		args = { os.getenv("XDG_DATA_HOME") .. "/vscode-node-debug2/out/src/nodeDebug.js" },
	}
end

local setup_configurations = function()
	local dap = require("dap")

	dap.configurations.cpp = {
		{
			name = "Launch",
			type = "lldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},
			env = function()
				local variables = {}
				for k, v in pairs(vim.fn.environ()) do
					table.insert(variables, string.format("%s=%s", k, v))
				end
				return variables
			end,
		},
	}
	dap.configurations.c = dap.configurations.cpp

	dap.configurations.javascript = {
		{
			name = "Launch",
			type = "node2",
			request = "launch",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			console = "integratedTerminal",
		},
		{
			-- For this to work you need to make sure the node process is started with the `--inspect` flag.
			name = "Attach to process",
			type = "node2",
			request = "attach",
			processId = require("dap.utils").pick_process,
		},
	}
end

local run_dap = function(prompt)
	local ft = vim.bo.filetype
	if ft == "" then
		vim.notify("Filetype option is required to determine which dap config to use", vim.log.levels.ERROR)
		return
	end

	local dap = require("dap")

	local configs = dap.configurations[ft]
	if configs == nil then
		vim.notify(ft .. " has no dap config", vim.log.levels.ERROR)
		return
	end

	vim.ui.select(configs, {
		prompt = "Select config to run: ",
		format_item = function(cfg)
			return cfg.name
		end,
	}, function(cfg)
		if prompt then
			cfg.args = vim.split(vim.fn.input("args: "), " ")
		end
		dap.run(cfg)
	end)
end

local debuggables = function(prompt)
	local filetype = vim.bo.filetype
	if filetype == "rust" then
		require("plugins.dap.rust").debuggables(prompt)
	else
		run_dap(prompt)
	end
end

local config = function()
	local dap = require("dap")
	local dap_ui = require("dapui")
	local wk = require("which-key")
	local util = require("util")

	setup_adapters()
	setup_configurations()

	vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
	vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", linehl = "", numhl = "" })
	vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "", numhl = "" })

	dap.listeners.after.event_initialized["dapui_config"] = util.wrap(dap_ui.open, nil)
	dap.listeners.before.event_terminated["dapui_config"] = util.wrap(dap_ui.close, nil)
	dap.listeners.before.event_exited["dapui_config"] = util.wrap(dap_ui.close, nil)

	wk.register({
		["<leader>d"] = {
			name = "Debug",
			["u"] = { dap_ui.toggle, "Debug UI" },
			["C"] = { dap.continue, "Continue" },
			["o"] = { dap.step_over, "Step over" },
			["i"] = { dap.step_into, "Step into" },
			["O"] = { dap.step_out, "Step out" },
			["d"] = { util.wrap(debuggables, false), "Debug", silent = false },
			["D"] = { util.wrap(debuggables, true), "Debug with args", silent = false },
			["n"] = { dap.run_to_cursor, "Run to cursor" },
			["R"] = { dap.run_last, "Rerun", silent = false },
			["r"] = { dap.restart, "Restart", silent = false },
			["q"] = { dap.close, "Close" },
			["t"] = { dap.terminate, "Terminate" },
			["b"] = { dap.toggle_breakpoint, "Breakpoint" },
			["k"] = { dap.up, "Navigate up the callstack" },
			["j"] = { dap.down, "Navigate down the callstack" },
			["B"] = {
				function()
					dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				"Conditional breakpoint",
			},
			["e"] = {
				function()
					dap_ui.eval(nil, { enter = true })
				end,
				"Evaluate",
			},
			["E"] = {
				function()
					dap_ui.eval(vim.fn.input("Expression: "), { enter = true })
				end,
				"Evaluate expression",
			},
			["?"] = {
				function()
					local widgets = require("dap.ui.widgets")
					widgets.centered_float(widgets.scopes)
				end,
				"Evaluate current scope",
			},
		},
	})
end

M.config = config
M.dependencies = dependencies

return M
