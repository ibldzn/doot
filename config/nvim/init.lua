local function prequire(name, setup)
  local function error_handler(err)
    return err
  end

  local mod_ok, mod = xpcall(function()
    return require(name)
  end, error_handler)

  if not mod_ok then
    vim.notify("Failed to load config module " .. name, vim.log.levels.ERROR .. "\n" .. (mod or ""))
    return
  end

  if setup ~= false then
    local setup_ok, res = xpcall(mod.setup, error_handler)

    if not setup_ok then
      vim.notify("Failed to setup config module " .. name, vim.log.levels.ERROR .. "\n" .. res)
    end
  end

  return mod
end

prequire("options")
prequire("plugins")
prequire("mappings")
prequire("colors")
prequire("autocmds")
prequire("custom_commands")
prequire("diagnostics")
prequire("util.select")
