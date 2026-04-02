vim.pack.add({
	"https://github.com/mrcjkb/rustaceanvim",
})

local languageServersAndTools = {
	"rust-analyzer",
	"codelldb",
	"bacon",
	"bacon-ls",
}

MasonCheckAndInstallPackages(languageServersAndTools)

vim.lsp.config("bacon_ls", {})
vim.lsp.enable("bacon_ls")

local codelldb = vim.fn.exepath("codelldb")
local sysname = vim.uv.os_uname().sysname
local codelldb_lib_ext = sysname == "Linux" and ".so" or ".dylib"
local library_path = vim.fn.expand("$MASON/opt/lldb/lib/liblldb" .. codelldb_lib_ext)

vim.g.rustaceanvim = {
	server = {
		on_attach = function(_, bufnr)
      -- stylua: ignore start
			vim.keymap.set("n", "<leader>xa", function() vim.cmd.RustLsp("codeAction") end, { desc = "Code Action", buffer = bufnr })
			vim.keymap.set("n", "<leader>xd", function() vim.cmd.RustLsp("debuggables") end, { desc = "Rust Debuggables", buffer = bufnr })
			-- stylua: ignore end
		end,
		default_settings = {
			["rust-analyzer"] = {
				cargo = {
					allFeatures = true,
					loadOutDirsFromCheck = true,
					buildScripts = {
						enable = true,
					},
				},
				checkOnSave = false,
				diagnostics = {
					enable = false,
				},
				procMacro = {
					enable = true,
				},
				files = {
					exclude = {
						".direnv",
						".git",
						".jj",
						".github",
						".gitlab",
						"bin",
						"node_modules",
						"target",
						"venv",
						".venv",
					},
					watcher = "client",
				},
			},
		},
	},
	dap = {
		adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
	},
}
