return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    config = function()
      require("ibl").setup({
        indent = {
          char = "┆",
        },
        scope = {
          enabled = true,
        },
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  {

    "numToStr/Comment.nvim",
    config = true,
  },
  {
    "tpope/vim-surround",
    "RRethy/vim-illuminate",
    "m-demare/hlargs.nvim",
    "danilamihailov/beacon.nvim",
    "airblade/vim-gitgutter",
  },
}
