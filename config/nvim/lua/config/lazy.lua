local M = {}

local lazy_bootstrap = function()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"--single-branch",
			"https://github.com/folke/lazy.nvim.git",
			lazypath,
		})
	end

	vim.opt.runtimepath:prepend(lazypath)
end

local lazy_setup = function()
	local lazy = require("lazy")

	local lazy_opts = {
		debug = false,
		spec = {
			{ import = "plugins" },
		},
		defaults = { lazy = true },
		checker = { enabled = true },
		performance = {
			cache = {
				enabled = true,
			},
			rtp = {
				disabled_plugins = {
					"2html_plugin",
					"getscript",
					"getscriptPlugin",
					"gzip",
					"logipat",
					"matchit",
					"matchparen",
					"netrw",
					"netrwFileHandlers",
					"netrwPlugin",
					"netrwSettings",
					"rrhelper",
					"spellfile_plugin",
					"tar",
					"tarPlugin",
					"tohtml",
					"tutor",
					"vimball",
					"vimballPlugin",
					"zip",
					"zipPlugin",
				},
			},
		},
	}

	lazy.setup(lazy_opts)
end

local setup = function()
	lazy_bootstrap()
	lazy_setup()
end

M.setup = setup

return M
