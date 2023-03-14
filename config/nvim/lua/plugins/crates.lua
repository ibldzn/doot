local M = {
	"saecki/crates.nvim",
	event = "BufRead Cargo.toml",
	dependencies = "nvim-lua/plenary.nvim",
}

local config = function()
	local crates = require("crates")
	local wk = require("which-key")
	local shared = require("config.shared")

	crates.setup({
		popup = {
			border = shared.window.border,
			show_version_date = true,
		},
		null_ls = {
			enabled = true,
		},
	})

	wk.register({
		["<leader>C"] = {
			name = "Crates",
			["t"] = { crates.toggle, "Toggle" },
			["r"] = { crates.reload, "Reload" },

			["v"] = { crates.show_versions_popup, "Versions popup" },
			["f"] = { crates.show_features_popup, "Features popup" },
			["d"] = { crates.show_dependencies_popup, "Dependencies popup" },

			["u"] = { crates.update_crate, "Update crate" },
			["U"] = { crates.upgrade_crate, "Upgrade crate" },
			["a"] = { crates.update_all_crates, "Update all crates" },
			["A"] = { crates.upgrade_all_crates, "Upgrade all crates" },

			["H"] = { crates.open_homepage, "Open homepage" },
			["R"] = { crates.open_repository, "Open repository" },
			["D"] = { crates.open_documentation, "Open documentation" },
			["C"] = { crates.open_crates_io, "Open crates.io" },
		},
	})
end

M.config = config

return M
