local MasonRegistry = require("mason-registry")
local Snacks = require("snacks")

local languageServersAndTools = {
	"vtsls",
	"vue-language-server",
}

MasonRegistry.refresh(function()
	for _, tool in ipairs(languageServersAndTools) do
		local p = MasonRegistry.get_package(tool)
		if not p:is_installed() then
			p:install()
		end
	end
end)

vim.lsp.config("vtsls", {
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
	settings = {
		complete_function_calls = true,
		vtsls = {
			enableMoveToFileCodeAction = true,
			autoUseWorkspaceTsdk = true,
			experimental = {
				maxInlayHintLength = 30,
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
			tsserver = {
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = vim.fn.expand("$MASON/packages")
							.. "/vue-language-server"
							.. "/node_modules/@vue/language-server",
						languages = { "vue" },
						configNamespace = "typescript",
						enableForWorkspaceTypeScriptVersions = true,
					},
				},
			},
		},
		typescript = {
			updateImportsOnFileMove = { enabled = "always" },
			suggest = {
				completeFunctionCalls = true,
			},
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = false },
			},
		},
		javascript = {
			updateImportsOnFileMove = { enabled = "always" },
			suggest = {
				completeFunctionCalls = true,
			},
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = false },
			},
		},
	},
})
vim.lsp.config("vue_ls", {})
vim.lsp.enable({ "vtsls", "vue_ls" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == "vtsls" then
      -- stylua: ignore start
			vim.keymap.set("n", "<leader>xD", function() local win = vim.api.nvim_get_current_win() local params = vim.lsp.util.make_position_params(win, "utf-16") vim.lsp.buf_request(0, "workspace/executeCommand", { command = "typescript.goToSourceDefinition", arguments = { params.textDocument.uri, params.position }, }, DisplayLspResults("Source Definition", true)) end, { desc = "(vtsls) Goto Source Definition" })
			vim.keymap.set("n", "<leader>xR", function() vim.lsp.buf_request( 0, "workspace/executeCommand", { command = "typescript.findAllFileReferences", arguments = { vim.uri_from_bufnr(0) } }, DisplayLspResults("File References", false)) end, { desc = "(vtsls) File References" })
			vim.keymap.set("n", "<leader>xo", function() vim.lsp.buf.code_action({ apply = true, context = { only = { "source.organizeImports" }, diagnostics = {} }, }) end, { desc = "(vtsls) Organize Imports" })
			vim.keymap.set("n", "<leader>xM", function() vim.lsp.buf.code_action({ apply = true, context = { only = { "source.addMissingImports.ts" }, diagnostics = {} }, }) end, { desc = "(vtsls) Add missing imports" })
			vim.keymap.set("n", "<leader>xu", function() vim.lsp.buf.code_action({ apply = true, context = { only = { "source.removeUnused.ts" }, diagnostics = {} }, }) end, { desc = "(vtsls) Remove unused imports" })
			vim.keymap.set("n", "<leader>xD", function() vim.lsp.buf.code_action({ apply = true, context = { only = { "source.fixAll.ts" }, diagnostics = {} } }) end, { desc = "(vtsls) Fix all diagnostics" })
			vim.keymap.set("n", "<leader>xV", function() vim.lsp.buf_request(0, "workspace/executeCommand", { command = "typescript.selectTypeScriptVersion" }) end, { desc = "(vtsls) Select TS workspace version" })
			-- stylua: ignore end
		end
	end,
})

vim.lsp.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
	---@type any
	local args = command.arguments
	local action, uri, range = args[1], args[2], args[3]
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	local bufnr = vim.uri_to_bufnr(uri)
	local fname = vim.uri_to_fname(uri)

	vim.ui.input({
		prompt = "Move to file: ",
		default = vim.fn.fnamemodify(fname, ":h") .. "/",
		completion = "file",
	}, function(input)
		if client and input and input ~= "" then
			client:request(
				"workspace/executeCommand",
				{ command = command.command, arguments = { action, uri, range, input } },
				nil,
				bufnr
			)
		end
	end)
end

---@param title string
---@param auto_jump boolean
---@return lsp.Handler
function DisplayLspResults(title, auto_jump)
	return function(_, result, _, _)
		if not result then
			vim.notify("No result from command", vim.log.levels.WARN)
			return
		end

		if vim.tbl_isempty(result) then
			vim.notify("No file references found", vim.log.levels.INFO)
			return
		end

		---@type snacks.picker.finder.Item[]
		local items = {}
		for _, loc in ipairs(result) do
			local target_uri = loc.targetUri or loc.uri
			local range = loc.targetRange or loc.range
			local fname = vim.uri_to_fname(target_uri)
			local line = range.start.line + 1
			local column = range.start.character + 1

			---@type snacks.picker.finder.Item
			local item = {
				text = fname .. ":" .. line .. ":" .. column,
				file = fname,
				pos = {
					line,
					column,
				},
			}

			table.insert(items, item)
		end

		Snacks.picker.pick({
			items = items,
			title = title,
			format = "file",
			jump = { close = true },
			preview = "file",
			auto_confirm = auto_jump,
		})
	end
end
