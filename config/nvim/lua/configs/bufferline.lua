local M = {}

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  return
end

local bufferline_ok, bufferline = pcall(require, "bufferline")
if not bufferline_ok then
  return
end

function M.setup()
  bufferline.setup({
    options = {
      offsets = {
        { filetype = "NvimTree", text = "", padding = 1 },
        { filetype = "dapui_scopes", text = "", padding = 1 },
        { filetype = "dapui_breakpoints", text = "", padding = 1 },
        { filetype = "dapui_stacks", text = "", padding = 1 },
        { filetype = "dapui_watches", text = "", padding = 1 },
      },
      buffer_close_icon = "",
      modified_icon = "",
      close_icon = "",
      show_close_icon = false,
      left_trunc_marker = " ",
      right_trunc_marker = " ",
      max_name_length = 14,
      max_prefix_length = 13,
      tab_size = 15,
      show_tab_indicators = true,
      enforce_regular_tabs = false,
      show_buffer_close_icons = true,
      separator_style = "thin",
      always_show_bufferline = true,
      diagnostics = false,
    },
  })

  wk.register({
    ["<Tab>"] = { "<cmd>BufferLineCycleNext<CR>", "Next buffer" },
    ["<S-Tab>"] = { "<cmd>BufferLineCyclePrev<CR>", "Previous buffer" },
  })
end

return M
