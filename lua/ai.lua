require("util")

vim.pack.add({
	{ src = "https://github.com/fang2hou/blink-copilot" },
})

local languageServersAndTools = {
	"copilot-language-server",
}

MasonCheckAndInstallPackages(languageServersAndTools)

vim.lsp.enable({ "copilot" })

-- Trigger copilot on insert
vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		local clients = vim.lsp.get_clients({ name = "copilot" })
		if #clients == 0 then
			return
		end

		local client = clients[1]
		local bufnr = vim.api.nvim_get_current_buf()
		local params = vim.lsp.util.make_position_params(0, client.offset_encoding or "utf-16")

		client:request("textDocument/inlineCompletion", params, function(err, _)
			if err then
				return
			end
		end, bufnr)
	end,
})
