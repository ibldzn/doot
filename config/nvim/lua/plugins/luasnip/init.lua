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

	vim.api.nvim_create_autocmd("InsertLeave", {
		group = vim.api.nvim_create_augroup("LuaSnip", { clear = true }),
		callback = function(args)
			if luasnip.session.current_nodes[args.buf] and not luasnip.session.jump_active then
				luasnip.unlink_current()
			end
		end,
	})
end

M.config = config

return M
