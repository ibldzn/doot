local M = {}

local ccc = require("ccc")
local wk = require("which-key")
local shared = require("shared")

function M.setup()
  ccc.setup({
    win_opts = {
      border = shared.window.border,
    },
  })

  vim.cmd.CccHighlighterEnable()

  wk.register({
    ["<leader>c"] = {
      name = "Colorizer",
      ["t"] = { vim.cmd.CccHighlighterToggle, "Toggle" },
      ["p"] = { vim.cmd.CccPick, "Pick" },
      ["c"] = { vim.cmd.CccConvert, "Convert" },
    },
  }, { mode = "n" })
end

return M
