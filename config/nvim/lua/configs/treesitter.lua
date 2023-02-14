local M = {}

local wk = require("which-key")
local shared = require("shared")
local ts_config = require("nvim-treesitter.configs")
local ts_context = require("treesitter-context")
local CATEGORY = ts_context.CATEGORY or {}

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
      "gitcommit",
      "go",
      "graphql",
      "html",
      "java",
      "javascript",
      "json",
      "kotlin",
      "latex",
      "lua",
      "markdown",
      "nix",
      "php",
      "python",
      "rust",
      "sql",
      "toml",
      "typescript",
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
    matchup = {
      enable = true,
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    playground = {
      enable = true,
    },
    autotag = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["ac"] = { query = "@call.outer", desc = "around function call" },
          ["ic"] = { query = "@call.inner", desc = "inner function call" },
          ["al"] = { query = "@loop.outer", desc = "around loop" },
          ["il"] = { query = "@loop.inner", desc = "inner loop" },
          ["af"] = { query = "@function.outer", desc = "around function" },
          ["if"] = { query = "@function.inner", desc = "inner function" },
          ["aC"] = { query = "@conditional.outer", desc = "around conditional" },
          ["iC"] = { query = "@conditional.inner", desc = "inner conditional" },
        },
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V", -- linewise
          ["@class.outer"] = "<c-v>", -- blockwise
        },
      },
      lsp_interop = {
        enable = true,
        border = shared.window.border,
        peek_definition_code = {
          ["<leader>k"] = "@function.outer",
          ["<leader>K"] = "@class.outer",
        },
      },
    },
  })

  ts_context.setup({
    mode = "topline",
    truncate_side = "outer",
    max_lines = 2,
    categories = {
      default = {
        CATEGORY.CLASS,
        CATEGORY.INTERFACE,
        CATEGORY.STRUCT,
        CATEGORY.ENUM,
        CATEGORY.FUNCTION,
        CATEGORY.METHOD,
        CATEGORY.SECTION,
      },
    },
  })

  wk.register({
    ["<leader>t"] = {
      name = "Toggle",
      ["t"] = { vim.cmd.TSPlaygroundToggle, "Treesitter playground" },
    },
  })
end

return M
