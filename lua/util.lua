local MasonRegistry = require("mason-registry")

---@param packages string[]
function MasonCheckAndInstallPackages(packages)
	MasonRegistry.refresh(function()
		for _, tool in ipairs(packages) do
			local p = MasonRegistry.get_package(tool)
			if not p:is_installed() then
				p:install()
			end
		end
	end)
end
