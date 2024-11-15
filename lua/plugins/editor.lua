return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_files = {
          enabled = true,
          leave_dirs_open = false,
        },
        group_empty_dirs = true,
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
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        path_display = {
          "smart",
        },
      },
    },
  },
}
