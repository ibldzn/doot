local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("Emmet", {}),
    pattern = {
      "html",
      "css",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    command = "EmmetInstall",
  })
end

return M
