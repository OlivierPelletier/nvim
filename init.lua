vim.o.number = true
vim.o.relativenumber = false
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.swapfile = false
vim.o.undofile = true
vim.o.winborder = "rounded"

vim.g.mapleader = " "

vim.keymap.set({ 'n', 'v', 'x' }, '<C-S>', ':write<CR>')
vim.keymap.set({ 'i' }, '<C-S>', ':write<CR>')
vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>e', ':Explore<CR>')

vim.pack.add({
        { src = "https://github.com/catppuccin/nvim" },
        { src = "https://github.com/folke/which-key.nvim" },
        { src = "https://github.com/neovim/nvim-lspconfig" },
        { src = "https://github.com/mason-org/mason.nvim" },
        { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
        { src = "https://github.com/nvim-lua/plenary.nvim" },
        { src = "https://github.com/ThePrimeagen/harpoon",           version = "harpoon2" },
        { src = "https://github.com/folke/snacks.nvim" },
})

require("which-key").setup({
        preset = "helix"
})
require("mason").setup()
require("nvim-treesitter").setup({
        ensure_installed = { "lua", "go", "go", "gomod", "gowork", "gosum", "rust" },
        highlight = { enable = true }
})
require("snacks").setup({
        bigfile = { enabled = true },
        dashboard = { enabled = true },
        explorer = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
})

vim.api.nvim_create_autocmd('FileType', {
        pattern = { "lua", "go", "rust" },
        callback = function() vim.treesitter.start() end,
})

vim.lsp.enable({ "lua_ls", "gopls", "rust-analyzer" })
vim.lsp.inlay_hint.enable(true)

vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
                -- local client = vim.lsp.get_client_by_id(args.data.client_id)

                vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
                local opts = { buffer = args.buf }
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        end,
})
vim.cmd("set completeopt+=noselect")
local harpoon = require("harpoon")
---@diagnostic disable-next-line: missing-parameter
harpoon.setup()

vim.keymap.set("n", "<M-q>", function()
        harpoon:list():add()
end, { desc = "Harpoon Add" })
vim.keymap.set("n", "<M-/>", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon Quick Menu" })

vim.keymap.set("n", "<M-1>", function()
        harpoon:list():select(1)
end, { desc = "Harpoon Select 1" })
vim.keymap.set("n", "<M-2>", function()
        harpoon:list():select(2)
end, { desc = "Harpoon Select 2" })
vim.keymap.set("n", "<M-3>", function()
        harpoon:list():select(3)
end, { desc = "Harpoon Select 3" })
vim.keymap.set("n", "<M-4>", function()
        harpoon:list():select(4)
end, { desc = "Harpoon Select 4" })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<M-w>", function()
        harpoon:list():prev()
end, { desc = "Harpoon Previous" })
vim.keymap.set("n", "<M-e>", function()
        harpoon:list():next()
end, { desc = "Harpoon Next" })

vim.cmd("colorscheme catppuccin-frappe")
