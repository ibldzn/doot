local M = {}

local lspsignature = require("lsp_signature")
local shared = require("shared")

function M.setup()
  lspsignature.setup({
    bind = true,
    handler_opts = {
      border = shared.window.border,
    },
    debug = false,
    floating_window = true,
    fix_pos = true,
    doc_lines = 0,
    toggle_key = "<S-A-k>",
    hint_enable = false,
  })
end

return M
