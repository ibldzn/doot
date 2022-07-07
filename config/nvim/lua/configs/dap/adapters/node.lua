local M = {}

local dap = require("dap")

function M.setup()
  dap.adapters.node2 = {
    type = "executable",
    command = "node",
    args = { os.getenv("XDG_DATA_HOME") .. "/vscode-node-debug2/out/src/nodeDebug.js" },
  }
end

return M
