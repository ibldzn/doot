local M = {}

local ccc = require("ccc")
local wk = require("which-key")
local shared = require("shared")

function M.setup()
  ccc.setup({
    highlighter = {
      excludes = {
        "NvimTree",
        "alpha",
        "dapui_breakpoints",
        "dapui_hover",
        "dapui_repl",
        "dapui_scopes",
        "dapui_stacks",
        "help",
        "lspinfo",
        "mason",
        "packer",
      },
    },
    win_opts = {
      border = shared.window.border,
    },
  })

  vim.defer_fn(vim.cmd.CccHighlighterEnable, 0)

  wk.register({
    ["<leader>c"] = {
      name = "Ccc",
      ["t"] = { vim.cmd.CccHighlighterToggle, "Toggle" },
      ["p"] = { vim.cmd.CccPick, "Pick" },
      ["c"] = { vim.cmd.CccConvert, "Convert" },
    },
  })
end

return M
