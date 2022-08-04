local M = {}

function M.setup(server, on_init, on_attach, capabilities)
  server.setup({
    on_init = on_init,
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      client.offset_encoding = "utf-16"
    end,
    capabilities = capabilities,
    cmd = {
      "clangd",
      "--clang-tidy",
      "--background-index",
      "--cross-file-rename",
      "--all-scopes-completion",
      "--header-insertion=iwyu",
      "--fallback-style=webkit",
      "--suggest-missing-includes",
      "--completion-style=detailed",
    },
  })
end

return M
