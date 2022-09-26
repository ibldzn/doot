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
    ["<Tab>"] = { vim.cmd.BufferNext, "Next buffer" },
    ["<S-Tab>"] = { vim.cmd.BufferPrevious, "Previous buffer" },
  })

  wk.register({
    ["<leader>b"] = {
      name = "Buffer",
      ["w"] = { vim.cmd.BufferWipeout, "Wipeout" },
      ["x"] = { vim.cmd.BufferClose, "Close" },
      ["X"] = { vim.cmd.BufferCloseAllButCurrentOrPinned, "Close all but current/pinned" },
      ["p"] = { vim.cmd.BufferPick, "Pick" },
      ["P"] = { vim.cmd.BufferPin, "Pin" },

      ["s"] = {
        name = "Sort",
        ["d"] = { vim.cmd.BufferOrderByDirectory, "By directory" },
        ["l"] = { vim.cmd.BufferOrderByLanguage, "By language" },
      },

      ["m"] = {
        name = "Move",
        ["h"] = { vim.cmd.BufferMovePrevious, "Left" },
        ["l"] = { vim.cmd.BufferMoveNext, "Right" },
      },
    },
  })
end

return M
