local M = {}

local setup = function()
	local augroup = vim.api.nvim_create_augroup
	local autocmd = vim.api.nvim_create_autocmd

	autocmd("BufWritePre", {
		group = augroup("Mkdir", { clear = true }),
		callback = function()
			local dir = vim.fn.expand("<afile>:p:h")
			if vim.fn.isdirectory(dir) == 0 then
				vim.fn.mkdir(dir, "p")
			end
		end,
	})

	autocmd("TextYankPost", {
		group = augroup("HighlightYank", { clear = true }),
		callback = function()
			vim.highlight.on_yank({ timeout = 1000 })
		end,
	})

	autocmd("BufWritePre", {
		group = augroup("TrimTrailingWhitespaces", { clear = true }),
		pattern = "!*.md",
		command = ":%s/\\s\\+$//e",
	})

	autocmd("BufEnter", {
		group = augroup("NoCommentsOnNewLine", { clear = true }),
		pattern = "*",
		command = "set fo-=c fo-=r fo-=o",
	})

	autocmd({ "InsertEnter", "InsertLeave" }, {
		group = augroup("RelativeLineNumberToggler", { clear = true }),
		callback = function(event)
			if vim.wo.number or vim.wo.relativenumber then
				vim.wo.relativenumber = event.event == "InsertLeave"
			end
		end,
	})

	autocmd("TermOpen", {
		group = augroup("TermOptions", { clear = true }),
		callback = function()
			local opts = {
				listchars = nil,
				number = false,
				relativenumber = false,
				cursorline = false,
				signcolumn = "no",
			}
			for opt, val in pairs(opts) do
				vim.opt_local[opt] = val
			end
			vim.cmd.startinsert({ bang = true })
		end,
	})

	autocmd("FileType", {
		group = augroup("MapQToCloseWindow", { clear = true }),
		pattern = {
			"dap-float",
			"help",
			"lspinfo",
			"man",
			"neotest-attach",
			"neotest-output",
			"neotest-output-panel",
			"neotest-summary",
			"notify",
			"qf",
			"query",
			"spectre_panel",
			"startuptime",
			"tsplayground",
		},
		callback = function(event)
			vim.bo[event.buf].buflisted = false
			vim.keymap.set("n", "q", vim.cmd.close, { buffer = event.buf, silent = true })
		end,
	})

	autocmd("FileType", {
		group = augroup("IndentTwoSpaces", { clear = true }),
		pattern = {
			"cmake",
			"css",
			"graphql",
			"html",
			"javascript",
			"javascriptreact",
			"json",
			"lua",
			"nix",
			"php",
			"scss",
			"sql",
			"tex",
			"typescript",
			"typescriptreact",
			"xhtml",
			"xml",
			"yaml",
		},
		callback = function()
			vim.opt.expandtab = true
			vim.opt_local.shiftwidth = 2
			vim.opt_local.tabstop = 2
		end,
	})
end

M.setup = setup

return M
