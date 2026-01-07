local MasonRegistry = require("mason-registry")

local languageServersAndTools = {
	"rust-analyzer",
}

MasonRegistry.refresh(function()
	for _, tool in ipairs(languageServersAndTools) do
		local p = MasonRegistry.get_package(tool)
		if not p:is_installed() then
			p:install()
		end
	end
end)

vim.lsp.enable("rust_analyzer")
vim.lsp.config("rust_analyzer", {})
