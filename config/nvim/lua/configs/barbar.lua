local M = {}

local wk = require("which-key")
local bufferline = require("bufferline")

function M.setup()
  bufferline.setup({
    animation = true,
    tabpages = true,
    closable = true,
    clickable = true,
    icons = true,
    maximum_length = 20,
    icon_pinned = "車",
  })

  wk.register({
    ["<Tab>"] = { ":BufferNext<CR>", "Next buffer" },
    ["<S-Tab>"] = { ":BufferPrevious<CR>", "Previous buffer" },
  })

  wk.register({
    ["<leader>b"] = {
      name = "Buffer",
      ["w"] = { ":BufferWipeout<CR>", "Wipeout" },
      ["x"] = { ":BufferClose<CR>", "Close" },
      ["X"] = { ":BufferCloseAllButCurrentOrPinned<CR>", "Close all but current/pinned" },
      ["p"] = { ":BufferPick<CR>", "Pick" },
      ["P"] = { ":BufferPin<CR>", "Pin" },

      ["s"] = {
        name = "Sort",
        ["d"] = { ":BufferOrderByDirectory<CR>", "By directory" },
        ["l"] = { ":BufferOrderByLanguage<CR>", "By language" },
      },

      ["m"] = {
        name = "Move",
        ["h"] = { ":BufferMovePrevious<CR>", "Left" },
        ["l"] = { ":BufferMoveNext<CR>", "Right" },
      },
    },
  })
end

return M
