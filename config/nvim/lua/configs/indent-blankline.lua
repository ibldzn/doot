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
    char_highlight_list = {
      "IndentBlanklineIndent1",
      "IndentBlanklineIndent2",
      "IndentBlanklineIndent3",
      "IndentBlanklineIndent4",
      "IndentBlanklineIndent5",
      "IndentBlanklineIndent6",
    },
    show_current_context = true,
  })
end

return M
