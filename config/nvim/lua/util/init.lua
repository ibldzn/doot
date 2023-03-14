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

-- TODO: move this to lsp configuration
function M.format_buffer(opts)
	opts = opts or {}

	if not vim.g.format_on_save and not opts.force then
		return
	end

	vim.lsp.buf.format({
		filter = function(client)
			return client.name == "null-ls" or client.name == "intelephense"
		end,
	})
end

M.wrap = wrap
M.join_paths = join_paths
M.is_windows = is_windows
M.append_at_eol = append_at_eol
M.path_separator = path_separator

return M
