return {
	"nvim-lua/plenary.nvim",
	"nvim-tree/nvim-web-devicons",

	{
		"nvim-neo-tree/neo-tree.nvim",
		keys = { { "<A-n>", "<cmd>Neotree toggle reveal_force_cwd<CR>", desc = "Neotree" } },
		opts = {
			enable_git_status = false,
			window = {
				width = 30,
				position = "right",
			},
			filesystem = { filtered_items = { hide_dotfiles = false } },
		},
		init = function()
			vim.g.neo_tree_remove_legacy_commands = true
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
	},

	{
		"farmergreg/vim-lastplace",
		event = "BufReadPost",
	},

	{
		"andymass/vim-matchup",
		dependencies = "nvim-treesitter/nvim-treesitter",
		event = "BufReadPost",
		init = function()
			vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
		end,
	},

	{
		"mg979/vim-visual-multi",
		keys = {
			{ "<C-n>", desc = "Select next word", mode = { "n", "x" } },
			{ "<C-Up>", desc = "Add cursor above" },
			{ "<C-Down>", desc = "Add cursor below" },
		},
		init = function()
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
		"mbbill/undotree",
		keys = {
			{ "<C-c>", vim.cmd.UndotreeToggle, desc = "Toggle undo tree" },
		},
		init = function()
			vim.g.undotree_WindowLayout = 2
			vim.g.undotree_SetFocusWhenToggle = true
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		event = "BufReadPre",
		opts = {
			char = "⎸",
			show_trailing_blankline_indent = false,
			use_treesitter = true,
			filetype_exclude = {
				"NvimTree",
				"Trouble",
				"help",
				"man",
				"mason",
				"packer",
			},
		},
	},

	{
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		build = "cd app && npm install",
	},

	{
		"alanfortlink/blackjack.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		opts = { card_style = "mini" },
		cmd = {
			"BlackJackNewGame",
			"BlackJackQuit",
			"BlackJackResetScores",
		},
	},

	{
		"tommcdo/vim-lion",
		keys = {
			{ "gl" },
			{ "gL" },
		},
		init = function()
			vim.g.lion_squeeze_spaces = 1
		end,
	},
}
