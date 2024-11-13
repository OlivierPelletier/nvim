return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  {
    "tpope/vim-surround",
    "RRethy/vim-illuminate",
    "m-demare/hlargs.nvim",
    "danilamihailov/beacon.nvim",
    "airblade/vim-gitgutter",
  },
  {

    "numToStr/Comment.nvim",
    config = true,
  },
}
