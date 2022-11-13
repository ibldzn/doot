local M = {}

local ns = require("null-ls")
local lspconfig = require("configs.lsp")

local fm = ns.builtins.formatting
local dg = ns.builtins.diagnostics
local ca = ns.builtins.code_actions

function M.setup()
  ns.setup({
    on_attach = lspconfig.on_attach,
    debug = false,
    sources = {
      ca.shellcheck,

      dg.eslint,
      dg.shellcheck,

      fm.black,
      fm.gofmt,
      fm.stylua,
      fm.prettier,
      fm.clang_format.with({
        extra_args = { "--fallback-style=webkit" },
      }),
      fm.shfmt.with({
        extra_args = { "--indent=2", "--case-indent" },
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
