local M = {}

local setup = function()
	require("colors.minedark").setup()
end

local reload = function()
	package.loaded["colors.common"] = nil
	package.loaded["colors.minedark"] = nil
	package.loaded["colors.minelight"] = nil
	require("colors.minedark").setup()
	require("plugins.lualine").setup()
end

M.setup = setup
M.reload = reload

return M
