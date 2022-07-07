local M = {}

local lspsignature_ok, lspsignature = pcall(require, "lsp_signature")
if not lspsignature_ok then
  return
end

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
