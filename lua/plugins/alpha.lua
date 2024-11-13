return {
  {
    "goolord/alpha-nvim",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      require("alpha").setup(require("alpha.themes.startify").config)
      vim.cmd([[autocmd User AlphaReady Neotree]])
    end,
  },
}
