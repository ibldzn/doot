local M = {
	"mfussenegger/nvim-jdtls",
	ft = { "java" },
}

local config = function()
	local jdtls_path
	-- check if jdtls is in path
	if vim.fn.executable("jdtls") == 1 then
		jdtls_path = "jdtls"
	else
		local jdtls = require("mason-registry").get_package("jdtls")
		if jdtls == nil then
			error("jdtls not found in path or registry")
		end
		jdtls_path = jdtls:get_install_path()
	end

	local util = require("util")
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

	local config = {
		cmd = {
			"java",
			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-Xmx1g",
			"--add-modules=ALL-SYSTEM",
			"--add-opens",
			"java.base/java.util=ALL-UNNAMED",
			"--add-opens",
			"java.base/java.lang=ALL-UNNAMED",

			"-jar",
			jdtls_path .. "/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",

			"-configuration",
			jdtls_path .. (util.is_windows() and "/config_win" or "/config_linux"),

			"-data",
			vim.fn.stdpath("data") .. "/jdtls/" .. project_name,
		},
	}

	require("jdtls").start_or_attach(config)
end

M.config = config

return M
