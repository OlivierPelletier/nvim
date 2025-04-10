return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = false,
        hide_during_completion = true,
        trigger_on_accept = true,
        keymap = {
          accept = false, -- Handled by blink
          next = false, -- Handled by blink
          prev = false, -- Handled by blink
          dismiss = "<C-c>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      keymap = {
        ["<S-Tab>"] = {
          function(cmp)
            cmp.hide()
            require("copilot.suggestion").prev()
          end,
        },
        ["<Tab>"] = {
          function(cmp)
            cmp.hide()
            require("copilot.suggestion").next()
          end,
        },
        ["<CR>"] = {
          function(cmp)
            if require("copilot.suggestion").is_visible() then
              require("copilot.suggestion").accept()
              require("copilot.suggestion").dismiss()
              cmp.show()
            elseif cmp.is_visible() then
              cmp.accept()
            else
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
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
        LazyVim.lualine.status(LazyVim.config.icons.kinds.Copilot, function()
          local clients = package.loaded["copilot"] and LazyVim.lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
          if #clients > 0 then
            local status = require("copilot.api").status.data.status
            return (status == "InProgress" and "pending") or (status == "Warning" and "error") or "ok"
          end
        end)
      )
    end,
  },
}
