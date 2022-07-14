local M = {}

local wk = require("which-key")

function M.setup()
  wk.register({
    ["<leader>g"] = {
      name = "Git",
      ["g"] = { ":0G<CR>", "Menu" },
      ["cd"] = { ":Gcd<CR>", "CD to git root" },
    },
  })
end

return M
