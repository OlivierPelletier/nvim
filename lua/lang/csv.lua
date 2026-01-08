require("util")

vim.pack.add({
	{ src = "https://github.com/hat0uma/csvview.nvim" },
})

local Csvview = require("csvview")

Csvview.setup()
