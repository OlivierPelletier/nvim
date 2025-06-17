return {
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<Tab>",
          clear_suggestion = "<C-k>",
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

      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          require("supermaven-nvim.completion_preview").disable_inline_completion = true
          require("supermaven-nvim.completion_preview").on_dispose_inlay()
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuClose",
        callback = function()
          require("supermaven-nvim.completion_preview").disable_inline_completion = false
          local buffer = vim.api.nvim_get_current_buf()
          local file_name = vim.api.nvim_buf_get_name(buffer)
          require("supermaven-nvim.binary.binary_handler"):on_update(buffer, file_name, "text_changed")
          require("supermaven-nvim.binary.binary_handler"):poll_once()
        end,
      })
    end,
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      keymap = {
        ["<C-x>"] = {
          function(cmp)
            if cmp.is_visible() then
              require("blink.cmp").hide()
              require("supermaven-nvim.completion_preview").disable_inline_completion = false
            else
              require("supermaven-nvim.completion_preview").on_dispose_inlay()
            end
          end,
        },
      },
    },
  },
}
