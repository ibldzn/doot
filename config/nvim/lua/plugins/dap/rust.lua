local M = {}

local dap = require("dap")
local Job = require("plenary.job")

local scheduled_error = function(msg)
	vim.schedule(function()
		vim.notify(msg, vim.log.levels.ERROR)
	end)
end

local is_valid_test = function(args)
	local is_not_cargo_check = args.cargoArgs[1] ~= "check"
	return is_not_cargo_check
end

-- filter and modify list of targets for debugging
local sanitize_results_for_debugging = function(result)
	local ret = {}

	ret = vim.tbl_filter(function(value)
		return is_valid_test(value.args)
	end, result or {})

	for i, value in ipairs(ret) do
		if value.args.cargoArgs[1] == "run" then
			ret[i].args.cargoArgs[1] = "build"
		elseif value.args.cargoArgs[1] == "test" then
			table.insert(ret[i].args.cargoArgs, 2, "--no-run")
		end
	end

	return ret
end

local build_label = function(args)
	local ret = ""
	for _, value in ipairs(args.cargoArgs) do
		ret = ret .. value .. " "
	end

	for _, value in ipairs(args.cargoExtraArgs) do
		ret = ret .. value .. " "
	end

	if not vim.tbl_isempty(args.executableArgs) then
		ret = ret .. "-- "
		for _, value in ipairs(args.executableArgs) do
			ret = ret .. value .. " "
		end
	end
	return ret
end

local get_options = function(result, withTitle, withIndex)
	local option_strings = withTitle and { "Debuggables: " } or {}

	for i, debuggable in ipairs(result) do
		local label = build_label(debuggable.args)
		local str = withIndex and string.format("%d: %s", i, label) or label
		table.insert(option_strings, str)
	end

	return option_strings
end

function M.mk_handler(fn)
	return function(...)
		local config_or_client_id = select(4, ...)
		local is_new = type(config_or_client_id) ~= "number"
		if is_new then
			fn(...)
		else
			local err = select(1, ...)
			local method = select(2, ...)
			local result = select(3, ...)
			local client_id = select(4, ...)
			local bufnr = select(5, ...)
			local config = select(6, ...)
			fn(err, result, { method = method, client_id = client_id, bufnr = bufnr }, config)
		end
	end
end

function M.debuggables(prompt)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local sorters = require("telescope.sorters")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local handler = function(_, results)
		if results == nil then
			return
		end

		results = sanitize_results_for_debugging(results)
		local choices = get_options(results, false, false)

		local attach_mappings = function(bufnr, map)
			local on_select = function()
				local choice = action_state.get_selected_entry().index
				actions.close(bufnr)
				local args = results[choice].args
				M.debug(args, prompt)
			end

			map("n", "<CR>", on_select)
			map("i", "<CR>", on_select)

			-- Additional mappings don't push the item to the tagstack.
			return true
		end

		pickers
			.new({}, {
				prompt_title = "Debuggables",
				finder = finders.new_table({ results = choices }),
				sorter = sorters.get_generic_fuzzy_sorter(),
				previewer = nil,
				attach_mappings = attach_mappings,
			})
			:find()
	end

	local params = {
		textDocument = vim.lsp.util.make_text_document_params(),
		position = nil,
	}

	vim.lsp.buf_request(0, "experimental/runnables", params, M.mk_handler(handler))
end

local get_cargo_args_from_runnables_args = function(runnable_args)
	local cargo_args = runnable_args.cargoArgs

	table.insert(cargo_args, "--message-format=json")

	for _, value in ipairs(runnable_args.cargoExtraArgs) do
		table.insert(cargo_args, value)
	end

	if not vim.tbl_isempty(runnable_args.executableArgs) then
		table.insert(cargo_args, "--")
		for _, value in ipairs(runnable_args.executableArgs) do
			table.insert(cargo_args, value)
		end
	end

	return cargo_args
end

function M.debug(args, prompt)
	local cargo_args = get_cargo_args_from_runnables_args(args)

	local cmd_args = {}
	if prompt then
		cmd_args = require("util").split_args(vim.fn.input("args: "))
		if cmd_args == nil then
			scheduled_error("Invalid arguments")
			return
		end
	end

	vim.notify("Compiling a debug build for debugging. This might take some time...")

	Job:new({
		command = "cargo",
		args = cargo_args,
		cwd = args.workspaceRoot,
		on_exit = function(j, code)
			if code and code > 0 then
				scheduled_error("An error occured while compiling. Please fix all compilation issues and try again.")
			end
			vim.schedule(function()
				for _, value in pairs(j:result()) do
					local json = vim.fn.json_decode(value)
					if type(json) == "table" and json.executable ~= vim.NIL and json.executable ~= nil then
						local config = {
							name = "Launch lldb",
							type = "lldb",
							request = "launch",
							program = json.executable,
							args = cmd_args,
							cwd = args.workspaceRoot,
							stopOnEntry = false,
							runInTerminal = false,
						}
						dap.run(config)
						break
					end
				end
			end)
		end,
	}):start()
end

return M
