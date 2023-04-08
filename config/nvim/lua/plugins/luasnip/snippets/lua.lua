local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

return {
	s("wk", t('local wk = require("which-key")')),

	s("require", {
		t({ 'require("' }),
		i(0, { "mod" }),
		t({ '")' }),
	}),

	s("module", {
		t({ "local M = {}", "", "local setup = function()", "\t" }),
		i(0, { "" }),
		t({ "", "end", "", "M.setup = setup", "", "return M" }),
	}),
}
