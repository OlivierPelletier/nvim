return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        json = { lsp_format = "first" },
        jsonc = { lsp_format = "first" },
      },
    },
  },
}
