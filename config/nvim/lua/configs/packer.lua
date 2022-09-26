local M = {}

local packer = require("packer")
local wk = require("which-key")
local shared = require("shared")
local util = require("util")

local function snapshot(name)
  if not name then
    name = vim.fn.input("snapshot name: ", shared.packer.snapshot_version)
  end

  if name == "" then
    vim.notify("invalid snapshot name!", vim.log.levels.ERROR)
    return
  end

  packer.snapshot(name)

  local function format_snapshot()
    local path = util.join_paths(shared.packer.snapshot_path, name)
    local tmp_path = util.join_paths(shared.packer.snapshot_path, name .. "_tmp")
    os.execute("jq --sort-keys . " .. path .. " > " .. tmp_path)
    os.rename(tmp_path, path)
  end
  vim.defer_fn(format_snapshot, 1000)
end

function M.setup()
  wk.register({
    ["<leader>p"] = {
      name = "Packer",
      ["c"] = { vim.cmd.PackerCompile, "Compile" },
      ["i"] = { vim.cmd.PackerInstall, "Install" },
      ["s"] = { vim.cmd.PackerSync, "Sync" },
      ["S"] = { vim.cmd.PackerStatus, "Status" },
      ["u"] = { vim.cmd.PackerUpdate, "Update" },
      ["b"] = { snapshot, "Backup (snapshot)" },
    },
  })
end

return M
