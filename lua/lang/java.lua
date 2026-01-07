vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-jdtls" },
})

local Dap = require("dap")
local Jdtls = require("jdtls")
local JdtlsDap = require("jdtls.dap")
local MasonRegistry = require("mason-registry")

local languageServersAndTools = {
	"jdtls",
	"java-debug-adapter",
	"java-test",
}

MasonRegistry.refresh(function()
	for _, tool in ipairs(languageServersAndTools) do
		local p = MasonRegistry.get_package(tool)
		if not p:is_installed() then
			p:install()
		end
	end
end)

local extend_or_override = function(base, extra)
	if not extra then
		return base
	end
	return vim.tbl_deep_extend("force", base, extra)
end

local cmd = { vim.fn.exepath("jdtls") }
local lombok_jar = vim.fn.expand("$MASON/share/jdtls/lombok.jar")
table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))

local opts = {
	root_dir = function(path)
		return vim.fs.root(path, vim.lsp.config.jdtls.root_markers)
	end,

	project_name = function(root_dir)
		return root_dir and vim.fs.basename(root_dir)
	end,

	jdtls_config_dir = function(project_name)
		return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
	end,
	jdtls_workspace_dir = function(project_name)
		return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
	end,

	cmd = cmd,
	full_cmd = function(opts)
		local fname = vim.api.nvim_buf_get_name(0)
		local root_dir = opts.root_dir(fname)
		local project_name = opts.project_name(root_dir)
		local cmd = vim.deepcopy(opts.cmd)
		if project_name then
			vim.list_extend(cmd, {
				"-configuration",
				opts.jdtls_config_dir(project_name),
				"-data",
				opts.jdtls_workspace_dir(project_name),
			})
		end
		return cmd
	end,

	dap = { hotcodereplace = "auto", config_overrides = {} },
	dap_main = {},
	test = true,
	settings = {
		java = {
			inlayHints = {
				parameterNames = {
					enabled = "all",
				},
			},
		},
	},
}

local bundles = vim.fn.glob("$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin-*jar", false, true)
vim.list_extend(bundles, vim.fn.glob("$MASON/share/java-test/*.jar", false, true))

local function attach_jdtls()
	local fname = vim.api.nvim_buf_get_name(0)

	local config = extend_or_override({
		cmd = opts.full_cmd(opts),
		root_dir = opts.root_dir(fname),
		init_options = {
			bundles = bundles,
		},
		settings = opts.settings,
		capabilities = nil,
	}, opts.jdtls)

	Jdtls.start_or_attach(config)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "java" },
	callback = attach_jdtls,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == "jdtls" then
			vim.keymap.set("n", "<leader>co", function()
				Jdtls.organize_imports()
			end, { desc = "Organize Imports" })

			Jdtls.setup_dap(opts.dap)
			if opts.dap_main then
				JdtlsDap.setup_dap_main_class_configs(opts.dap_main)
			end

			vim.keymap.set("n", "<leader>tt", function()
				JdtlsDap.test_class()
			end, { desc = "Run All Test" })
			vim.keymap.set("n", "<leader>tr", function()
				JdtlsDap.test_nearest_method()
			end, { desc = "Run Nearest Test" })
			vim.keymap.set("n", "<leader>tT", function()
				JdtlsDap.pick_test()
			end, { desc = "Run Test" })

			if opts.on_attach then
				opts.on_attach(args)
			end
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
