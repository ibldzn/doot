local M = {}

local PUBLISH_DIAGNOSTICS_HANDLER = vim.lsp.handlers["textDocument/publishDiagnostics"]

local custom_diagnostics_handler = function(_, result, ctx, config)
	local format_ts_errors_ok, format_ts_errors = pcall(require, "format-ts-errors")
	if not format_ts_errors_ok then
		return PUBLISH_DIAGNOSTICS_HANDLER(_, result, ctx, config)
	end

	if result.diagnostics == nil then
		return
	end

	-- ignore some tsserver diagnostics
	local idx = 1
	while idx <= #result.diagnostics do
		local entry = result.diagnostics[idx]

		local formatter = format_ts_errors[entry.code]
		entry.message = formatter and formatter(entry.message) or entry.message

		-- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
		if entry.code == 80001 then
			-- { message = "File is a CommonJS module; it may be converted to an ES module.", }
			table.remove(result.diagnostics, idx)
		else
			idx = idx + 1
		end
	end

	vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
end

local setup = function(server, on_init, on_attach, capabilities, filetypes)
	server.setup({
		on_init = on_init,
		on_attach = on_attach,
		filetypes = filetypes,
		capabilities = capabilities,
		handlers = {
			["textDocument/publishDiagnostics"] = custom_diagnostics_handler,
		},
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayVariableTypeHintsWhenTypeMatchesName = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayVariableTypeHintsWhenTypeMatchesName = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		},
	})
end

M.setup = setup

return M
