local M = {}

local telescope_ok, telescope = pcall(require, "telescope")
if not telescope_ok then
  return
end

local telescope_builtin_ok, telescope_builtin = pcall(require, "telescope.builtin")
if not telescope_builtin_ok then
  return
end

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  return
end

local util = require("util")

local function find_files(no_ignore)
  local fd_cmd = {
    "fd",
    "--type",
    "file",
    "--hidden",
    "--exclude",
    ".git",
  }
  telescope_builtin.find_files({
    find_command = fd_cmd,
    no_ignore = no_ignore,
  })
end

function M.setup()
  telescope.setup({
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--hidden",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          width = {
            padding = 8,
          },
          height = {
            padding = 3,
          },
          preview_cutoff = 120,
        },
      },
      borderchars = {
        prompt = {
          "█",
          "█",
          "█",
          "█",
          "█",
          "█",
          "",
          "",
        },
        results = {
          "█",
          "█",
          "█",
          "█",
          "",
          "",
          "█",
          "█",
        },
        preview = {
          "█",
          "█",
          "█",
          "▐",
          "▐",
          "",
          "",
          "▐",
        },
      },
      prompt_prefix = " ",
      selection_caret = " ",
    },
  })

  wk.register({
    ["<leader>"] = {
      ["f"] = {
        name = "Find",
        ["f"] = { util.wrap(find_files, false), "Files" },
        ["a"] = { util.wrap(find_files, true), "Ignored files" },
        ["o"] = { telescope_builtin.oldfiles, "Old files" },
        ["b"] = { telescope_builtin.buffers, "Buffers" },
        ["h"] = { telescope_builtin.help_tags, "Help" },
        ["c"] = { telescope_builtin.commands, "Commands" },
        ["m"] = { telescope_builtin.keymaps, "Key mappings" },
        ["i"] = { telescope_builtin.highlights, "Highlight groups" },
        ["g"] = { telescope_builtin.git_status, "Git status" },
        ["d"] = {
          util.wrap(telescope_builtin.diagnostics, { bufnr = 0 }),
          "Document diagnostics",
        },
        ["D"] = { telescope_builtin.diagnostics, "Workspace diagnostics" },
        ["s"] = { telescope_builtin.lsp_document_symbols, "LSP document symbols" },
        ["S"] = { telescope_builtin.lsp_workspace_symbols, "LSP workspace symbols" },
        ["w"] = { telescope_builtin.live_grep, "Live grep" },
        ["r"] = { telescope_builtin.resume, "Resume" },
      },
    },
  })
end

return M
