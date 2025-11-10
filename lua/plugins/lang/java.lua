return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "google-java-format" } },
  },
}
