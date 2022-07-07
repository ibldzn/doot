local M = {}

local colorizer_ok, colorizer = pcall(require, "colorizer")
if not colorizer_ok then
  return
end

function M.setup()
  colorizer.setup({})
  vim.cmd("ColorizerToggle")
end

return M
