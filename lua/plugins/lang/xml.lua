return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        xml = { "xmlformatter", lsp_format = "fallback" },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "xmlformatter" } },
  },
}
