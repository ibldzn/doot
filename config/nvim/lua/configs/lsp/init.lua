local M = {}

local wk = require("which-key")
local shared = require("shared")
local util = require("util")
local navic = require("nvim-navic")

local DOCUMENT_HIGHLIGHT_HANDLER = vim.lsp.handlers["textDocument/documentHighlight"]
local VIM_NOTIFY = vim.notify

function M.get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem = {
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = {
      valueSet = { 1 },
    },
    resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    },
  }
  capabilities.window = {
    workDoneProgress = true,
  }
  return capabilities
end

function M.on_init(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

function M.on_attach(client, buf)
  if client.supports_method("textDocument/documentSymbolProvider") then
    navic.attach(client, buf)
  end

  -- Occurences
  if client.supports_method("textDocument/documentHighlight") then
    local group = vim.api.nvim_create_augroup("ConfigLspOccurences", { clear = false })
    vim.api.nvim_clear_autocmds({ buffer = buf, group = group })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = group,
      buffer = buf,
      callback = vim.lsp.buf.document_highlight,
    })
  end

  if client.supports_method("textDocument/formatting") then
    local group = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
    vim.api.nvim_clear_autocmds({ buffer = buf, group = group })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = group,
      buffer = buf,
      callback = util.format_buffer,
    })
  end

  if client.supports_method("textDocument/colorProvider") then
    vim.cmd.CccHighlighterEnable()
  end

  wk.register({
    ["<S-A-f>"] = { util.wrap(util.format_buffer, { force = true }), "Format current buffer" },
    ["<S-A-k>"] = { vim.lsp.buf.signature_help, "Signature help" },
    ["g"] = {
      name = "Go",
      ["d"] = { vim.lsp.buf.definition, "LSP definition" },
      ["D"] = { vim.lsp.buf.declaration, "LSP declaration" },
    },
    ["<leader>"] = {
      ["t"] = {
        name = "Toggle",
        ["d"] = { vim.diagnostic.open_float, "Diagnostic on cursor" },
      },
      ["a"] = { vim.lsp.buf.code_action, "Code action" },
      ["r"] = {
        function()
          require("util.input").input(nil, true, function(new_name)
            vim.lsp.buf.rename(new_name)
          end)
        end,
        "Refactor keep name",
      },
      ["R"] = {
        function()
          require("util.input").input("", true, function(new_name)
            vim.lsp.buf.rename(new_name)
          end)
        end,
        "Refactor clear name",
      },
    },
  }, {
    buffer = buf,
  })

  wk.register({
    ["<leader>"] = {
      ["a"] = { vim.lsp.buf.code_action, "Range code action" },
    },
  }, {
    mode = "x",
    buffer = buf,
  })
end

function M.show_documentation()
  local filetype = vim.bo.filetype
  if vim.tbl_contains({ "vim", "help" }, filetype) then
    vim.cmd.h(vim.fn.expand("<cword>"))
  elseif vim.tbl_contains({ "man" }, filetype) then
    vim.cmd.Man(vim.fn.expand("<cword>"))
  elseif vim.fn.expand("%:t") == "Cargo.toml" then
    require("crates").show_popup()
  elseif vim.tbl_contains({ "rust" }, filetype) then
    require("rust-tools").hover_actions.hover_actions()
  else
    vim.lsp.buf.hover()
  end
end

M.servers = {
  { name = "bashls" },
  { name = "clangd" },
  { name = "cmake" },
  { name = "cssls" },
  { name = "dartls", use_mason = false },
  { name = "gopls" },
  { name = "html" },
  { name = "jsonls" },
  { name = "pyright" },
  { name = "rust_analyzer" },
  { name = "sumneko_lua" },
  { name = "tailwindcss" },
  { name = "tsserver" },
}

function M.setup()
  vim.notify = function(msg, ...)
    if not msg:find("No information available") then
      return VIM_NOTIFY(msg, ...)
    end
  end

  local lspconfig = require("lspconfig")
  local capabilities = M.get_capabilities()

  for _, server in ipairs(M.servers) do
    local ok, sv = pcall(require, "configs.lsp.servers." .. server.name)
    if ok then
      sv.setup(lspconfig[server.name], M.on_init, M.on_attach, capabilities)
    else
      lspconfig[server.name].setup({
        on_init = M.on_init,
        on_attach = M.on_attach,
        capabilities = capabilities,
      })
    end
  end

  -- Diagnostics
  vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      virtual_text = {
        spacing = 2,
        severity_limit = "Warning",
      },
    })

  -- Occurences
  vim.lsp.handlers["textDocument/documentHighlight"] = function(...)
    vim.lsp.buf.clear_references()
    DOCUMENT_HIGHLIGHT_HANDLER(...)
  end

  -- Documentation window border
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = shared.window.border,
  })

  -- Show documentation
  wk.register({
    ["K"] = { M.show_documentation, "Show documentation" },
    ["<leader>i"] = {
      name = "Lsp",
      ["s"] = { vim.cmd.LspStart, "Start" },
      ["r"] = { vim.cmd.LspRestart, "Restart" },
      ["t"] = { vim.cmd.LspStop, "Stop" },
      ["i"] = { vim.cmd.LspInfo, "Info" },
      ["I"] = { vim.cmd.Mason, "Install Info" },
      ["l"] = { vim.cmd.MasonLog, "Install Log" },
    },
  })
end

return M
