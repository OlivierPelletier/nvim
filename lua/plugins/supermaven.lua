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
        disable_keymaps = true,
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
            local suggestion = require("supermaven-nvim.completion_preview")
            local blink = require("blink.cmp")
            if cmp.is_visible() then
              blink.hide()
              suggestion.disable_inline_completion = false
            else
              suggestion.on_dispose_inlay()
            end
          end,
        },
        ["<C-f>"] = {
          function(cmp)
            local suggestion = require("supermaven-nvim.completion_preview")
            local blink = require("blink.cmp")
            if cmp.is_visible() then
              blink.hide()
              suggestion.disable_inline_completion = false
            else
              if suggestion.has_suggestion() then
                vim.schedule(function()
                  suggestion.on_accept_suggestion()
                end)
              end
            end
          end,
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(
        opts.sections.lualine_x,
        2,
        LazyVim.lualine.status(LazyVim.config.icons.kinds.Supermaven, function()
          return require("supermaven-nvim.api").is_running() and "ok" or "error"
        end)
      )
    end,
  },
}
