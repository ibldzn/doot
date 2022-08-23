local M = {}

local navic = require("nvim-navic")
local icons = require("nvim-web-devicons")
local shared = require("shared")

local function get_filename()
  local file_name = vim.fn.expand("%:t")
  local file_ext = vim.fn.expand("%:e")

  local file_icon, file_icon_color = icons.get_icon_color(file_name, file_ext, { default = true })

  local hl_group = "FileIconColor" .. file_ext
  vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })

  return " %#" .. hl_group .. "#" .. file_icon, "%* %#NavicText#" .. file_name .. "%*"
end

function M.setup()
  local excluded_filetypes = {
    "",
    "NvimTree",
    "TelescopePrompt",
    "alpha",
    "dapui_breakpoints",
    "dapui_hover",
    "dapui_repl",
    "dapui_scopes",
    "dapui_stacks",
    "help",
    "lspinfo",
    "mason",
    "packer",
  }

  vim.g.navic_silence = true

  navic.setup({
    icons = {
      File = " ",
      Module = " ",
      Namespace = " ",
      Package = " ",
      Class = " ",
      Method = " ",
      Property = " ",
      Field = " ",
      Constructor = " ",
      Enum = "練",
      Interface = "練",
      Function = " ",
      Variable = " ",
      Constant = " ",
      String = " ",
      Number = " ",
      Boolean = "◩ ",
      Array = " ",
      Object = " ",
      Key = " ",
      Null = "ﳠ ",
      EnumMember = " ",
      Struct = " ",
      Event = " ",
      Operator = " ",
      TypeParameter = " ",
    },
    highlight = true,
    separator = " > ",
    depth_limit = 0,
    depth_limit_indicator = "..",
  })

  vim.api.nvim_create_autocmd({
    "CursorMoved",
    "CursorHold",
    "BufWinEnter",
    "BufFilePost",
    "InsertEnter",
    "BufWritePost",
    "TabClosed",
  }, {
    group = vim.api.nvim_create_augroup("Navic", { clear = true }),
    callback = function()
      if vim.tbl_contains(excluded_filetypes, vim.bo.filetype) then
        vim.wo.winbar = nil
        return
      end

      local icon, filename = get_filename()

      local winbar = icon .. " " .. filename
      if vim.bo.modified then
        winbar = winbar .. " " .. shared.icons.modified
      elseif not vim.bo.modifiable or vim.bo.readonly then
        winbar = winbar .. " " .. shared.icons.readonly
      end
      winbar = winbar .. "%=" .. navic.get_location()

      vim.wo.winbar = winbar
    end,
  })
end

return M
