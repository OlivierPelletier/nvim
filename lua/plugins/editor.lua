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
      },
    },
  },
  {
    "petertriho/nvim-scrollbar",
    config = function()
      local colors = require("monokai-pro.colorscheme")

      require("scrollbar").setup({
        handle = {
          color = colors.editor.selectionHighlightBackground,
        },
        handlers = {
          gitsigns = true,
        },
      })
    end,
  },
}
