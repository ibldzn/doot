local M = {}

function M.setup()
  local adapters = {
    "go",
    "lldb",
    "node",
    "python",
  }
  for _, adapter in ipairs(adapters) do
    require("configs.dap.adapters." .. adapter).setup()
  end
end

return M
