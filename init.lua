vim.o.number = true
vim.o.relativenumber = false
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.shell = "fish"

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smartindent = true

vim.o.swapfile = false
vim.o.undofile = true
vim.o.backup = false
vim.o.writebackup = false

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.winborder = "rounded"
vim.o.termguicolors = true
vim.o.confirm = true
vim.o.showtabline = 0

vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menu,menuone,noselect"

vim.g.mapleader = " "

vim.pack.add({
  { src = "https://github.com/catppuccin/nvim" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/nvim-mini/mini.files" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/ThePrimeagen/Harpoon",           version = "harpoon2" },
})

local Catppuccin = require("catppuccin")
local WhichKey = require("which-key")
local Mason = require("mason")
local TreeSitter = require("nvim-treesitter")
local Snacks = require("snacks")
local MiniFiles = require("mini.files")
local MiniIcons = require("mini.icons")
local NvimWebDevIcons = require("nvim-web-devicons")
local Harpoon = require("harpoon")

vim.keymap.set({ "n", "v", "x" }, "<C-S>", ":write<CR>", { desc = "Save" })
vim.keymap.set({ "i" }, "<C-S>", ":write<CR>", { desc = "Save" })
vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { noremap = true })
vim.keymap.set("i", ".", function() return ".<C-x><C-o>" end, { expr = true, noremap = true })
vim.keymap.set("i", "<C-f>", function()
  if vim.fn.pumvisible() == 1 then
    return vim.api.nvim_replace_termcodes("<C-n><C-y>", true, false, true)
  else
    return vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
  end
end, { expr = true, noremap = true })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Lsp Format code" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Lsp Rename" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Lsp Code Action" })
vim.keymap.set("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
vim.keymap.set("n", "<leader>e", MiniFiles.open, { desc = "Files explorer" })
vim.keymap.set("n", "<leader>/", Snacks.picker.grep, { desc = "Grep" })
vim.keymap.set("n", "<leader><space>", Snacks.picker.files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "References", nowait = true })
vim.keymap.set("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
vim.keymap.set("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
vim.keymap.set("n", "gai", function() Snacks.picker.lsp_incoming_calls() end, { desc = "C[a]lls Incoming" })
vim.keymap.set("n", "gao", function() Snacks.picker.lsp_outgoing_calls() end, { desc = "C[a]lls Outgoing" })
vim.keymap.set("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end,
  { desc = "LSP Workspace Symbols" })
vim.keymap.set("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
vim.keymap.set({ "n", "t" }, "<c-/>", function() Snacks.terminal() end, { desc = "Toggle Terminal" })
vim.keymap.set("n", "<M-q>", function() Harpoon:list():add() end, { desc = "Harpoon Add" })
vim.keymap.set("n", "<M-/>", function() Harpoon.ui:toggle_quick_menu(Harpoon:list()) end, { desc = "Harpoon Quick Menu" })
vim.keymap.set("n", "<M-1>", function() Harpoon:list():select(1) end, { desc = "Harpoon Select 1" })
vim.keymap.set("n", "<M-2>", function() Harpoon:list():select(2) end, { desc = "Harpoon Select 2" })
vim.keymap.set("n", "<M-3>", function() Harpoon:list():select(3) end, { desc = "Harpoon Select 3" })
vim.keymap.set("n", "<M-4>", function() Harpoon:list():select(4) end, { desc = "Harpoon Select 4" })

Catppuccin.setup({
  transparent_background = true
})
WhichKey.setup({
  preset = "helix"
})
Mason.setup()
TreeSitter.setup({
  ensure_installed = { "lua", "go", "go", "gomod", "gowork", "gosum", "rust" },
  highlight = { enable = true }
})
Snacks.setup({
  bigfile = { enabled = false },
  dashboard = { enabled = false },
  explorer = { enabled = false },
  indent = { enabled = false },
  input = { enabled = false },
  picker = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = false },
  scope = { enabled = false },
  scroll = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
})
MiniFiles.setup()
MiniIcons.setup()
NvimWebDevIcons.setup()
Harpoon.setup()

vim.lsp.enable({ "lua_ls", "gopls", "rust-analyzer" })
vim.lsp.inlay_hint.enable(true)

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "go", "rust" },
  callback = function() vim.treesitter.start() end,
})
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
  end,
})
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end
    _G.bt = function()
      Snacks.debug.backtrace()
    end

    vim.print = _G.dd

    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
    Snacks.toggle.diagnostics():map("<leader>ud")
    Snacks.toggle.line_number():map("<leader>ul")
    Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
        :map("<leader>uc")
    Snacks.toggle.treesitter():map("<leader>uT")
    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map(
      "<leader>ub")
    Snacks.toggle.inlay_hints():map("<leader>uh")
    Snacks.toggle.indent():map("<leader>ug")
    Snacks.toggle.dim():map("<leader>uD")
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesActionRename",
  callback = function(event)
    Snacks.rename.on_rename_file(event.data.from, event.data.to)
  end,
})

vim.cmd("colorscheme catppuccin-mocha")
