return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
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
    end,
  },
}
