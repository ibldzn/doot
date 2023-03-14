local M = {
	"L3MON4D3/LuaSnip",
}

local cmake = {
	name = "cmake",
	snippets = function()
		local luasnip = require("luasnip")
		local s = luasnip.snippet
		local t = luasnip.text_node
		local i = luasnip.insert_node
		return {
			s("addex", {
				t({ "add_executable(" }),
				i(1, { "${PROJECT_NAME}" }),
				t({ "", "  " }),
				i(2, { "" }),
				t({ "", ")" }),
			}),
			s("addlib", {
				t({ "add_library(" }),
				i(1, { "${PROJECT_NAME}" }),
				t({ " " }),
				i(2, { "STATIC" }),
				t({ "", "  " }),
				i(3, { "" }),
				t({ "", ")" }),
			}),
		}
	end,
}

local go = {
	name = "go",
	snippets = function()
		local luasnip = require("luasnip")
		local s = luasnip.snippet
		local t = luasnip.text_node
		local i = luasnip.insert_node

		return {
			s("main", {
				t({ "package main", "", "" }),
				t({ "func main() {", "\t" }),
				i(0, { "" }),
				t({ "", "}" }),
			}),
			s("ien", {
				t({ "if err != nil {", "\t" }),
				i(0, { "" }),
				t({ "", "}" }),
			}),
		}
	end,
}

local lua = {
	name = "lua",
	snippets = function()
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
	end,
}

local markdown = {
	name = "markdown",
	snippets = function()
		local luasnip = require("luasnip")
		local s = luasnip.snippet
		local t = luasnip.text_node

		return {
			s("forall", t("∀")),
			s("exists", t("∃")),
			s("in", t("∈")),
			s("notin", t("∉")),
			s("subset", t("⊆")),
			s("subsetnoteq", t("⊂")),
			s("intersect", t("∩")),
			s("union", t("∪")),
			s("setmin", t("∖")),

			s("land", t("∧")),
			s("lor", t("∨")),
			s("xor", t("⊻")),
		}
	end,
}

local langs_snippet = {
	cmake,
	go,
	lua,
	markdown,
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

	local add = function(lang)
		require("luasnip").add_snippets(lang.name, lang.snippets())
	end

	for _, lang in ipairs(langs_snippet) do
		add(lang)
	end
end

M.config = config

return M
