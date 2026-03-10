require("util")

vim.pack.add({
	{ src = "https://github.com/mistweaverco/kulala.nvim" },
})

local Kulala = require("kulala")

Kulala.setup({
	global_keymaps = false,
	global_keymaps_prefix = "<leader>R",
	kulala_keymaps_prefix = "",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "http", "rest" },
	callback = function(args)
		-- stylua: ignore start
		vim.keymap.set({ "n", "v" }, "<leader>Rs", function() Kulala.run() end, { desc = "Send request", buffer = args.buf })
		vim.keymap.set({ "n", "v" }, "<leader>Ra", function() Kulala.run_all() end, { desc = "Send all requests", buffer = args.buf })
		vim.keymap.set("n", "<leader>Rb", function() Kulala.scratchpad() end, { desc = "Open scratchpad", buffer = args.buf })
		-- stylua: ignore end
	end,
})
