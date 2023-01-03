local M = {}

local harpoon = require("harpoon")
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")
local util = require("util")
local wk = require("which-key")
local shared = require("shared")

function M.setup()
  harpoon.setup({
    menu = {
      borderchars = shared.window.plenary_border,
    },
  })

  wk.register({
    ["<A-1>"] = { util.wrap(harpoon_ui.nav_file, 1), "Harpoon file 1" },
    ["<A-2>"] = { util.wrap(harpoon_ui.nav_file, 2), "Harpoon file 2" },
    ["<A-3>"] = { util.wrap(harpoon_ui.nav_file, 3), "Harpoon file 3" },
    ["<A-4>"] = { util.wrap(harpoon_ui.nav_file, 4), "Harpoon file 4" },
    ["<A-[>"] = { util.wrap(harpoon_ui.nav_prev), "Harpoon next file" },
    ["<A-]>"] = { util.wrap(harpoon_ui.nav_next), "Harpoon prev file" },
    ["<leader>h"] = {
      name = "Harpoon",
      ["a"] = { harpoon_mark.add_file, "Add file" },
      ["e"] = { harpoon_ui.toggle_quick_menu, "Toggle UI" },
    },
  })
end

return M
