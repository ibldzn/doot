local M = {}

local setup = function(server, on_init, on_attach, capabilities)
	local new_capabilities = vim.tbl_deep_extend("force", capabilities, { offsetEncoding = "utf-8" })
	server.setup({
		on_init = on_init,
		on_attach = on_attach,
		capabilities = new_capabilities,
		cmd = {
			"clangd",
			"--clang-tidy",
			"--background-index",
			"--cross-file-rename",
			"--all-scopes-completion",
			"--header-insertion=iwyu",
			"--fallback-style=webkit",
			"--suggest-missing-includes",
			"--completion-style=detailed",
		},
	})
end

M.setup = setup

return M
