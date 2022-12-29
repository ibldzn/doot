local M = {}

function M.setup()
  vim.g.user_emmet_leader_key = ","
  vim.g.user_emmet_install_global = 0

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("Emmet", { clear = true }),
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
