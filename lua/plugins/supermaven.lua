return {
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<Tab>",
          clear_suggestion = "<C-x>",
          accept_word = "<C-j>",
        },
        ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
        color = {
          suggestion_color = "#a6adc8",
          cterm = 244,
        },
        log_level = "info",
        disable_inline_completion = false,
        disable_keymaps = false,
        condition = function()
          return false
        end,
      })
    end,
  },
}
