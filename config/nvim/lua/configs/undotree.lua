local M = {}

local wk = require("which-key")

function M.setup()
  wk.register({
    ["<C-c>"] = { vim.cmd.UndotreeToggle, "Toggle undo tree" },
  })
end

return M
