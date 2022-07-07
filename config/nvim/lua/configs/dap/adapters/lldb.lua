local M = {}

local dap = require("dap")

function M.setup()
  dap.adapters.lldb = {
    type = "executable",
    command = "lldb-vscode",
    name = "lldb",
  }
end

return M
