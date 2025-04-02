return {
  {
    import = "plugins.lang",
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = {
            hidden = true,
          },
          explorer = {
            hidden = true,
            ignored = true,
          },
        },
      },
    },
  },
  {
    "petertriho/nvim-scrollbar",
    config = function()
      local colors = require("catppuccin.palettes").get_palette("mocha")

      require("scrollbar").setup({
        handle = {
          color = colors.overlay2,
        },
        handlers = {
          gitsigns = true,
        },
        marks = {
          Search = { color = colors.yellow },
          Error = { color = colors.red },
          Warn = { color = colors.peach },
          Info = { color = colors.text },
          Hint = { color = colors.teal },
          Misc = { color = colors.mauve },
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    opts = {
      defaults = {
        formatter = "path.filename_first",
      },
    },
  },
}
