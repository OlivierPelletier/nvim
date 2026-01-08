require("util")

local languageServersAndTools = {
	"rust-analyzer",
}

MasonCheckAndInstallPackages(languageServersAndTools)

vim.lsp.config("rust_analyzer", {})
vim.lsp.enable("rust_analyzer")
