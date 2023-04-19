local M = {
	"numToStr/Comment.nvim",
	dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
}

local keys = {
	{ "gc", mode = { "n", "x" }, desc = "Comment" },
	{ "gb", mode = { "n", "x" }, desc = "Block comment" },
}

local opts = {
	toggler = {
		line = "gcc",
		block = "gbc",
	},
	opleader = {
		line = "gc",
		block = "gb",
	},
	extra = {
		above = "gco",
		below = "gcO",
		eol = "gcA",
	},
	mappings = {
		basic = true,
		extra = true,
	},
	pre_hook = function(ctx)
		local U = require("Comment.utils")

		-- Determine whether to use linewise or blockwise commentstring
		local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

		-- Determine the location where to calculate commentstring from
		local location = nil
		if ctx.ctype == U.ctype.blockwise then
			location = require("ts_context_commentstring.utils").get_cursor_location()
		elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
			location = require("ts_context_commentstring.utils").get_visual_start_location()
		end

		return require("ts_context_commentstring.internal").calculate_commentstring({
			key = type,
			location = location,
		})
	end,
}

M.keys = keys
M.opts = opts

return M
