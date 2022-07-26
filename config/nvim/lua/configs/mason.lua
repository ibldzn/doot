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
      keymaps = {
        toggle_package_expand = "<CR>",
        install_package = "i",
        update_package = "u",
        check_package_version = "c",
        update_all_packages = "U",
        check_outdated_packages = "C",
        uninstall_package = "X",
        cancel_installation = "<C-c>",
        apply_language_filter = "<C-f>",
      },
    },
  })
end

return M
