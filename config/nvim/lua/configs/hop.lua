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
      ["p"] = { hop.hint_patterns, "Pattern" },
      ["l"] = { hop.hint_lines, "Lines" },
      ["S"] = { hop.hint_lines_skip_whitespace, "Line start" },
      ["s"] = { hop.hint_words, "Word" },
    },
  })
end

return M
