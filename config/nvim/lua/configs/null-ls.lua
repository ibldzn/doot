local M = {}

local ns = require("null-ls")
local lspconfig = require("configs.lsp")

local fm = ns.builtins.formatting
local dg = ns.builtins.diagnostics

function M.setup()
  ns.setup({
    on_attach = lspconfig.on_attach,
    debug = false,
    sources = {
      dg.eslint,
      dg.shellcheck,

      fm.black,
      fm.gofmt,
      fm.stylua,
      fm.prettier,
      fm.clang_format.with({
        extra_args = { "--fallback-style=webkit" },
      }),
      fm.rustfmt.with({
        args = {
          "+nightly",
          "--unstable-features",
          "--edition=2021",
          "--emit=stdout",
        },
      }),
    },
  })
end

return M
