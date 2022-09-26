local M = {}

local jeskape = require("jeskape")

function M.setup()
  jeskape.setup({
    mappings = {
      ["jk"] = "<Esc>",
      [";;"] = "<cmd>lua require('util').append_at_eol(';')<CR>",
      [",,"] = "<cmd>lua require('util').append_at_eol(',')<CR>",
    },
  })
end

return M
