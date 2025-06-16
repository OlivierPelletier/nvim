return {
  {
    "saghen/blink.cmp",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
    },
    opts = {
      sources = {
        default = { "lsp" },
      },
    },
  },
}
