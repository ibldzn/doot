local M = {}

local servers = {
	bashls = { filetypes = "sh" },
	clangd = { filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" } },
	cmake = { filetypes = "cmake" },
	cssls = { filetypes = { "css", "less", "scss", "sass" } },
	dartls = { filetypes = "dart", use_mason = false },
	gopls = { filetypes = { "go", "gomod", "gowork", "gotmpl" } },
	html = { filetypes = "html" },
	intelephense = { filetypes = "php", allow_fmt = true },
	-- jdtls = { filetypes = "java" },
	jsonls = { filetypes = { "json", "jsonc" } },
	lua_ls = { filetypes = "lua" },
	pyright = { filetypes = "python" },
	rust_analyzer = { filetypes = "rust", skip_config = true }, -- let rust-tools handle the configuration
	tailwindcss = {
		filetypes = {
			"aspnetcorerazor",
			"astro",
			"astro-markdown",
			"blade",
			"django-html",
			"htmldjango",
			"edge",
			"eelixir",
			"elixir",
			"ejs",
			"erb",
			"eruby",
			"gohtml",
			"haml",
			"handlebars",
			"hbs",
			"html",
			"html-eex",
			"heex",
			"jade",
			"leaf",
			"liquid",
			"markdown",
			"mdx",
			"mustache",
			"njk",
			"nunjucks",
			"php",
			"razor",
			"slim",
			"twig",
			"css",
			"less",
			"postcss",
			"sass",
			"scss",
			"stylus",
			"sugarss",
			"javascript",
			"javascriptreact",
			"reason",
			"rescript",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
		},
	},
	tsserver = {
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
	},
}

local filetypes_with_lsp = function()
	return vim.tbl_flatten(vim.tbl_values(vim.tbl_map(function(server)
		return server.filetypes
	end, servers)))
end

local format_buffer = function()
	local get_lsp_client_metadata = function(client)
		for server, metadata in pairs(servers) do
			if server == client.name then
				return metadata
			end
		end
		return nil
	end

	vim.lsp.buf.format({
		filter = function(client)
			local metadata = get_lsp_client_metadata(client)
			return client.name == "null-ls" or (metadata and metadata.allow_fmt)
		end,
	})
end

local show_docs = function()
	if vim.fn.expand("%:t") == "Cargo.toml" then
		return require("crates").show_popup()
	end

	local maps = {
		[{ "vim", "help" }] = function()
			vim.cmd.h(vim.fn.expand("<cword>"))
		end,
		[{ "man" }] = function()
			vim.cmd.Man(vim.fn.expand("<cword>"))
		end,
		[{ "rust" }] = function()
			local rt = require("rust-tools")
			rt.hover_actions.hover_actions()
		end,
	}

	for filetypes, callback in pairs(maps) do
		if vim.tbl_contains(filetypes, vim.bo.filetype) then
			return callback()
		end
	end

	return vim.lsp.buf.hover()
end

local on_init = function(client)
	client.config.flags = client.config.flags or {}
	client.config.flags.allow_incremental_sync = true
end

local on_attach = function(client, buf)
	local wk = require("which-key")
	local navic = require("nvim-navic")

	if
		client.supports_method("textDocument/documentSymbolProvider")
		and client.supports_method("textDocument/documentSymbol")
	then
		navic.attach(client, buf)
	end

	if client.supports_method("textDocument/documentHighlight") then
		local group = vim.api.nvim_create_augroup("ConfigLspOccurences", { clear = false })
		vim.api.nvim_clear_autocmds({ buffer = buf, group = group })
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			group = group,
			buffer = buf,
			callback = vim.lsp.buf.document_highlight,
		})
	end

	if client.supports_method("textDocument/formatting") then
		local group = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
		vim.api.nvim_clear_autocmds({ buffer = buf, group = group })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = group,
			buffer = buf,
			callback = format_buffer,
		})
	end

	if client.supports_method("textDocument/colorProvider") then
		vim.defer_fn(function()
			pcall(vim.cmd.CccHighlighterEnable)
		end, 500)
	end

	wk.register({
		["<S-A-f>"] = { format_buffer, "Format current buffer" },
		["<S-A-k>"] = { vim.lsp.buf.signature_help, "Signature help" },
		["g"] = {
			name = "Go",
			["d"] = { vim.lsp.buf.definition, "LSP definition" },
			["D"] = { vim.lsp.buf.declaration, "LSP declaration" },
			["r"] = { vim.lsp.buf.references, "LSP references" },
		},
		["<leader>"] = {
			["t"] = {
				name = "Toggle",
				["d"] = { vim.diagnostic.open_float, "Diagnostic on cursor" },
			},
			["a"] = { vim.lsp.buf.code_action, "Code action" },
			["r"] = {
				function()
					require("util.input").input({ insert = true }, function(new_name)
						vim.lsp.buf.rename(new_name)
					end)
				end,
				"Refactor keep name",
			},
			["R"] = {
				function()
					require("util.input").input({ text = "", insert = true }, function(new_name)
						vim.lsp.buf.rename(new_name)
					end)
				end,
				"Refactor clear name",
			},
		},
	}, {
		buffer = buf,
	})
end

local get_capabilities = function()
	local cmp_nvim_lsp = require("cmp_nvim_lsp")

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	local cmp_capabilities = cmp_nvim_lsp.default_capabilities()
	local additional_capabilities = {
		capabilities = {
			window = {
				workDoneProgress = true,
			},
			workspace = {
				didChangeWatchedFiles = {
					dynamicRegistration = true,
				},
			},
		},
	}

	return vim.tbl_deep_extend("force", capabilities, cmp_capabilities, additional_capabilities)
end

M.servers = servers
M.on_init = on_init
M.on_attach = on_attach
M.show_docs = show_docs
M.get_capabilities = get_capabilities
M.filetypes_with_lsp = filetypes_with_lsp

return M
