local M = {}

local notify_ok, notify = pcall(require, "notify")
if not notify_ok then
  return
end

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  return
end

function M.setup()
  wk.register({
    ["<leader>n"] = {
      name = "Notification",
      ["d"] = { notify.dismiss, "Dismiss" },
      ["h"] = { notify._print_history, "History" },
    },
  })
end

return M
