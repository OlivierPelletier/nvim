vim.lsp.config("bacon_ls", {
	servers = {
		bacon_ls = {
			enabled = true,
		},
		rust_analyzer = { enabled = false },
	},
})
