local M = {}

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  return
end

local luasnip_ok, luasnip = pcall(require, "luasnip")
if not luasnip_ok then
  return
end

function M.setup()
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

  local function add(lang)
    luasnip.add_snippets(lang, require("configs.luasnip.lang." .. lang))
  end

  require("luasnip.loaders.from_vscode").lazy_load()

  add("go")
  add("lua")
  add("cmake")
  add("markdown")
end

return M
