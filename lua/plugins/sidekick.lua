return {
  {
    "folke/sidekick.nvim",
    opts = {
      -- add any options here
    },
    keys = {
      { "<C-f>", LazyVim.cmp.map({ "ai_nes" }, "<C-f>"), mode = { "n" }, expr = true },
      { "<Tab>", false, mode = { "n" }, expr = true },
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
