require("util")
vim.pack.add({
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/OlivierPelletier/markdown-preview.nvim"
})

local languageServersAndTools = {
	"marksman",
}

MasonCheckAndInstallPackages(languageServersAndTools)

vim.fn["mkdp#util#install"]()

vim.lsp.config("marksman", {})
vim.lsp.enable("marksman")
