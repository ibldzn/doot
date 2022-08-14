local M = {}

local colorizer = require("colorizer")
local wk = require("which-key")

function M.setup()
  colorizer.setup({})
  wk.register({
    ["<leader>t"] = {
      name = "Toggle",
      ["C"] = { ":ColorizerToggle<cr>", "Colorizer" },
    },
  }, { mode = "n" })
end

return M
