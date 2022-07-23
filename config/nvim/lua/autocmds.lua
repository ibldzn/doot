local M = {}

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

function M.setup()
  autocmd("BufWritePre", {
    group = augroup("Mkdir", {}),
    callback = function()
      local dir = vim.fn.expand("<afile>:p:h")
      if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, "p")
      end
    end,
  })

  autocmd("TextYankPost", {
    group = augroup("HighlightYank", {}),
    callback = function()
      vim.highlight.on_yank({ timeout = 1000 })
    end,
  })

  autocmd("BufWritePre", {
    group = augroup("TrimTrailingWhitespaces", {}),
    pattern = "!*.md",
    command = ":%s/\\s\\+$//e",
  })

  autocmd("BufEnter", {
    group = augroup("NoCommentsOnNewLine", {}),
    pattern = "*",
    command = "set fo-=c fo-=r fo-=o",
  })

  autocmd("TermOpen", {
    group = augroup("TermOptions", {}),
    command = "setlocal listchars= nonumber norelativenumber nocursorline signcolumn=no | startinsert",
  })
end

return M
