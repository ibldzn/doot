local M = {}

local wk = require("which-key")

function M.setup()
  vim.g.undotree_WindowLayout = 2

  wk.register({
    ["<C-c>"] = { vim.cmd.UndotreeToggle, "Toggle undo tree" },
  })
end

return M
