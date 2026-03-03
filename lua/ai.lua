require("util")

vim.pack.add({
	{ src = "https://github.com/fang2hou/blink-copilot" },
	{ src = "https://github.com/ThePrimeagen/99" },
	{ src = "https://github.com/folke/sidekick.nvim" },
})

local languageServersAndTools = {
	"copilot-language-server",
}

MasonCheckAndInstallPackages(languageServersAndTools)

local NineNine = require("99")
local Sidekick = require("sidekick")
local SidekickCli = require("sidekick.cli")
local Blink = require("blink.cmp")

-- stylua: ignore start
vim.keymap.set("n", "<leader>9l", function() NineNine.view_logs() end, { desc = "99 Logs" })
vim.keymap.set("n", "<leader>9s", function() NineNine.search() end, { desc = "99 Search" })
vim.keymap.set("n", "<leader>9t", function() NineNine.open() end, { desc = "99 Tutorial" })
vim.keymap.set("n", "<leader>aa", function() SidekickCli.toggle({ name = "opencode", focus = true }) end, { desc = "Sidekick Toggle CLI" })
vim.keymap.set("n", "<leader>ap", function() SidekickCli.prompt() end, { desc = "Sidekick Toggle Prompts" })
vim.keymap.set("v", "<leader>9f", function() NineNine.visual() end, { desc = "99 Visual Fill In" })
vim.keymap.set({ "n", "s" }, "<leader>9x", function() NineNine.stop_all_requests() end, { desc = "99 Stop All Request" })
vim.keymap.set({ "n", "t", "i", "x" }, "<C-.>", function() SidekickCli.toggle({ name = "opencode", focus = true }) end, { desc = "Sidekick Toggle CLI" })
vim.keymap.set({ "n", "t", "i", "x" }, "<M-ù>", function() SidekickCli.toggle({ name = "opencode", focus = true }) end, { desc = "Sidekick Toggle CLI" })
-- stylua: ignore end

NineNine.setup({
	completion = nil,
	md_files = {
		"AGENTS.md",
	},
  provider = NineNine.Providers.OpenCodeProvider,
	model = "github-copilot/gpt-5.2-codex",
})
Sidekick.setup({
	nes = {
		enabled = false,
	},
	cli = {
		win = {
			layout = "float",
			float = {
				width = 1.0,
				height = 1.0,
			},
		},
		mux = {
			backend = "zellij",
			enabled = true,
		},
	},
})

Blink.add_source_provider("copilot", {
	name = "copilot",
	module = "blink-copilot",
	async = true,
})

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
