local M = {}

local indent_blankline_ok, indent_blankline = pcall(require, "indent_blankline")
if not indent_blankline_ok then
  return
end

function M.setup()
  indent_blankline.setup({
    char = "⎸",
    show_trailing_blankline_indent = false,
    use_treesitter = true,
    filetype_exclude = {
      "man",
      "help",
      "NvimTree",
      "lsp-installer",
      "packer",
      "Trouble",
    },
  })
end

return M
