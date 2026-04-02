---@param packages string[]
function MasonCheckAndInstallPackages(packages)
	local MasonRegistry = require("mason-registry")

	MasonRegistry.refresh(function()
		for _, tool in ipairs(packages) do
			local p = MasonRegistry.get_package(tool)
			if not p:is_installed() then
				p:install()
			end
		end
	end)
end

---@param module_name string
---@return any|nil
function safe_require(module_name)
	local ok, module_or_error = xpcall(require, function(err)
		return debug.traceback(tostring(err), 2)
	end, module_name)

	if ok then
		return module_or_error
	end

	local state_dir = vim.fn.stdpath("state")
	local log_file = state_dir .. "/safe-require.log"
	local log_lines = {
		string.format("[%s] safe_require failed for %q", os.date("%Y-%m-%d %H:%M:%S"), module_name),
		module_or_error,
		"",
	}

	local write_ok, write_err = pcall(function()
		vim.fn.mkdir(state_dir, "p")
		vim.fn.writefile(log_lines, log_file, "a")
	end)

	local message = string.format("safe_require: failed to load %q", module_name)
	if write_ok then
		message = string.format("%s (see %s)", message, log_file)
	else
		message = string.format("%s (could not write log: %s)", message, tostring(write_err))
	end

	vim.schedule(function()
		vim.notify(message, vim.log.levels.ERROR)
	end)

	return nil
end
