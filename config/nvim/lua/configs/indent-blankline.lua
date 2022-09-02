local M = {}

local indent_blankline = require("indent_blankline")

function M.setup()
  indent_blankline.setup({
    char = "⎸",
    show_trailing_blankline_indent = false,
    use_treesitter = true,
    filetype_exclude = {
      "NvimTree",
      "Trouble",
      "help",
      "man",
      "mason",
      "packer",
    },
  })
end

return M
