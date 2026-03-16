require("util")

vim.pack.add({
	"https://github.com/mrcjkb/rustaceanvim",
})

local languageServersAndTools = {
	"rust-analyzer",
	"codelldb",
}

MasonCheckAndInstallPackages(languageServersAndTools)

local codelldb = vim.fn.exepath("codelldb")
local sysname = vim.uv.os_uname().sysname
local codelldb_lib_ext = sysname == "Linux" and ".so" or ".dylib"
local library_path = vim.fn.expand("$MASON/opt/lldb/lib/liblldb" .. codelldb_lib_ext)

vim.g.rustaceanvim = {
	server = {
		on_attach = function(_, bufnr)
			vim.keymap.set("n", "<leader>cR", function() vim.cmd.RustLsp("codeAction") end, { desc = "Code Action", buffer = bufnr })
			vim.keymap.set("n", "<leader>dr", function() vim.cmd.RustLsp("debuggables") end, { desc = "Rust Debuggables", buffer = bufnr })
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
				checkOnSave = {
					enable = true,
					command = "clippy",
				},
				diagnostics = {
					enable = true,
					disabled = {},
					experimental = { enable = true },
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
