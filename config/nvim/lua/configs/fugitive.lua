local M = {}

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  return
end

function M.setup()
  wk.register({
    ["<leader>g"] = {
      name = "Git",
      ["g"] = { "<cmd>0G<CR>", "Menu" },
      ["cd"] = { "<cmd>Gcd<CR>", "CD to git root" },
    },
  })
end

return M
