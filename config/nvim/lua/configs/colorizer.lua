local M = {}

local colorizer = require("colorizer")

function M.setup()
  colorizer.setup({})
  vim.cmd("ColorizerToggle")
end

return M
