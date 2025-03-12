return {
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
    "tiagovla/scope.nvim",
    config = function()
      require("scope").setup({})
    end,
  },
  {
    "ibhagwan/fzf-lua",
    opts = {
      defaults = {
        formatter = "path.filename_first",
      },
    },
  },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   opts = {
  --     suggestion = {
  --       enabled = true,
  --     },
  --   },
  -- },
  {
    "hat0uma/csvview.nvim",
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  }
}
