require("util")

vim.pack.add({
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	"https://github.com/OlivierPelletier/markdown-preview.nvim",
})

local renderMarkdown = require("render-markdown")

local languageServersAndTools = {
	"marksman",
}

MasonCheckAndInstallPackages(languageServersAndTools)

vim.g.mkdp_preview_options = {
	mkit = {},
	katex = {},
	uml = {},
	maid = {},
	disable_sync_scroll = 1,
	sync_scroll_type = "middle",
	hide_yaml_meta = 1,
	sequence_diagrams = {},
	flowchart_diagrams = {},
	content_editable = false,
	disable_filename = 0,
	toc = {},
}

vim.fn["mkdp#util#install"]()

vim.lsp.config("marksman", {})
vim.lsp.enable("marksman")

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown" },
	callback = function(args)
    -- stylua: ignore start
		vim.keymap.set("n", "<leader>xm", "<cmd>MarkdownPreview<CR>", { desc = "Markdown Preview", buffer = args.buf })
		Snacks.toggle({ name = "Markdown Rendering", get = renderMarkdown.get, set = renderMarkdown.set, }):map("<leader>um", { buffer = args.buf })
		-- stylua: ignore end
	end,
})
