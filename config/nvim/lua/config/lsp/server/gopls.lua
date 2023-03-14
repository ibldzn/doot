local M = {}

local setup_autocmd = function()
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = vim.api.nvim_create_augroup("GoOrganizeImports", { clear = true }),
		pattern = "*.go",
		callback = function()
			local params = vim.lsp.util.make_range_params()
			params.context = { only = { "source.organizeImports" } }
			local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 250)
			for _, res in pairs(result or {}) do
				for _, r in pairs(res.result or {}) do
					if r.edit then
						vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
					else
						vim.lsp.buf.execute_command(r.command)
					end
				end
			end
		end,
	})
end

local setup = function(server, on_init, on_attach, capabilities)
	setup_autocmd()
	server.setup({
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
		cmd = { "gopls", "serve" },
		filetypes = { "go", "gomod" },
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
				},
				staticcheck = true,
			},
		},
	})
end

M.setup = setup

return M
