local M = {}

function M.setup()
  local adapters = {
    "cpp",
    "go",
    "javascript",
    "python",
  }
  for _, adapter in ipairs(adapters) do
    require("configs.dap.configurations." .. adapter).setup()
  end
end

return M
