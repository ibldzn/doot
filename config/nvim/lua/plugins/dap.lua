local M = {
	"mfussenegger/nvim-dap",
	keys = { { "<leader>d", desc = "Debug" } },
	dependencies = "rcarriga/nvim-dap-ui",
}

local setup_adapters = function()
	local dap = require("dap")

	dap.adapters.go = function(callback, _)
		local stdout = vim.loop.new_pipe(false)
		local handle
		local pid_or_err
		local port = 38697
		local opts = {
			stdio = { nil, stdout },
			args = { "dap", "-l", "127.0.0.1:" .. port },
			detached = true,
		}
		handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
			stdout:close()
			handle:close()
			if code ~= 0 then
				print("dlv exited with code", code)
			end
		end)
		assert(handle, "Error running dlv: " .. tostring(pid_or_err))
		stdout:read_start(function(err, chunk)
			assert(not err, err)
			if chunk then
				vim.schedule(function()
					require("dap.repl").append(chunk)
				end)
			end
		end)
		-- Wait for delve to start
		vim.defer_fn(function()
			callback({ type = "server", host = "127.0.0.1", port = port })
		end, 100)
	end
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
	dap.adapters.python = {
		type = "executable",
		command = "/usr/bin/python",
		args = { "-m", "debugpy.adapter" },
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

	dap.configurations.go = {
		{
			type = "go",
			name = "Debug",
			request = "launch",
			program = "${file}",
		},
		{
			type = "go",
			name = "Debug test", -- configuration for debugging test files
			request = "launch",
			mode = "test",
			program = "${file}",
		},
		-- works with go.mod packages and sub packages
		{
			type = "go",
			name = "Debug test (go.mod)",
			request = "launch",
			mode = "test",
			program = "./${relativeFileDirname}",
		},
	}

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

	dap.configurations.python = {
		{
			-- The first three options are required by nvim-dap
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "Launch file",

			-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

			program = "${file}", -- This configuration will launch the current file if used.
			pythonPath = function()
				-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
				-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
				-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
				local venv = os.getenv("VIRTUAL_ENV")
				if venv ~= nil then
					return string.format("%s/bin/python", venv)
				end

				local cwd = vim.fn.getcwd()
				if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
					return cwd .. "/venv/bin/python"
				elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
					return cwd .. "/.venv/bin/python"
				else
					return "/usr/bin/python"
				end
			end,
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

	dap_ui.setup({
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
				elements = { "repl" },
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
			element = "repl",
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
	})

	wk.register({
		["<leader>"] = {
			["t"] = {
				name = "Toggle",
				["D"] = { dap_ui.toggle, "Debug UI" },
			},
		},

		["<leader>d"] = {
			name = "Debug",
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

return M
