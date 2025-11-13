return {
  {
    "folke/sidekick.nvim",
    opts = {},
    keys = {
      { "<tab>", false, mode = { "n" }, expr = true },
      {
        "<c-.>",
        function()
          require("sidekick.cli").toggle({ name = "opencode" })
        end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
    },
  },
  {
    "Saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = vim.tbl_extend("force", opts.keymap, {
        ["<C-f>"] = {
          LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }),
          "fallback",
        },
        ["<Tab>"] = {},
      })
    end,
  },
}
