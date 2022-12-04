local M = {}

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lsp = require("configs.lsp")
local shared = require("shared")

function M.setup()
  local servers = vim.tbl_map(
    function(server)
      return server.name
    end,
    vim.tbl_filter(function(server)
      return server.use_mason == nil or server.use_mason
    end, lsp.servers)
  )

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
  mason_lspconfig.setup({
    ensure_installed = servers,
    automatic_installation = true,
  })
end

return M
