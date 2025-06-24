return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        json = { "prettier", lsp_format = "fallback" },
        jsonc = { "prettier", lsp_format = "fallback" },
      },
    },
  },
}
