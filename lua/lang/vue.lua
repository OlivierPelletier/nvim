local MasonRegistry = require("mason-registry")

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
      vim.keymap.set("n",  "gD", function() local win = vim.api.nvim_get_current_win() local params = vim.lsp.util.make_position_params(win, "utf-16") vim.lsp.buf_request(0, "workspace/executeCommand", { command = "typescript.goToSourceDefinition", arguments = { params.textDocument.uri, params.position }, open = true, }) end, {desc = "Goto Source Definition" })
      vim.keymap.set("n",  "gR", function() vim.lsp.buf_request(0, "workspace/executeCommand", { command = "typescript.findAllFileReferences", arguments = { vim.uri_from_bufnr(0) }, open = true, }) end, {desc = "File References" })
      vim.keymap.set("n",  "<leader>co", function() vim.lsp.buf.code_action({ apply = true, context = { only = { "source.organizeImports" }, diagnostics = {}}}) end, { desc = "Organize Imports" })
      vim.keymap.set("n",  "<leader>cM", function() vim.lsp.buf.code_action({ apply = true, context = { only = { "source.addMissingImports.ts" }, diagnostics = {}}}) end, { desc = "Add missing imports" })
      vim.keymap.set("n",  "<leader>cu", function() vim.lsp.buf.code_action({ apply = true, context = { only = { "source.removeUnused.ts" }, diagnostics = {}}}) end, { desc = "Remove unused imports" })
      vim.keymap.set("n",  "<leader>cD", function() vim.lsp.buf.code_action({ apply = true, context = { only = { "source.fixAll.ts" }, diagnostics = {}}}) end, { desc = "Fix all diagnostics" })
      vim.keymap.set("n",  "<leader>cV", function() vim.lsp.buf_request(0, "workspace/executeCommand", { command = "typescript.selectTypeScriptVersion" }) end, { desc = "Select TS workspace version" })
			-- stylua: ignore end
		end
	end,
})

Snacks.util.lsp.on({ name = "vtsls" }, function(buffer, client)
	client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
		---@type string, string, lsp.Range
		local action, uri, range = unpack(command.arguments)

		local function move(newf)
			client:request("workspace/executeCommand", {
				command = command.command,
				arguments = { action, uri, range, newf },
			})
		end

		local fname = vim.uri_to_fname(uri)
		client:request("workspace/executeCommand", {
			command = "typescript.tsserverRequest",
			arguments = {
				"getMoveToRefactoringFileSuggestions",
				{
					file = fname,
					startLine = range.start.line + 1,
					startOffset = range.start.character + 1,
					endLine = range["end"].line + 1,
					endOffset = range["end"].character + 1,
				},
			},
		}, function(_, result)
			---@type string[]
			local files = result.body.files
			table.insert(files, 1, "Enter new path...")
			vim.ui.select(files, {
				prompt = "Select move destination:",
				format_item = function(f)
					return vim.fn.fnamemodify(f, ":~:.")
				end,
			}, function(f)
				if f and f:find("^Enter new path") then
					vim.ui.input({
						prompt = "Enter move destination:",
						default = vim.fn.fnamemodify(fname, ":h") .. "/",
						completion = "file",
					}, function(newf)
						return newf and move(newf)
					end)
				elseif f then
					move(f)
				end
			end)
		end)
	end
end)
