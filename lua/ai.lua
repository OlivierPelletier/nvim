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

local nineNine = require("99")
local sidekick = require("sidekick")
local sidekickCli = require("sidekick.cli")

-- stylua: ignore start
vim.keymap.set("n", "<leader>aa", function() sidekickCli.toggle({ name = "opencode" }) end, { desc = "Sidekick Toggle CLI" })
vim.keymap.set({ "n", "t", "i", "x" }, "<C-.>", function() sidekickCli.toggle({ name = "opencode" }) end, { desc = "Sidekick Toggle CLI" })
vim.keymap.set({ "n", "t", "i", "x" }, "<M-ù>", function() sidekickCli.toggle({ name = "opencode" }) end, { desc = "Sidekick Toggle CLI" })
-- stylua: ignore end

nineNine.setup({
	logger = {
		level = nineNine.DEBUG,
		path = "/tmp/" .. vim.fs.basename(vim.uv.cwd()) .. ".99.debug",
		print_on_error = true,
	},
	completion = nil,
	md_files = {
		"AGENT.md",
	},
	model = "github-copilot/gpt-5.2-codex",
})
sidekick.setup({
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
	},
	mux = {
		backend = "zellij",
		enabled = true,
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "lua" },
	callback = function(args)
    -- stylua: ignore start
		vim.keymap.set("n", "<leader>9f", function() nineNine.fill_in_function() end, { desc = "99 Fill In", buffer = args.buf })
		vim.keymap.set("n", "<leader>9F", function() nineNine.fill_in_function_prompt() end, { desc = "99 Fill In Prompt", buffer = args.buf })
		vim.keymap.set("v", "<leader>9f", function() nineNine.visual() end, { desc = "99 Visual Fill In", buffer = args.buf })
		vim.keymap.set("v", "<leader>9F", function() nineNine.visual_prompt() end, { desc = "99 Visual Fill In Prompt", buffer = args.buf })
		vim.keymap.set({ "n", "s" }, "<leader>9s", function() nineNine.stop_all_requests() end, { desc = "99 Stop All Request", buffer = args.buf })
		-- stylua: ignore end
	end,
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
