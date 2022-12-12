local M = {}

local winshift = require("winshift")
local wk = require("which-key")

function M.setup()
  winshift.setup()

  wk.register({
    ["<C-w>W"] = { vim.cmd.WinShift, "Winshift" },
  })
end

return M
