local toggleterm_terminal_ok, toggleterm_terminal = pcall(require, "toggleterm.terminal")
if not toggleterm_terminal_ok then
	vim.notify("toggleterm isn't installed", vim.log.levels.ERROR)
	return
end

local Terminal = toggleterm_terminal.Terminal

local compile = function(mode, flags)
	local filepath = vim.fn.expand("%:p")
	local filename_no_ext = vim.fn.expand("%:t:r")
	local dirpath = vim.fn.expand("%:p:h")
	local outpath = dirpath .. "/" .. filename_no_ext

	-- vim.cmd.write()
	Terminal:new({
		cmd = [[ g++ ]]
			.. flags
			.. [[ ]]
			.. filepath
			.. [[ -o ]]
			.. outpath
			.. [[; if [ $? -eq 0 ]; then echo '\nOutput (]]
			.. mode
			.. [[)\t:' && /usr/bin/time -f '\nTime\t: %e seconds\nMemory\t: %M Kbytes' ]]
			.. outpath
			.. [[ ; else echo '\nCompilation error'; fi ]],
		close_on_exit = false,
	}):toggle(nil, "horizontal")
end

local compile_debug = function()
	compile("debug", "-O0 -g -std=c++20 -Wall -Wshadow -fsanitize=address -fsanitize=undefined -D_GLIBCXX_DEBUG")
end

local compile_release = function()
	compile("release", "-O3 -std=c++20 -Wall -Wshadow -fsanitize=address -fsanitize=undefined")
end

vim.keymap.set(
	{ "n", "i" },
	"<F10>",
	compile_release,
	{ noremap = true, silent = true, desc = "Compile and run (release)" }
)

vim.keymap.set(
	{ "n", "i" },
	"<F11>",
	compile_debug,
	{ noremap = true, silent = true, desc = "Compile and run (debug)" }
)
