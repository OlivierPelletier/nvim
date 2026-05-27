local languageServersAndTools = {
	"htmx-lsp",
}

MasonCheckAndInstallPackages(languageServersAndTools)

vim.lsp.enable("htmx")
