local M = {}

local telescope = require("telescope")
local wk = require("which-key")

function M.setup()
  telescope.load_extension("dap")

  wk.register({
    ["<leader>d"] = {
      name = "Debug",
      ["s"] = { ":Telescope dap frames<CR>", "Stack frames" },
      ["l"] = { ":Telescope dap list_breakpoints<CR>", "List breakpoints" },
    },
  })
end

return M
