vim.opt_local.bufhidden = "unload"
vim.cmd.wincmd("L")
vim.api.nvim_win_set_width(0, 90)

vim.api.nvim_buf_set_keymap(0, "n", "q", "", {
  callback = function()
    vim.api.nvim_win_close(0, false)
  end,
  noremap = true,
  silent = true,
})
