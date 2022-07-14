local M = {}

local wk = require("which-key")
local util = require("util")
local hop = require("hop")
local hop_hint = require("hop.hint")

function M.setup()
  hop.setup()

  wk.register({
    ["f"] = {
      util.wrap(
        hop.hint_char1,
        { direction = hop_hint.HintDirection.AFTER_CURSOR, current_line_only = true }
      ),
      "Find char 'forward-inclusive'",
    },

    ["F"] = {
      util.wrap(
        hop.hint_char1,
        { direction = hop_hint.HintDirection.BEFORE_CURSOR, current_line_only = true }
      ),
      "Find char 'backward-inclusive'",
    },

    ["t"] = {
      util.wrap(hop.hint_char1, {
        direction = hop_hint.HintDirection.AFTER_CURSOR,
        current_line_only = true,
        hint_offset = -1,
      }),
      "Find char 'forward-exclusive'",
    },

    ["T"] = {
      util.wrap(hop.hint_char1, {
        direction = hop_hint.HintDirection.BEFORE_CURSOR,
        current_line_only = true,
        hint_offset = 1,
      }),
      "Find char 'backward-exclusive'",
    },
  })

  wk.register({
    ["<leader><leader>"] = {
      name = "Hop",
      ["w"] = { hop.hint_words, "Word" },
      ["l"] = { hop.hint_lines, "Lines" },
      ["s"] = { hop.hint_lines_skip_whitespace, "Line start" },
    },
  })
end

return M
