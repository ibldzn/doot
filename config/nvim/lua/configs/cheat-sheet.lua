local M = {}

local cheat_sheet_ok, cheat_sheet = pcall(require, "cheat-sheet")
if not cheat_sheet_ok then
  return
end

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  return
end

local shared = require("shared")

function M.setup()
  cheat_sheet.setup({
    auto_fill = {
      current_word = false,
    },

    main_win = {
      border = shared.window.border,
    },

    input_win = {
      border = shared.window.border,
    },
  })

  wk.register({
    ["<leader>t"] = {
      name = "Toggle",
      ["c"] = { "<cmd>CheatSH<CR>", "Cheat sheet" },
    },
  })
end

return M
