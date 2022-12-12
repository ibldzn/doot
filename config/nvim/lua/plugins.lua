local M = {}

local function bootstrap_packer()
  local util = require("util")
  local install_path = vim.fn.stdpath("data")
    .. util.path_separator()
    .. util.join_paths("site", "pack", "packer", "start", "packer.nvim")

  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify("Cloning packer..")

    BOOTSTRAPPED = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })

    vim.cmd.packadd("packer.nvim")
  end
end

function M.setup()
  bootstrap_packer()

  -- load before other plugins
  local notify_ok, notify = pcall(require, "notify")
  if notify_ok then
    vim.notify = notify
  end

  local packer_ok, packer = pcall(require, "packer")
  if not packer_ok then
    vim.notify("packer isn't installed", vim.log.levels.ERROR)
    return
  end

  local packer_compiled_ok, _ = pcall(require, "packer_compiled")
  if not packer_compiled_ok then
    vim.notify("compiled packer config wasn't found", vim.log.levels.ERROR)
  end

  local shared = require("shared")

  packer.startup({
    function(use)
      use("andymass/vim-matchup")
      use("nvim-lua/plenary.nvim")
      use("farmergreg/vim-lastplace")
      use("lewis6991/impatient.nvim")
      use("kyazdani42/nvim-web-devicons")
      use("krady21/compiler-explorer.nvim")

      use({
        "wbthomason/packer.nvim",
        config = function()
          require("configs.packer").setup()
        end,
      })

      use({
        "rcarriga/nvim-notify",
        config = function()
          require("configs.notify").setup()
        end,
      })

      use({
        "folke/which-key.nvim",
        config = function()
          require("configs.which-key").setup()
        end,
      })

      use({
        "mbbill/undotree",
        config = function()
          require("configs.undotree").setup()
        end,
      })

      use({
        "nvim-lualine/lualine.nvim",
        config = function()
          require("configs.lualine").setup()
        end,
      })

      use({
        "lukas-reineke/indent-blankline.nvim",
        config = function()
          require("configs.indent-blankline").setup()
        end,
      })

      use({
        "uga-rosa/ccc.nvim",
        config = function()
          require("configs.colorizer").setup()
        end,
      })

      use({
        "windwp/nvim-spectre",
        config = function()
          require("configs.spectre").setup()
        end,
      })

      use({
        "phaazon/hop.nvim",
        config = function()
          require("configs.hop").setup()
        end,
      })

      use({
        "nvim-treesitter/nvim-treesitter",
        requires = {
          "windwp/nvim-ts-autotag",
          "nvim-treesitter/playground",
          "nvim-treesitter/nvim-treesitter-context",
          "JoosepAlviste/nvim-ts-context-commentstring",
          "nvim-treesitter/nvim-treesitter-textobjects",
        },
        run = ":TSUpdate",
        config = function()
          require("configs.treesitter").setup()
        end,
      })

      use({
        "lewis6991/gitsigns.nvim",
        config = function()
          require("configs.gitsigns").setup()
        end,
      })

      use({
        "williamboman/mason.nvim",
        after = "mason-lspconfig.nvim",
        requires = "williamboman/mason-lspconfig.nvim",
        config = function()
          require("configs.mason").setup()
        end,
      })

      use({
        "neovim/nvim-lspconfig",
        after = "mason.nvim",
        config = function()
          require("configs.lsp").setup()
        end,
      })

      use({
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require("configs.null-ls").setup()
        end,
      })

      use({
        "SmiteshP/nvim-navic",
        config = function()
          require("configs.navic").setup()
        end,
      })

      use({
        "j-hui/fidget.nvim",
        config = function()
          require("configs.fidget").setup()
        end,
      })

      use({
        "ray-x/lsp_signature.nvim",
        config = function()
          require("configs.lsp-signature").setup()
        end,
      })

      use({
        "mfussenegger/nvim-dap",
        requires = "rcarriga/nvim-dap-ui",
        config = function()
          require("configs.dap").setup()
        end,
      })

      use({
        "hrsh7th/nvim-cmp",
        requires = {
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
      })

      use({
        "saecki/crates.nvim",
        event = "BufRead Cargo.toml",
        config = function()
          require("configs.crates").setup()
        end,
      })

      use({
        "folke/trouble.nvim",
        requires = "folke/todo-comments.nvim",
        config = function()
          require("configs.trouble").setup()
        end,
      })

      use({
        "simrat39/rust-tools.nvim",
        ft = "rust",
        config = function()
          require("configs.rust-tools").setup()
        end,
      })

      use({
        "kylechui/nvim-surround",
        config = function()
          require("configs.nvim-surround").setup()
        end,
      })

      use({
        "windwp/nvim-autopairs",
        config = function()
          require("configs.autopairs").setup()
        end,
      })

      use({
        "numToStr/Comment.nvim",
        config = function()
          require("configs.comment").setup()
        end,
      })

      use({
        "kyazdani42/nvim-tree.lua",
        config = function()
          require("configs.nvim-tree").setup()
        end,
      })

      use({
        "nvim-telescope/telescope.nvim",
        requires = {
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
      })

      use({
        "sindrets/winshift.nvim",
        config = function()
          require("configs.winshift").setup()
        end,
      })

      use({
        "mrjones2014/smart-splits.nvim",
        config = function()
          require("configs.smart-splits").setup()
        end,
      })

      use({
        "jbyuki/venn.nvim",
        config = function()
          require("configs.venn").setup()
        end,
      })

      use({
        "tpope/vim-fugitive",
        config = function()
          require("configs.fugitive").setup()
        end,
      })

      use({
        "sindrets/diffview.nvim",
        config = function()
          require("configs.diffview").setup()
        end,
      })

      use({
        "ibldzn/cheat-sheet",
        config = function()
          require("configs.cheat-sheet").setup()
        end,
      })

      use({
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        run = "cd app && npm install",
      })

      use({
        "Krafi2/jeskape.nvim",
        config = function()
          require("configs.jeskape").setup()
        end,
      })

      use({
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
      })

      use({
        "mfussenegger/nvim-jdtls",
        ft = "java",
        config = function()
          require("configs.nvim-jdtls").setup()
        end,
      })

      use({
        "goolord/alpha-nvim",
        disable = true,
        config = function()
          require("configs.alpha").setup()
        end,
      })

      use({
        "romgrk/barbar.nvim",
        disable = true,
        config = function()
          require("configs.barbar").setup()
        end,
      })

      if BOOTSTRAPPED then
        packer.sync()
      end
    end,

    config = {
      compile_path = shared.packer.compile_path,
      snapshot_path = shared.packer.snapshot_path,
    },
  })
end

return M
