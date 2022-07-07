local M = {}

local dap = require("dap")

function M.setup()
  dap.adapters.python = {
    type = "executable",
    command = "/usr/bin/python",
    args = { "-m", "debugpy.adapter" },
  }
end

return M
