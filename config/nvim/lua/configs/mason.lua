local M = {}

local mason = require("mason")
local shared = require("shared")

function M.setup()
  mason.setup({
    ui = {
      border = shared.window.borders,
      icons = {
        package_pending = " ﲊ",
        package_installed = " ",
        package_uninstalled = " ",
      },
    },
  })
end

return M
