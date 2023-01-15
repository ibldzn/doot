local function error_handler(name)
  return function(err)
    local text = "Failed to load module '" .. name .. "':\n" .. (err or "")
    vim.notify(text, vim.log.levels.ERROR)
    return err
  end
end

local function prequire(name, setup)
  local mod_ok, mod = xpcall(function()
    return require(name)
  end, error_handler(name))

  if not mod_ok then
    return
  end

  if setup ~= false then
    xpcall(mod.setup, error_handler(name))
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
