local M = {}

local surround = require("nvim-surround")

function M.setup()
  surround.setup({
    keymaps = {
      insert = "ys",
      insert_line = "yss",
      visual = "S",
      delete = "ds",
      change = "cs",
    },
    highlight = { -- Highlight before inserting/changing surrounds
      duration = 0,
    },
    move_cursor = false,
  })

  vim.keymap.del("i", "ys")
end

return M
