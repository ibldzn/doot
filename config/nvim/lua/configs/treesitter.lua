local M = {}

local ts_config = require("nvim-treesitter.configs")

function M.setup()
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

  ts_config.setup({
    ensure_installed = {
      "bash",
      "c",
      "cmake",
      "comment",
      "cpp",
      "css",
      "dockerfile",
      "go",
      "graphql",
      "html",
      "java",
      "json",
      "kotlin",
      "latex",
      "lua",
      "markdown",
      "nix",
      "python",
      "query",
      "regex",
      "rust",
      "toml",
      "vim",
      "yaml",
      "zig",
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        scope_incremental = "<CR>",
        node_incremental = "<Tab>",
        node_decremental = "<S-Tab>",
      },
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  })
end

return M
