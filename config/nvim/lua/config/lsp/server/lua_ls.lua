local M = {}

local setup = function(server, on_init, on_attach, capabilities)
	server.setup({
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					maxPreload = 100000,
					preloadFileSize = 10000,
					checkThirdParty = false,
				},
				telemetry = {
					enable = false,
				},
			},
		},
	})
end

M.setup = setup

return M
