local M = {
	"neovim/nvim-lspconfig",
	ft = require("config.lsp").filetypes_with_lsp(),
	cmd = {
		"LspStart",
		"LspRestart",
		"LspStop",
		"LspLog",
	},
}

local mason = {
	"williamboman/mason.nvim",
	dependencies = "williamboman/mason-lspconfig.nvim",
	cmd = {
		"Mason",
		"MasonLog",
		"MasonInstall",
		"MasonUninstall",
		"MasonUninstallAll",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local lsp = require("config.lsp")
		local shared = require("config.shared")

		local servers = vim.tbl_map(
			function(server)
				return server.name
			end,
			vim.tbl_filter(function(server)
				return server.use_mason == nil or server.use_mason
			end, lsp.servers)
		)

		---@diagnostic disable-next-line: redundant-parameter
		mason.setup({
			ui = {
				border = shared.window.borders,
				icons = {
					package_pending = "󰔟",
					package_installed = " ",
					package_uninstalled = " ",
				},
				keymaps = {
					toggle_package_expand = "<CR>",
					install_package = "i",
					update_package = "u",
					check_package_version = "c",
					update_all_packages = "U",
					check_outdated_packages = "C",
					uninstall_package = "X",
					cancel_installation = "<C-c>",
					apply_language_filter = "<C-f>",
				},
			},
		})

		mason_lspconfig.setup({
			ensure_installed = servers,
			automatic_installation = true,
		})
	end,
}

local null_ls = {
	"jose-elias-alvarez/null-ls.nvim",
	config = function()
		local ns = require("null-ls")
		local lspconfig = require("config.lsp")

		local fm = ns.builtins.formatting
		local dg = ns.builtins.diagnostics
		local ca = ns.builtins.code_actions

		---@diagnostic disable-next-line: redundant-parameter
		ns.setup({
			on_attach = lspconfig.on_attach,
			debug = false,
			sources = {
				ca.shellcheck,

				-- dg.eslint,
				dg.shellcheck,

				fm.black,
				fm.gofmt,
				fm.stylua,
				fm.prettier,
				fm.clang_format.with({
					extra_args = { "--fallback-style=webkit" },
				}),
				fm.shfmt.with({
					extra_args = { "--indent=2", "--case-indent" },
				}),
				fm.rustfmt.with({
					args = {
						"+nightly",
						"--unstable-features",
						"--edition=2021",
						"--emit=stdout",
					},
				}),
			},
		})
	end,
}

local fidget = {
	"j-hui/fidget.nvim",
	opts = {
		text = {
			spinner = "dots_negative",
			done = "",
			commenced = "",
			completed = "",
		},
		fmt = {
			stack_upwards = false,
		},
	},
}

local lsp_signature = {
	"ray-x/lsp_signature.nvim",
	opts = function()
		local shared = require("config.shared")

		return {
			bind = true,
			handler_opts = {
				border = shared.window.border,
			},
			debug = false,
			floating_window = true,
			fix_pos = true,
			doc_lines = 0,
			toggle_key = "<S-A-k>",
			hint_enable = false,
		}
	end,
}

local neodev = {
	"folke/neodev.nvim",
}

local dependencies = {
	mason,
	null_ls,
	fidget,
	lsp_signature,
	neodev,
}

local config = function()
	local DOCUMENT_HIGHLIGHT_HANDLER = vim.lsp.handlers["textDocument/documentHighlight"]
	local VIM_NOTIFY = vim.notify

	vim.notify = function(msg, ...)
		if not msg:find("No information available") then
			return VIM_NOTIFY(msg, ...)
		end
	end

	local wk = require("which-key")
	local shared = require("config.shared")
	local lsp = require("config.lsp")
	local lspconfig = require("lspconfig")

	for server, metadata in pairs(lsp.servers) do
		if not metadata.skip_config then
			local ok, sv = pcall(require, "config.lsp.server." .. server)
			if ok then
				local filetypes = type(metadata.filetypes) == "table" and metadata.filetypes or { metadata.filetypes }
				sv.setup(lspconfig[server], lsp.on_init, lsp.on_attach, lsp.get_capabilities(), filetypes)
			else
				lspconfig[server].setup({
					on_init = lsp.on_init,
					on_attach = lsp.on_attach,
					capabilities = lsp.get_capabilities(),
				})
			end
		end
	end

	-- Diagnostics
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		underline = true,
		virtual_text = {
			spacing = 2,
			severity_limit = "Warning",
		},
	})

	-- Occurences
	vim.lsp.handlers["textDocument/documentHighlight"] = function(...)
		vim.lsp.buf.clear_references()
		DOCUMENT_HIGHLIGHT_HANDLER(...)
	end

	-- Documentation window border
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = shared.window.border,
	})

	wk.register({
		["<leader>i"] = {
			name = "Lsp",
			["s"] = { vim.cmd.LspStart, "Start" },
			["r"] = { vim.cmd.LspRestart, "Restart" },
			["t"] = { vim.cmd.LspStop, "Stop" },
			["i"] = { vim.cmd.LspInfo, "Info" },
			["I"] = { vim.cmd.Mason, "Install Info" },
			["l"] = { vim.cmd.MasonLog, "Install Log" },
		},
	})

	vim.api.nvim_exec_autocmds("FileType", {})
end

M.config = config
M.dependencies = dependencies

return M
