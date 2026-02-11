require("util")

vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/stevearc/conform.nvim" },
})

local languageServersAndTools = {
  "fish-lsp",
	"json-lsp",
	"lua-language-server",
	"pyright",
	"terraform-ls",
	"yaml-language-server",
	--
	"black",
	"gofumpt",
	"goimports",
	"google-java-format",
	"isort",
	"prettierd",
  "sqlfluff",
	"stylua",
	"xmlformatter",
}

MasonCheckAndInstallPackages(languageServersAndTools)

local Blink = require("blink.cmp")
local Conform = require("conform")

Conform.setup({
	formatters = {
		sqlfluff = {
			args = { "format", "--dialect=ansi", "-" },
		},
	},
	formatters_by_ft = {
		astro = { "prettierd" },
		css = { "prettierd" },
		go = { "goimports", "gofumpt" },
		graphql = { "prettierd" },
		html = { "prettierd" },
		java = { "google-java-format" },
		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		json = { "prettierd" },
		jsonc = { "prettierd" },
		less = { "prettierd" },
		lua = { "stylua" },
		markdown = { "prettierd" },
		["markdown.mdx"] = { "prettierd" },
		mysql = { "sqlfluff" },
		plsql = { "sqlfluff" },
		python = { "isort", "black" },
		rust = { lsp_format = "fallback" },
		scss = { "prettierd" },
		sql = { "sqlfluff" },
		svelte = { "prettierd" },
		toml = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		vue = { "prettierd" },
		xml = { "xmlformatter" },
		yaml = { "prettierd" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
})
Blink.setup({
	fuzzy = { implementation = "lua" },
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
		providers = {
			copilot = {
				name = "copilot",
				module = "blink-copilot",
				async = true,
			},
		},
	},
	completion = {
		trigger = {
			prefetch_on_insert = true,
		},
		menu = {
			auto_show = false,
		},
		ghost_text = {
			enabled = true,
		},
		accept = {
			auto_brackets = {
				enabled = false,
			},
		},
		list = {
			cycle = {
				from_bottom = true,
				from_top = true,
			},
		},
	},
  -- stylua: ignore start
	keymap = {
		preset = "none",
		["<C-d>"] = { "scroll_documentation_down", "fallback" },
		["<C-f>"] = { "accept", "fallback" },
		["<C-g>"] = { function(cmp) if cmp.get_items()[1] ~= nil and cmp.get_items()[1].source_id == "copilot" then if cmp.select_next({auto_insert = false, on_ghost_text = true}) then return true end end return cmp.show({ providers = { "copilot" }}) end },
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-u>"] = { "scroll_documentation_up", "fallback" },
		["<C-x>"] = { function(cmp) if cmp.is_menu_visible() then return cmp.hide() end end,	"fallback" },
		["<CR>"] = { function(cmp) if cmp.is_menu_visible() then return cmp.accept() end end,	"fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { function(cmp) if cmp.is_menu_visible() then return cmp.select_prev()	end	end,"fallback" },
		["<Tab>"] = { function(cmp) if cmp.is_menu_visible() then return cmp.select_next()	end	end,"fallback" },
		["<Up>"] = { "select_prev", "fallback" },
	},
	cmdline = {
		keymap = {
			preset = "none",
			["<C-f>"] = { "accept", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-x>"] = { function(cmp) if cmp.is_menu_visible() then return cmp.hide() end end,	"fallback" },
      ["<CR>"] = { function(cmp) if cmp.is_menu_visible() then return cmp.accept() end end,	"fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { function(cmp) if cmp.is_menu_visible() then return cmp.select_prev()	end	end,"fallback" },
      ["<Tab>"] = { function(cmp) if cmp.is_menu_visible() then return cmp.select_next()	end	end,"fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
		},
	},
	-- stylua: ignore end
})

-- stylua: ignore start
vim.keymap.set("n", "<C-b>", "<Plug>(nvim.lsp.ctrl-s)")
vim.keymap.set("n", "<M-n>", function() Snacks.words.jump(vim.v.count1, true) end, { desc = "Next Reference", })
vim.keymap.set("n", "<M-p>", function() Snacks.words.jump(-vim.v.count1, true) end, { desc = "Prev Reference", })
vim.keymap.set("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
vim.keymap.set("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
vim.keymap.set("n", "<leader>cl", function() Snacks.picker.lsp_config() end, { desc = "Lsp Info" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>sS", Snacks.picker.lsp_workspace_symbols, { desc = "Workspace Symbols"})
vim.keymap.set("n", "<leader>ss", Snacks.picker.lsp_symbols, { desc = "Symbols"})
vim.keymap.set("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference", })
vim.keymap.set("n", "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference", })
vim.keymap.set("n", "gD", Snacks.picker.lsp_declarations, { desc = "Goto Declaration" })
vim.keymap.set("n", "gI", Snacks.picker.lsp_implementations, { desc = "Goto Implementation" })
vim.keymap.set("n", "gK", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions, { desc = "Goto Definition" })
vim.keymap.set("n", "gr", Snacks.picker.lsp_references, { desc = "References" })
vim.keymap.set("n", "gy", Snacks.picker.lsp_type_definitions, { desc = "Goto T[y]pe Definition" })
vim.keymap.set("n", "K", function() return vim.lsp.buf.hover() end, { desc = "Hover" })
vim.keymap.set({ "n", "i" }, "<C-k>", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
vim.keymap.set({ "n", "v" }, "<leader>cf", function()	Conform.format()end, { desc = "Format code" })
vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
-- stylua: ignore end

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
vim.lsp.enable({
  "fish_lsp",
	"json-ls",
	"lua_ls",
	"pyright",
	"terraformls",
	"yamlls",
})

-- inlayHint, folds and codeLens
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local buffer = args.buf

		if client == nil then
			return
		end

		if client:supports_method("textDocument/inlayHint") then
			if
				vim.api.nvim_buf_is_valid(buffer)
				and vim.bo[buffer].buftype == ""
				and not vim.tbl_contains({ "vue" }, vim.bo[buffer].filetype)
			then
				vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
			end
		end

		if client:supports_method("textDocument/foldingRange") then
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
		end

		if client:supports_method("textDocument/codeLens") then
			vim.lsp.codelens.refresh({ bufnr = buffer })
			vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
				buffer = buffer,
				callback = function()
					vim.lsp.codelens.refresh({ bufnr = buffer })
				end,
			})
		end
	end,
})

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

require("lang.java")
require("lang.go")
require("lang.rust")
require("lang.vue")
require("lang.csv")
require("lang.sql")
require("lang.markdown")
