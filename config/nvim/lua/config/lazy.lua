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

local get_latest_lazy_lock_commit_date = function()
	local config_dir = vim.fn.stdpath("config")
	local git_cmd = string.format("cd -P %s && git log -1 --format=%%cd --date=unix lazy-lock.json", config_dir)
	local git_log = vim.fn.system(git_cmd)
	local commit_date = vim.fn.substitute(git_log, "\n", "", "g")

	return commit_date
end

local should_commit_lazy_lock = function()
	local commit_date = get_latest_lazy_lock_commit_date()
	local current_date = vim.fn.str2nr(vim.fn.strftime("%s"))

	local diff = current_date - commit_date
	local diff_in_days = diff / 60 / 60 / 24

	return diff_in_days >= 3
end

local lazy_autocmds = function()
	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyUpdate",
		group = vim.api.nvim_create_augroup("CommitLazyLockJSON", { clear = true }),
		callback = function()
			if should_commit_lazy_lock() then
				local config_dir = vim.fn.stdpath("config")
				vim.cmd("silent! lcd " .. config_dir)
				vim.cmd("silent! !git add lazy-lock.json && git commit -m 'chore(nvim): update `lazy-lock.json`'")
			end
		end,
	})
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
	lazy_autocmds()
end

M.setup = setup

return M
