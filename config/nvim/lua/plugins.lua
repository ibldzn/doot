local M = {}

local function bootstrap_lazy()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
    })
  end

  vim.opt.runtimepath:prepend(lazypath)
end

function M.setup()
  bootstrap_lazy()

  -- load before other plugins
  local notify_ok, notify = pcall(require, "notify")
  if notify_ok then
    vim.notify = notify
  end

  local lazy_ok, lazy = pcall(require, "lazy")
  if not lazy_ok then
    vim.notify("lazy isn't installed", vim.log.levels.ERROR)
    return
  end

  local lazy_config = {
    defaults = { lazy = true },
    checker = { enabled = true },
    performance = {
      rtp = {
        disabled_plugins = {
          "2html_plugin",
          "getscript",
          "getscriptPlugin",
          "gzip",
          "logipat",
          "matchit",
          "matchparen",
          "netrw",
          "netrwFileHandlers",
          "netrwPlugin",
          "netrwSettings",
          "rrhelper",
          "spellfile_plugin",
          "tar",
          "tarPlugin",
          "tohtml",
          "tutor",
          "vimball",
          "vimballPlugin",
          "zip",
          "zipPlugin",
        },
      },
    },
  }

  lazy.setup({
    "nvim-lua/plenary.nvim",
    "kyazdani42/nvim-web-devicons",

    {
      "uga-rosa/ccc.nvim",
      cmd = {
        "CccConvert",
        "CccHighlighterDisable",
        "CccHighlighterEnable",
        "CccHighlighterToggle",
        "CccPick",
      },
      keys = { "<leader>c", mode = "n" },
      config = function()
        require("configs.colorizer").setup()
      end,
    },

    {
      "farmergreg/vim-lastplace",
      event = "BufReadPost",
    },

    {
      "andymass/vim-matchup",
      event = "BufReadPost",
      config = function()
        vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
      end,
    },

    {
      "mg979/vim-visual-multi",
      keys = { "<C-n>", mode = { "n", "x" } },
      config = function()
        vim.g.VM_show_warnings = 0
      end,
    },

    {
      "krady21/compiler-explorer.nvim",
      cmd = {
        "CEAddLibrary",
        "CECompile",
        "CECompileLive",
        "CEDeleteCache",
        "CEFormat",
        "CELoadExample",
        "CEOpenWebsite",
      },
    },

    {
      "rcarriga/nvim-notify",
      event = "VeryLazy",
      config = function()
        require("configs.notify").setup()
      end,
    },

    {
      "folke/which-key.nvim",
      config = function()
        require("configs.which-key").setup()
      end,
    },

    {
      "mbbill/undotree",
      keys = { "<C-c>", mode = "n" },
      config = function()
        require("configs.undotree").setup()
      end,
    },

    {
      "nvim-lualine/lualine.nvim",
      event = "UIEnter",
      config = function()
        require("configs.lualine").setup()
      end,
    },

    {
      "lukas-reineke/indent-blankline.nvim",
      event = "BufReadPre",
      config = function()
        require("configs.indent-blankline").setup()
      end,
    },

    {
      "windwp/nvim-spectre",
      keys = { "<leader>s", mode = { "n", "v" } },
      config = function()
        require("configs.spectre").setup()
      end,
    },

    {
      "phaazon/hop.nvim",
      keys = { "s", mode = "n" },
      config = function()
        require("configs.hop").setup()
      end,
    },

    {
      "nvim-treesitter/nvim-treesitter",
      event = "BufReadPost",
      dependencies = {
        "windwp/nvim-ts-autotag",
        "nvim-treesitter/playground",
        "nvim-treesitter/nvim-treesitter-context",
        "JoosepAlviste/nvim-ts-context-commentstring",
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
      build = ":TSUpdate",
      config = function()
        require("configs.treesitter").setup()
      end,
    },

    {
      "lewis6991/gitsigns.nvim",
      keys = { "<leader>g", mode = "n" },
      event = "BufReadPre",
      config = function()
        require("configs.gitsigns").setup()
      end,
    },

    {
      "neovim/nvim-lspconfig",
      event = "BufReadPre",
      dependencies = {
        {
          "williamboman/mason.nvim",
          dependencies = "williamboman/mason-lspconfig.nvim",
          config = function()
            require("configs.mason").setup()
          end,
        },
        {
          "jose-elias-alvarez/null-ls.nvim",
          config = function()
            require("configs.null-ls").setup()
          end,
        },
        {
          "j-hui/fidget.nvim",
          config = function()
            require("configs.fidget").setup()
          end,
        },
        {
          "ray-x/lsp_signature.nvim",
          config = function()
            require("configs.lsp-signature").setup()
          end,
        },
      },
      config = function()
        require("configs.lsp").setup()
      end,
    },

    {
      "SmiteshP/nvim-navic",
      event = "VeryLazy",
      config = function()
        require("configs.navic").setup()
      end,
    },

    {
      "mfussenegger/nvim-dap",
      keys = { "<leader>d", mode = "n" },
      dependencies = "rcarriga/nvim-dap-ui",
      config = function()
        require("configs.dap").setup()
      end,
    },

    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
        {
          "L3MON4D3/LuaSnip",
          config = function()
            require("configs.luasnip").setup()
          end,
        },
      },
      config = function()
        require("configs.cmp").setup()
      end,
    },

    {
      "saecki/crates.nvim",
      event = "BufRead Cargo.toml",
      config = function()
        require("configs.crates").setup()
      end,
    },

    {
      "folke/trouble.nvim",
      keys = {
        { "<A-LeftMouse>", mode = "n" },
        { "<leader>tr", mode = "n" },
        { "<leader>l", mode = "n" },
        { "gr", mode = "n" },
        { "gi", mode = "n" },
        { "gy", mode = "n" },
      },
      dependencies = "folke/todo-comments.nvim",
      config = function()
        require("configs.trouble").setup()
      end,
    },

    {
      "simrat39/rust-tools.nvim",
      ft = "rust",
      config = function()
        require("configs.rust-tools").setup()
      end,
    },

    {
      "kylechui/nvim-surround",
      keys = {
        { "ys", mode = "n" },
        { "ds", mode = "n" },
        { "cs", mode = "n" },
        { "S", mode = "x" },
      },
      config = function()
        require("configs.nvim-surround").setup()
      end,
    },

    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("configs.autopairs").setup()
      end,
    },

    {
      "numToStr/Comment.nvim",
      keys = {
        { "gc", mode = { "n", "x" } },
        { "gb", mode = { "n", "x" } },
      },
      config = function()
        require("configs.comment").setup()
      end,
    },

    {
      "kyazdani42/nvim-tree.lua",
      keys = { "<A-n>", mode = "n" },
      config = function()
        require("configs.nvim-tree").setup()
      end,
    },

    {
      "nvim-telescope/telescope.nvim",
      keys = { "<leader>f", mode = "n" },
      dependencies = {
        {
          "nvim-telescope/telescope-dap.nvim",
          config = function()
            require("configs.telescope.dap").setup()
          end,
        },
        {
          "ahmedkhalf/project.nvim",
          config = function()
            require("configs.telescope.project").setup()
          end,
        },
      },
      config = function()
        require("configs.telescope").setup()
      end,
    },

    {
      "mrjones2014/smart-splits.nvim",
      event = "WinNew",
      dependencies = {
        {
          "sindrets/winshift.nvim",
          config = function()
            require("configs.winshift").setup()
          end,
        },
      },
      config = function()
        require("configs.smart-splits").setup()
      end,
    },

    {
      "jbyuki/venn.nvim",
      event = "VeryLazy",
      config = function()
        require("configs.venn").setup()
      end,
    },

    {
      "tpope/vim-fugitive",
      keys = { "<leader>g", mode = "n" },
      event = "BufReadPre",
      config = function()
        require("configs.fugitive").setup()
      end,
    },

    {
      "sindrets/diffview.nvim",
      keys = { "<leader>v", mode = { "n", "x" } },
      config = function()
        require("configs.diffview").setup()
      end,
    },

    {
      "ibldzn/cheat-sheet",
      event = "VeryLazy",
      config = function()
        require("configs.cheat-sheet").setup()
      end,
    },

    {
      "iamcco/markdown-preview.nvim",
      ft = "markdown",
      build = "cd app && npm install",
    },

    {
      "Krafi2/jeskape.nvim",
      event = "InsertEnter",
      config = function()
        require("configs.jeskape").setup()
      end,
    },

    {
      "mattn/emmet-vim",
      ft = {
        "html",
        "css",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      },
      config = function()
        require("configs.emmet").setup()
      end,
    },

    {
      "mfussenegger/nvim-jdtls",
      ft = "java",
      config = function()
        require("configs.nvim-jdtls").setup()
      end,
    },

    {
      "goolord/alpha-nvim",
      enabled = false,
      config = function()
        require("configs.alpha").setup()
      end,
    },

    {
      "romgrk/barbar.nvim",
      enabled = false,
      config = function()
        require("configs.barbar").setup()
      end,
    },
  }, lazy_config)
end

return M
