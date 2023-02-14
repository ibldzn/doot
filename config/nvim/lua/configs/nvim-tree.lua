local M = {}

local wk = require("which-key")
local nvim_tree = require("nvim-tree")

function M.setup()
  nvim_tree.setup({
    filters = {
      dotfiles = false,
      exclude = { "custom" },
    },
    git = {
      enable = true,
      ignore = true,
    },
    actions = {
      open_file = {
        resize_window = true,
      },
    },
    modified = {
      enable = true,
      show_on_dirs = true,
      show_on_open_dirs = true,
    },

    respect_buf_cwd = true,
    disable_netrw = true,
    hijack_netrw = true,
    open_on_tab = false,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    update_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },

    diagnostics = {
      enable = true,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
      },
    },

    renderer = {
      indent_markers = {
        enable = true,
      },
      icons = {
        glyphs = {
          default = "",
          symlink = "",
          git = {
            unstaged = "",
            staged = "",
            unmerged = "",
            renamed = "",
            untracked = "",
            deleted = "",
            ignored = "~",
          },
          folder = {
            arrow_closed = "",
            arrow_open = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
          },
        },
      },
    },

    view = {
      side = "right",
      width = 30,
    },
  })

  wk.register({
    ["<A-n>"] = { nvim_tree.toggle, "Filetree toggle" },
  })
end

return M
