local error_handler = function(name)
	return function(err)
		local text = "Failed to load module '" .. name .. "':\n" .. (err or "")
		vim.notify(text, vim.log.levels.ERROR)
		return err
	end
end

local prequire = function(name, setup)
	local mod_ok, mod = xpcall(function()
		return require(name)
	end, error_handler(name))

	if not mod_ok then
		return
	end

	if setup ~= false then
		xpcall(mod.setup, error_handler(name))
	end

	return mod
end

prequire("config.options")
prequire("config.autocmds")
prequire("util.select")
prequire("config.lazy")
prequire("config.keymaps")
prequire("config.diagnostics")
prequire("config.custom_commands")
prequire("colors")
