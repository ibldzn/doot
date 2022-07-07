local M = {}

local telescope_ok, telescope = pcall(require, "telescope")
if not telescope_ok then
  return
end

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  return
end

function M.setup()
  telescope.load_extension("dap")

  wk.register({
    ["<leader>d"] = {
      name = "Debug",
      ["s"] = { "<cmd>Telescope dap frames<CR>", "Stack frames" },
      ["l"] = { "<cmd>Telescope dap list_breakpoints<CR>", "List breakpoints" },
    },
  })
end

return M
