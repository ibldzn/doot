local M = {}

local comment = require("Comment")
local wk = require("which-key")

function M.setup()
  comment.setup({
    toggler = {
      line = "gcc",
      block = "gbc",
    },
    opleader = {
      line = "gc",
      block = "gb",
    },
    extra = {
      above = "gco",
      below = "gcO",
      eol = "gcA",
    },
    mappings = {
      basic = true,
      extra = true,
    },
    pre_hook = function(ctx)
      local U = require("Comment.utils")

      -- Determine whether to use linewise or blockwise commentstring
      local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

      -- Determine the location where to calculate commentstring from
      local location = nil
      if ctx.ctype == U.ctype.blockwise then
        location = require("ts_context_commentstring.utils").get_cursor_location()
      elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
        location = require("ts_context_commentstring.utils").get_visual_start_location()
      end

      return require("ts_context_commentstring.internal").calculate_commentstring({
        key = type,
        location = location,
      })
    end,
  })

  wk.register({
    ["g"] = {
      name = "Go",
      ["c"] = {
        name = "Comment",
        ["c"] = { nil, "Toggle" },
        ["A"] = { nil, "Append" },
        ["O"] = { nil, "Insert Above" },
        ["o"] = { nil, "Insert Below" },
      },
      ["b"] = {
        name = "Block Comment",
        ["c"] = { nil, "Toggle" },
      },
    },
  })
end

return M
