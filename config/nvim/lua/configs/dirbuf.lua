local M = {}

local wk = require("which-key")

function M.setup()
  wk.register({
    ["<A-f>"] = { vim.cmd.Dirbuf, "Dirbuf" },
  })
end

return M
