local M = {
	namespace = vim.api.nvim_create_namespace("util.input"),
}

local input = function(opts, on_confirm)
	local cword = vim.fn.expand("<cword>")
	local text = opts.text or cword or ""
	local text_width = vim.fn.strdisplaywidth(text)

	M.confirm_opts = {}
	M.on_confirm = on_confirm
	M.mode = vim.fn.mode()
	M.min_width = 1
	if cword then
		M.min_width = vim.fn.strdisplaywidth(cword)
	end

	-- create buf
	M.buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(M.buf, 0, 1, false, { text })

	-- get word start
	local old_pos = vim.api.nvim_win_get_cursor(0)
	vim.fn.search(vim.fn.expand("<cword>"), "bc")
	local new_pos = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_win_set_cursor(0, { old_pos[1], old_pos[2] })
	local col = 0
	if new_pos[1] == old_pos[1] then
		col = new_pos[2] - old_pos[2]
	end

	-- create win
	local win_opts = {
		relative = "cursor",
		col = col,
		row = 0,
		width = math.max(text_width + 1, M.min_width),
		height = 1,
		style = "minimal",
		border = "none",
	}
	M.win = vim.api.nvim_open_win(M.buf, false, win_opts)
	-- TODO: remove this once 0.10 is released
	-- vim.api.nvim_win_set_option(M.win, "sidescrolloff", 0)
	vim.api.nvim_set_option_value("sidescrolloff", 0, { win = M.win })

	-- key mappings
	vim.api.nvim_buf_set_keymap(M.buf, "n", "<CR>", "", { callback = M.submit, noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(M.buf, "v", "<CR>", "", { callback = M.submit, noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(M.buf, "i", "<CR>", "", { callback = M.submit, noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(M.buf, "i", "<Esc>", "", { callback = M.hide, noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(M.buf, "n", "<Esc>", "", { callback = M.hide, noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(M.buf, "n", "q", "", { callback = M.hide, noremap = true, silent = true })

	-- automatically resize
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "TextChangedP" }, {
		group = vim.api.nvim_create_augroup("UtilInputWindow", { clear = true }),
		buffer = M.buf,
		callback = M.resize,
	})

	-- cancel upon leaving insert mode
	vim.api.nvim_create_autocmd("InsertLeave", {
		group = vim.api.nvim_create_augroup("UtilInputWindowInsertLeave", { clear = true }),
		buffer = M.buf,
		callback = M.hide,
	})

	-- focus and enter insert mode
	vim.api.nvim_set_current_win(M.win)
	if opts.insert then
		vim.cmd.startinsert()
	end
	vim.api.nvim_win_set_cursor(M.win, { 1, text_width })
end

local resize = function()
	local new_text = vim.api.nvim_buf_get_lines(M.buf, 0, 1, false)[1]
	local new_text_width = vim.fn.strdisplaywidth(new_text)
	local width = math.max(new_text_width + 1, M.min_width)

	vim.api.nvim_win_set_width(M.win, width)
	vim.api.nvim_buf_clear_namespace(M.buf, M.namespace, 0, -1)
	vim.api.nvim_buf_add_highlight(M.buf, M.namespace, "Underlined", 0, 0, -1)
end

local submit = function()
	local new_text = vim.api.nvim_buf_get_lines(M.buf, 0, 1, false)[1]
	M.hide()

	if M.on_confirm then
		M.on_confirm(new_text)
		M.on_confirm = nil
	end
end

local hide = function()
	if M.win and vim.api.nvim_win_is_valid(M.win) then
		vim.api.nvim_win_close(M.win, false)
	end
	M.win = nil

	if M.buf and vim.api.nvim_buf_is_valid(M.buf) then
		vim.api.nvim_buf_delete(M.buf, {})
	end
	M.buf = nil

	if M.mode == "i" and vim.fn.mode() ~= "i" then
		vim.cmd.startinsert()
	elseif M.mode ~= "i" and vim.fn.mode() == "i" then
		local pos = vim.api.nvim_win_get_cursor(0)
		pos[2] = pos[2] + 1
		vim.api.nvim_win_set_cursor(0, pos)
		vim.cmd.stopinsert()
	end
end

M.input = input
M.resize = resize
M.submit = submit
M.hide = hide

return M
