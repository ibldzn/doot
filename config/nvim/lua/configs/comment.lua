local M = {}

local comment_ok, comment = pcall(require, "Comment")
if not comment_ok then
  return
end

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  return
end

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
      above = "gcO",
      below = "gco",
      eol = "gcA",
    },
    mappings = {
      basic = true,
      extra = true,
      extended = false,
    },
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
