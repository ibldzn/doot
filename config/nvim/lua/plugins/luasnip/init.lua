local M = {
	"L3MON4D3/LuaSnip",
}

local config = function()
	local wk = require("which-key")
	local luasnip = require("luasnip")

	luasnip.config.setup({
		updateevents = "InsertLeave,TextChanged,TextChangedI",
	})

	wk.register({
		["<Tab>"] = {
			function()
				if luasnip.jumpable(1) then
					luasnip.jump(1)
				end
			end,
			"Jump to next snippet input",
		},
		["<S-Tab>"] = {
			function()
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				end
			end,
			"Jump to previous snippet input",
		},
	}, {
		mode = "v",
	})

	require("luasnip.loaders.from_vscode").lazy_load()
	local snippets = vim.fn.stdpath("config") .. "/lua/plugins/luasnip/snippets"
	require("luasnip.loaders.from_lua").load({ paths = snippets })

	luasnip.filetype_extend("javascript", { "javascriptreact" })
	luasnip.filetype_extend("typescript", { "typescriptreact" })
end

M.config = config

return M
