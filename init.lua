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
vim.o.statusline = " "
vim.o.laststatus = 3

vim.o.clipboard = "unnamedplus"

vim.g.mapleader = " "

vim.diagnostic.config({
  virtual_text = true,
})

vim.pack.add({
  { src = "https://github.com/catppuccin/nvim" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/nvim-mini/mini.files" },
  { src = "https://github.com/ThePrimeagen/harpoon",           version = "harpoon2" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/rcarriga/nvim-notify" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/folke/noice.nvim" },
  { src = "https://github.com/folke/lazydev.nvim" },
  { src = "https://github.com/saghen/blink.cmp" }
})

local Catppuccin = require("catppuccin")
local MiniIcons = require("mini.icons")
local NvimWebDevIcons = require("nvim-web-devicons")
local Snacks = require("snacks")
local WhichKey = require("which-key")
local TreeSitter = require("nvim-treesitter")
local Mason = require("mason")
local MasonLspConfig = require("mason-lspconfig")
local MiniFiles = require("mini.files")
local Harpoon = require("harpoon")
local GitSigns = require("gitsigns")
local LuaLine = require("lualine")
local Noice = require("noice")
local LazyDev = require("lazydev")
local Blink = require("blink.cmp")

vim.keymap.set({ "n", "v", "x" }, "<C-S>", ":write<CR>", { desc = "Save" })
vim.keymap.set({ "i" }, "<C-S>", ":write<CR>", { desc = "Save" })
vim.keymap.set("i", "<C-f>", function()
  if Blink.is_active() then
    return Blink.accept()
  else
    return vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
  end
end, { expr = true, noremap = true })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Lsp Format code" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Lsp Rename" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Lsp Code Action" })
vim.keymap.set("n", "<leader>cR", Snacks.rename.rename_file, { desc = "Rename File" })
vim.keymap.set("n", "<leader>e", MiniFiles.open, { desc = "Files Explorer" })
vim.keymap.set("n", "<leader>fm", function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end,
  { desc = "Files Explorer" })
vim.keymap.set("n", "<leader>fM", function() MiniFiles.open(vim.uv.cwd()) end, { desc = "Files Explorer (cwd)" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep({ hidden = true }) end, { desc = "Grep" })
vim.keymap.set("n", "<leader><space>", function() Snacks.picker.files({ hidden = true }) end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>,", Snacks.picker.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>n", Snacks.picker.notifications, { desc = "Notifications" })
vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions, { desc = "Goto Definition" })
vim.keymap.set("n", "gD", Snacks.picker.lsp_declarations, { desc = "Goto Declaration" })
vim.keymap.set("n", "gr", Snacks.picker.lsp_references, { desc = "References", nowait = true })
vim.keymap.set("n", "gI", Snacks.picker.lsp_implementations, { desc = "Goto Implementation" })
vim.keymap.set("n", "gy", Snacks.picker.lsp_type_definitions, { desc = "Goto T[y]pe Definition" })
vim.keymap.set("n", "<leader>sj", Snacks.picker.jumps, { desc = "Jumps" })
vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bo", Snacks.bufdelete.other, { desc = "Delete Other Buffers" })
vim.keymap.set("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
vim.keymap.set({ "n", "t" }, "<c-/>", function() Snacks.terminal() end, { desc = "Toggle Terminal" })
vim.keymap.set("n", "<M-q>", function() Harpoon:list():add() end, { desc = "Harpoon Add" })
vim.keymap.set("n", "<M-/>", function() Harpoon.ui:toggle_quick_menu(Harpoon:list()) end, { desc = "Harpoon Quick Menu" })
vim.keymap.set("n", "<M-1>", function() Harpoon:list():select(1) end, { desc = "Harpoon Select 1" })
vim.keymap.set("n", "<M-2>", function() Harpoon:list():select(2) end, { desc = "Harpoon Select 2" })
vim.keymap.set("n", "<M-3>", function() Harpoon:list():select(3) end, { desc = "Harpoon Select 3" })
vim.keymap.set("n", "<M-4>", function() Harpoon:list():select(4) end, { desc = "Harpoon Select 4" })
vim.keymap.set('n', '<leader>ghs', GitSigns.stage_hunk, { desc = "Stage Hunk" })
vim.keymap.set('n', '<leader>ghr', GitSigns.reset_hunk, { desc = "Reset Hunk" })
vim.keymap.set('n', '<leader>ghS', GitSigns.stage_buffer, { desc = "Stage Buffer" })
vim.keymap.set('n', '<leader>ghR', GitSigns.reset_buffer, { desc = "Reset Buffer" })
vim.keymap.set('n', '<leader>ghp', GitSigns.preview_hunk, { desc = "Preview Hunk" })
vim.keymap.set('n', '<leader>ghi', GitSigns.preview_hunk_inline, { desc = "Preview Hunk Inline" })
vim.keymap.set('n', '<leader>ghb', function() GitSigns.blame_line({ full = true }) end, { desc = "Show Blame" })
vim.keymap.set('n', '<leader>ghd', GitSigns.diffthis, { desc = "Diff This" })
vim.keymap.set({ 'o', 'x' }, 'ih', GitSigns.select_hunk, { desc = "Inner Hunk" })

Catppuccin.setup({
  transparent_background = true,
  float = {
    transparent = true,
    solid = false
  }
})
MiniIcons.setup()
NvimWebDevIcons.setup()
Snacks.setup({
  bigfile = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  picker = { enabled = true },
  notifier = { enabled = true },
  scope = { enabled = true },
  statuscolumn = { enabled = true },
})
WhichKey.setup({
  preset = "helix",
})
TreeSitter.install({ "lua", "go", "gomod", "gowork", "gosum", "rust", "java", "regex", "bash", "sh", "fish" })
Mason.setup()
MasonLspConfig.setup({
  automatic_enable = {
    exclude = {
      "jdtls",
    },
  },
  ensure_installed = { "lua_ls", "gopls", "rust_analyzer", "jdtls" }
})
MiniFiles.setup({
  windows = {
    preview = true,
    width_focus = 30,
    width_preview = 30,
  },
  options = {
    use_as_default_explorer = true,
  },
})
Harpoon.setup()
GitSigns.setup()
LuaLine.setup({
  options = {
    globalstatus = true,
  }
})
Noice.setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = true,
    lsp_doc_border = true,
  },
  popupmenu = {
    enabled = false,
  },
})
Blink.setup({
  fuzzy = { implementation = "lua" }
})

WhichKey.add({
  { "<leader>f",  group = "files" },
  { "<leader>b",  group = "buffers" },
  { "<leader>c",  group = "code" },
  { "<leader>s",  group = "search" },
  { "<leader>u",  group = "toggles" },
  { "<leader>g",  group = "git" },
  { "<leader>gh", group = "hunk" },
  { "<leader>d",  group = "debug" },
  { "<leader>t",  group = "test" },
})

vim.lsp.inlay_hint.enable(true)

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "go", "rust", "java" },
  callback = function() vim.treesitter.start() end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua" },
  callback = function()
    LazyDev.setup({
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      }
    })
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

require("debugger")
require("lang.java")
