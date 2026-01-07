vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
})

local languageServers = {
	"lua_ls",
	"gopls",
	"jdtls",
	"jsonls",
	"pyright",
	"rust_analyzer",
	"vtsls",
	"vue_ls",
	"yamlls",
}

local additionnalTools = {
	"black",
	"gofumpt",
	"goimports",
	"google-java-format",
	"isort",
	"prettierd",
}

local Mason = require("mason")
local MasonLspConfig = require("mason-lspconfig")
local MasonRegistry = require("mason-registry")
local Conform = require("conform")

Mason.setup()
MasonLspConfig.setup({
	automatic_enable = {
		exclude = {
			"jdtls",
		},
	},
	ensure_installed = languageServers,
})

MasonRegistry.refresh(function()
	for _, tool in ipairs(additionnalTools) do
		local p = MasonRegistry.get_package(tool)
		if not p:is_installed() then
			p:install()
		end
	end
end)

Conform.setup({
	formatters_by_ft = {
		go = { "goimports", "gofumpt" },
		java = { "google-java-format" },
		javascript = { "prettierd" },
		lua = { "stylua" },
		python = { "isort", "black" },
		rust = { lsp_format = "fallback" },
	},
})

-- stylua: ignore start
vim.keymap.set("n", "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference", })
vim.keymap.set("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference", })
vim.keymap.set("n", "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, { desc = "Next Reference", })
vim.keymap.set("n", "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, { desc = "Prev Reference", })
vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions, { desc = "Goto Definition" })
vim.keymap.set("n", "gr", Snacks.picker.lsp_references, { desc = "References" })
vim.keymap.set("n", "gI", Snacks.picker.lsp_implementations, { desc = "Goto Implementation" })
vim.keymap.set("n", "gy", Snacks.picker.lsp_type_definitions, { desc = "Goto T[y]pe Definition" })
vim.keymap.set("n", "gD", Snacks.picker.lsp_declarations, { desc = "Goto Declaration" })
vim.keymap.set("n", "gk", function() return vim.lsp.buf.hover() end, { desc = "Hover" })
vim.keymap.set("n", "gK", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
vim.keymap.set({"n", "i"}, "<C-k>", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
vim.keymap.set("n", "<C-b>", "<Plug>(nvim.lsp.ctrl-s)")
vim.keymap.set("n", "<leader>cl", function() Snacks.picker.lsp_config() end, { desc = "Lsp Info" })
vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
vim.keymap.set("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
vim.keymap.set("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set({ "n", "v" }, "<leader>cf", function()	Conform.format()end, { desc = "Format code" })
vim.keymap.set("n",  "<leader>ss", Snacks.picker.lsp_symbols, { desc = "Symbols"})
vim.keymap.set("n",  "<leader>sS", Snacks.picker.lsp_workspace_symbols, { desc = "Workspace Symbols"})
-- stylua: ignore end

Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
	if
		vim.api.nvim_buf_is_valid(buffer)
		and vim.bo[buffer].buftype == ""
		and not vim.tbl_contains({ "vue" }, vim.bo[buffer].filetype)
	then
		vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
	end
end)

Snacks.util.lsp.on({ method = "textDocument/foldingRange" }, function()
	vim.wo.foldmethod = "expr"
	vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
end)

Snacks.util.lsp.on({ method = "textDocument/codeLens" }, function(buffer)
	vim.lsp.codelens.refresh()
	vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
		buffer = buffer,
		callback = vim.lsp.codelens.refresh,
	})
end)

local diagnosticIcons = {
	Error = " ",
	Warn = " ",
	Hint = " ",
	Info = " ",
}

vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = function(diagnostic)
			local icons = diagnosticIcons
			for d, icon in pairs(icons) do
				if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
					return icon
				end
			end
			return "●"
		end,
	},
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnosticIcons.Error,
			[vim.diagnostic.severity.WARN] = diagnosticIcons.Warn,
			[vim.diagnostic.severity.HINT] = diagnosticIcons.Hint,
			[vim.diagnostic.severity.INFO] = diagnosticIcons.Info,
		},
	},
})

vim.lsp.config("*", {
	capabilities = {
		workspace = {
			fileOperations = {
				didRename = true,
				willRename = true,
			},
		},
	},
})
vim.lsp.enable("stylua", false)
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				checkThirdParty = false,
			},
			codeLens = {
				enable = false,
			},
			completion = {
				callSnippet = "Replace",
			},
			doc = {
				privateName = { "^_" },
			},
			hint = {
				enable = true,
				setType = false,
				paramType = true,
				paramName = "Disable",
				semicolon = "Disable",
				arrayIndex = "Disable",
			},
		},
	},
})

require("lang.java")
require("lang.go")
require("lang.rust")
require("lang.vue")
