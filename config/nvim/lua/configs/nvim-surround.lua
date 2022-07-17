local M = {}

local surround = require("nvim-surround")

function M.setup()
  surround.setup({
    keymaps = {
      insert = "ys",
      insert_line = "yss",
      visual = "S",
      delete = "ds",
      change = "cs",
    },
    delimiters = {
      invalid_key_behavior = function()
        vim.api.nvim_err_writeln("Error: Invalid character!")
      end,
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
            vim.fn.input({ prompt = "Enter the left delimiter: " }),
            vim.fn.input({ prompt = "Enter the right delimiter: " }),
          }
        end,
        ["f"] = function()
          return {
            vim.fn.input({ prompt = "Enter the function name: " }) .. "(",
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
