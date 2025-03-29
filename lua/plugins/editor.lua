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
    "ibhagwan/fzf-lua",
    opts = {
      defaults = {
        formatter = "path.filename_first",
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function() end
      dap.listeners.before.event_terminated["dapui_config"] = function() end
      dap.listeners.before.event_exited["dapui_config"] = function() end
    end,
  },
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
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      ---@diagnostic disable-next-line: missing-parameter
      harpoon.setup()

      -- Windows
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

      -- Mac OS
      vim.keymap.set("n", "œ", function()
        harpoon:list():add()
      end, { desc = "Harpoon Add" })
      vim.keymap.set("n", "|", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon Quick Menu" })

      vim.keymap.set("n", "¡", function()
        harpoon:list():select(1)
      end, { desc = "Harpoon Select 1" })
      vim.keymap.set("n", "@", function()
        harpoon:list():select(2)
      end, { desc = "Harpoon Select 2" })
      vim.keymap.set("n", "£", function()
        harpoon:list():select(3)
      end, { desc = "Harpoon Select 3" })
      vim.keymap.set("n", "€", function()
        harpoon:list():select(4)
      end, { desc = "Harpoon Select 4" })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "∑", function()
        harpoon:list():prev()
      end, { desc = "Harpoon Previous" })
      vim.keymap.set("n", "∂", function()
        harpoon:list():next()
      end, { desc = "Harpoon Next" })
    end,
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = -100,
            async = true,
          },
        },
      },
      keymap = {
        ["<C-space>"] = {
          function(cmp)
            cmp.show({ providers = { "copilot" } })
          end,
        },
      },
    },
  },
}
