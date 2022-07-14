local M = {}

local surround = require("nvim-surround")
local surround_utils = require("nvim-surround.utils")

function M.setup()
  surround.setup({
    keymaps = { -- vim-surround style keymaps
      insert = "ys",
      insert_line = "yss",
      visual = "S",
      delete = "ds",
      change = "cs",
    },
    delimiters = {
      pairs = {
        ["("] = { "( ", " )" },
        [")"] = { "(", ")" },
        ["{"] = { "{ ", " }" },
        ["}"] = { "{", "}" },
        ["<"] = { "< ", " >" },
        [">"] = { "<", ">" },
        ["["] = { "[ ", " ]" },
        ["]"] = { "[", "]" },
        -- Define pairs based on function evaluations!
        ["i"] = function()
          return {
            surround_utils.get_input("Enter the left delimiter: "),
            surround_utils.get_input("Enter the right delimiter: "),
          }
        end,
        ["f"] = function()
          return {
            surround_utils.get_input("Enter the function name: ") .. "(",
            ")",
          }
        end,
      },
      separators = {
        ["'"] = { "'", "'" },
        ['"'] = { '"', '"' },
        ["`"] = { "`", "`" },
      },
      HTML = {
        ["t"] = "type", -- Change just the tag type
        ["T"] = "whole", -- Change the whole tag contents
      },
      aliases = {
        ["a"] = ">", -- Single character aliases apply everywhere
        ["b"] = ")",
        ["B"] = "}",
        ["r"] = "]",
        -- Table aliases only apply for changes/deletions
        ["q"] = { '"', "'", "`" }, -- Any quote character
        ["s"] = { ")", "]", "}", ">", "'", '"', "`" }, -- Any surrounding delimiter
      },
    },
    highlight_motion = { -- Highlight before inserting/changing surrounds
      duration = 0,
    },
  })
end

return M
