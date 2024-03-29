local M = {}

local is_windows = function()
	if jit ~= nil then
		return jit.os == "Windows"
	end
	return package.config:sub(1, 1) == "\\"
end

local path_separator = function()
	if is_windows() then
		return "\\"
	end
	return "/"
end

local join_paths = function(...)
	local sep = path_separator()
	return table.concat({ ... }, sep)
end

local wrap = function(func, ...)
	local args = { ... }
	return function()
		return func(unpack(args))
	end
end

local append_at_eol = function(char)
	local pos = vim.api.nvim_win_get_cursor(0)
	vim.cmd.normal("A" .. char)
	vim.api.nvim_win_set_cursor(0, pos)
end

local get_env = function(file)
	local env = {}

	if file then
		file = vim.fn.expand(file)
	else
		file = ".env"
	end

	if vim.fn.filereadable(file) == 0 then
		return env
	end

	for _, line in ipairs(vim.fn.readfile(file)) do
		for name, value in string.gmatch(line, "(%S+)=['\"]?(.*)['\"]?") do
			local str_end = string.sub(value, -1, -1)
			if str_end == "'" or str_end == '"' then
				value = string.sub(value, 1, -2)
			end
			env[name] = value
		end
	end

	return env
end

local split_args = function(args)
	local result = {}
	local current_arg = ""
	local in_quotes = false

	for i = 1, #args do
		local c = args:sub(i, i)
		if c == '"' then
			in_quotes = not in_quotes
		elseif c == " " and not in_quotes then
			table.insert(result, current_arg)
			current_arg = ""
		else
			current_arg = current_arg .. c
		end
	end

	if in_quotes then
		return nil, "Unclosed quote"
	end

	table.insert(result, current_arg)
	return result
end

M.wrap = wrap
M.get_env = get_env
M.join_paths = join_paths
M.is_windows = is_windows
M.split_args = split_args
M.append_at_eol = append_at_eol
M.path_separator = path_separator

return M
