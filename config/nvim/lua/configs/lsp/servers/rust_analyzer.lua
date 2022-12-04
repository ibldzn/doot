local M = {}

local KIND = {
  OTHER = 1,
  PARAM_HINTS = 2,
}

local namespace = vim.api.nvim_create_namespace("configs.lsp.server.rust_analyzer")

local function inlay_hints_handler(err, result, ctx)
  if err then
    return
  end

  vim.api.nvim_buf_clear_namespace(ctx.bufnr, namespace, 0, -1)

  local prefix = " "
  local highlight = "NonText"
  local hints = {}
  for _, item in ipairs(result) do
    if item.kind == KIND.OTHER then
      local line = tonumber(item.position.line)
      hints[line] = hints[line] or {}

      local text = item.label:gsub(": ", "")
      table.insert(hints[line], prefix .. text)
    end
  end

  for l, t in pairs(hints) do
    local text = table.concat(t, " ")
    vim.api.nvim_buf_set_extmark(ctx.bufnr, namespace, l, 0, {
      virt_text = { { text, highlight } },
      virt_text_pos = "eol",
      hl_mode = "combine",
    })
  end
end

local function inlay_hints()
  local bufnr = vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(bufnr) - 1
  local last_line = vim.api.nvim_buf_get_lines(bufnr, line_count, line_count + 1, true)

  local params = {
    textDocument = vim.lsp.util.make_text_document_params(bufnr),
    range = {
      start = {
        line = 0,
        character = 0,
      },
      ["end"] = {
        line = line_count,
        character = #last_line[1],
      },
    },
  }

  vim.lsp.buf_request(0, "textDocument/inlayHint", params, inlay_hints_handler)
end

function M.setup(server, on_init, on_attach, capabilities)
  local function m_on_attach(client, buf)
    on_attach(client, buf)

    local old_progress_handler = vim.lsp.handlers["$/progress"]
    vim.lsp.handlers["$/progress"] = function(err, result, ctx, config)
      if old_progress_handler then
        old_progress_handler(err, result, ctx, config)
      end

      if result.value and result.value.kind == "end" then
        inlay_hints()
      end
    end

    local group = vim.api.nvim_create_augroup("LspInlayHints", {})
    vim.api.nvim_create_autocmd({
      "TextChanged",
      "TextChangedI",
      "TextChangedP",
      "BufEnter",
      "BufWinEnter",
      "TabEnter",
      "BufWritePost",
    }, {
      group = group,
      buffer = buf,
      callback = inlay_hints,
    })

    inlay_hints()
  end

  server.setup({
    on_init = on_init,
    on_attach = m_on_attach,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importEnforceGranularity = true,
          importGranularity = "module",
          importPrefix = "plain",
        },
        inlayHints = {
          maxLength = 40,
        },
      },
    },
  })
end

return M
