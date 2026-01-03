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
})

require("which-key").setup({
        preset = "helix"
})
require("mason").setup()

vim.lsp.enable({ "lua_ls", "gopls", "rust_analyzer" })
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

vim.cmd("colorscheme catppuccin-frappe")
