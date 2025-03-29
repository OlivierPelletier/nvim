return {
  -- Java
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
      },
    },
  },
  -- Rust
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt", lsp_format = "fallback" },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        ["rustaceanvim.neotest"] = {},
      },
    },
  },
  -- Markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      enabled = false,
    },
  },
}
