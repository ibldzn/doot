local M = {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
		"L3MON4D3/LuaSnip",
	},
}

local kind_icons = {
	["Class"] = "🅒 ",
	["Interface"] = "🅘 ",
	["TypeParameter"] = "🅣 ",
	["Struct"] = "🅢",
	["Enum"] = "🅔 ",
	["Unit"] = "🅤 ",
	["EnumMember"] = "🅔 ",
	["Constant"] = "🅒 ",
	["Field"] = "🅕 ",
	["Property"] = " ",
	["Variable"] = "🅥 ",
	["Reference"] = "🅡 ",
	["Function"] = "🅕 ",
	["Method"] = "🅜 ",
	["Constructor"] = "🅒 ",
	["Module"] = "🅜 ",
	["File"] = "🅕 ",
	["Folder"] = "🅕 ",
	["Keyword"] = "🅚 ",
	["Operator"] = "🅞 ",
	["Snippet"] = "🅢 ",
	["Value"] = "🅥 ",
	["Color"] = "🅒 ",
	["Event"] = "🅔 ",
	["Text"] = "🅣 ",
}

local ELLIPSIS_CHAR = "…"
local MAX_LABEL_WIDTH = 25

local get_ws = function(max, len)
	return (" "):rep(max - len)
end

local format = function(_, item)
	local content = item.abbr
	local kind_symbol = kind_icons[item.kind] or "  "
	item.menu = item.kind
	item.kind = kind_symbol

	if #content > MAX_LABEL_WIDTH then
		item.abbr = vim.fn.strcharpart(content, 0, MAX_LABEL_WIDTH) .. ELLIPSIS_CHAR
	else
		item.abbr = content .. get_ws(MAX_LABEL_WIDTH, #content)
	end

	return item
end

local config = function()
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	local shared = require("config.shared")

	---@diagnostic disable-next-line: redundant-parameter
	cmp.setup({
		window = {
			completion = {
				col_offset = -3,
			},
			documentation = {
				border = shared.window.border,
				winhighlight = "Pmenu:Pmenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
				zindex = 1001,
			},
		},
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = format,
		},
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = {
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.jumpable(1) then
					luasnip.jump(1)
				else
					fallback()
				end
			end),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end),
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-u>"] = cmp.mapping.scroll_docs(-4),
			["<C-d>"] = cmp.mapping.scroll_docs(4),
			["<C-space>"] = cmp.mapping.complete(),
			["<C-q>"] = cmp.mapping({
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			}),
			["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			}),
		},
		sources = {
			{ name = "nvim_lsp" },
			{ name = "nvim_lua" },
			{ name = "crates" },
			{ name = "luasnip" },
			{ name = "path" },
			{ name = "buffer" },
		},
		experimental = {
			native_menu = false,
			ghost_text = true,
		},
	})

	cmp.event:on("menu_opened", function()
		vim.b.copilot_suggestion_hidden = true
	end)

	cmp.event:on("menu_closed", function()
		vim.b.copilot_suggestion_hidden = false
	end)
end

M.config = config

return M
