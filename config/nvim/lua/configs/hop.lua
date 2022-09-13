local M = {}

local wk = require("which-key")
local hop = require("hop")

function M.setup()
  hop.setup()

  wk.register({
    ["s"] = {
      name = "Hop",
      ["c"] = { hop.hint_char1, "Char" },
      ["C"] = { hop.hint_char2, "2 Chars" },
      ["w"] = { hop.hint_words, "Word" },
      ["l"] = { hop.hint_lines, "Lines" },
      ["s"] = { hop.hint_lines_skip_whitespace, "Line start" },
      ["p"] = { hop.hint_patterns, "Pattern" },
    },
  })
end

return M
