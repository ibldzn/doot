local M = {
	"simrat39/rust-tools.nvim",
	ft = "rust",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",
		"mfussenegger/nvim-dap",
	},
}

local KIND = {
	OTHER = 1,
	PARAM_HINTS = 2,
}

local namespace = vim.api.nvim_create_namespace("configs.rust-tools")

local inlay_hints_handler = function(err, result, ctx)
	if err then
		return
	end

	vim.api.nvim_buf_clear_namespace(ctx.bufnr, namespace, 0, -1)

	local prefix = " "
	local highlight = "NonText"
	local hints = {}
	for _, item in ipairs(result) do
		if item.kind == KIND.OTHER then
			local line = tonumber(item.position.line)
			hints[line] = hints[line] or {}

			local text = ""

			if type(item.label) == "table" then
				local labels = vim.tbl_map(function(l)
					return l.value
				end, item.label)
				text = table.concat(labels)
			else
				text = item.label
			end

			text = text:gsub(": ", "")

			table.insert(hints[line], prefix .. text)
		end
	end

	for l, t in pairs(hints) do
		local text = table.concat(t, " ")
		vim.api.nvim_buf_set_extmark(ctx.bufnr, namespace, l, 0, {
			virt_text = { { text, highlight } },
			virt_text_pos = "eol",
			hl_mode = "combine",
		})
	end
end

local inlay_hints = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local line_count = vim.api.nvim_buf_line_count(bufnr) - 1
	local last_line = vim.api.nvim_buf_get_lines(bufnr, line_count, line_count + 1, true)

	local params = {
		textDocument = vim.lsp.util.make_text_document_params(bufnr),
		range = {
			start = {
				line = 0,
				character = 0,
			},
			["end"] = {
				line = line_count,
				character = #last_line[1],
			},
		},
	}

	vim.lsp.buf_request(0, "textDocument/inlayHint", params, inlay_hints_handler)
end

local config = function()
	local lsp = require("config.lsp")
	local shared = require("config.shared")
	local rust_tools = require("rust-tools")

	local m_on_attach = function(client, buf)
		lsp.on_attach(client, buf)

		local old_progress_handler = vim.lsp.handlers["$/progress"]
		vim.lsp.handlers["$/progress"] = function(err, result, ctx, config)
			if old_progress_handler then
				old_progress_handler(err, result, ctx, config)
			end

			if result.value and result.value.kind == "end" then
				inlay_hints()
			end
		end

		local group = vim.api.nvim_create_augroup("LspInlayHints", {})
		vim.api.nvim_create_autocmd({
			"TextChanged",
			"TextChangedI",
			"TextChangedP",
			"BufEnter",
			"BufWinEnter",
			"TabEnter",
			"BufWritePost",
		}, {
			group = group,
			buffer = buf,
			callback = inlay_hints,
		})

		inlay_hints()
	end

	---@diagnostic disable-next-line: redundant-parameter
	rust_tools.setup({
		tools = {
			inlay_hints = {
				auto = false,
			},
			hover_actions = {
				border = shared.window.border,
			},
		},

		server = {
			on_init = lsp.on_init,
			on_attach = m_on_attach,
			settings = {
				["rust-analyzer"] = {
					assist = {
						importPrefix = "plain",
						importGranularity = "module",
						importEnforceGranularity = true,
					},
					inlayHints = {
						maxLength = 40,
					},
					checkOnSave = {
						command = "clippy",
					},
				},
			},
		},
	})
end

M.config = config

return M
