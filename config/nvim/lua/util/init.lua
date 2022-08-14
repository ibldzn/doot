local M = {}

if jit ~= nil then
  M.is_windows = jit.os == "Windows"
else
  M.is_windows = package.config:sub(1, 1) == "\\"
end

function M.path_separator()
  if M.is_windows then
    return "\\"
  end
  return "/"
end

function M.join_paths(...)
  local separator = M.path_separator()
  return table.concat({ ... }, separator)
end

function M.wrap(fun, ...)
  local args = { ... }
  return function()
    return fun(unpack(args))
  end
end

function M.format_buffer(opts)
  opts = opts or {}

  if not vim.g.format_on_save and not opts.force then
    return
  end

  vim.lsp.buf.format({
    filter = function(client)
      return client.name == "null-ls"
    end,
  })
end

function M.append_at_eol(char)
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd.normal("A" .. char)
  vim.api.nvim_win_set_cursor(0, pos)
end

return M
