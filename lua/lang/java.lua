require("util")

vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-jdtls" },
})

local Blink = require("blink.cmp")
local Dap = require("dap")
local Jdtls = require("jdtls")
local JdtlsDap = require("jdtls.dap")

local languageServersAndTools = {
	"jdtls",
	"java-debug-adapter",
	"java-test",
}

MasonCheckAndInstallPackages(languageServersAndTools)

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "java" },
	callback = function()
		local bundles = vim.fn.glob("$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin-*jar", false, true)
		vim.list_extend(bundles, vim.fn.glob("$MASON/share/java-test/*.jar", false, true))

		local project_name =
			vim.fs.basename(vim.fs.root(vim.api.nvim_buf_get_name(0), vim.lsp.config.jdtls.root_markers))

		Jdtls.start_or_attach({
			cmd = {
				vim.fn.exepath("jdtls"),
				string.format("--jvm-arg=-javaagent:%s", vim.fn.expand("$MASON/share/jdtls/lombok.jar")),
				"-configuration",
				vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config",
				"-data",
				vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace",
			},
			root_dir = vim.fs.root(vim.api.nvim_buf_get_name(0), vim.lsp.config.jdtls.root_markers),
			init_options = {
				bundles = bundles,
			},
			settings = {
				java = {
					inlayHints = {
						parameterNames = {
							enabled = "all",
						},
					},
				},
			},
			capabilities = Blink.get_lsp_capabilities(),
		})
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == "jdtls" then
      -- stylua: ignore start
			vim.keymap.set("n", "<leader>xo", function() Jdtls.organize_imports() end, { desc = "Organize Imports" })
			vim.keymap.set("n", "<leader>xt", function() JdtlsDap.test_class() end, { desc = "Run All Test" })
			vim.keymap.set("n", "<leader>xr", function() JdtlsDap.test_nearest_method() end, { desc = "Run Nearest Test" })
			vim.keymap.set("n", "<leader>xT", function() JdtlsDap.pick_test() end, { desc = "Run Test" })
			-- stylua: ignore end

			Jdtls.setup_dap({ hotcodereplace = "auto", config_overrides = {} })
			JdtlsDap.setup_dap_main_class_configs({})
		end
	end,
})

Dap.configurations.java = {
	{
		type = "java",
		request = "attach",
		name = "Debug (Attach) - Remote",
		hostName = "127.0.0.1",
		port = 5005,
	},
}
