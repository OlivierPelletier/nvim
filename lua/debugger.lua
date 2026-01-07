vim.pack.add({
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/mfussenegger/nvim-dap" },
})
local NvimDapVirtualText = require("nvim-dap-virtual-text")
local Dapui = require("dapui")
local DapUiWidget = require("dap.ui.widgets")
local Dap = require("dap")
local DapExtVscode = require("dap.ext.vscode")
local PlenaryJson = require("plenary.json")

NvimDapVirtualText.setup({})
Dapui.setup()

vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

local dap_icons = {
  Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
  Breakpoint          = " ",
  BreakpointCondition = " ",
  BreakpointRejected  = { " ", "DiagnosticError" },
  LogPoint            = ".>",
}

for name, sign in pairs(dap_icons) do
  sign = type(sign) == "table" and sign or { sign }
  vim.fn.sign_define(
    "Dap" .. name,
    ---@diagnostic disable-next-line: assign-type-mismatch
    { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
  )
end

DapExtVscode.json_decode = function(str)
  return vim.json.decode(PlenaryJson.json_strip_comments(str))
end

vim.keymap.set("n", "<leader>dB", function() Dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,  { desc = "Breakpoint Condition" })
vim.keymap.set("n", "<leader>db", function() Dap.toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dc", function() Dap.continue() end, { desc = "Run/Continue" })
-- vim.keymap.set("n",  "<leader>da", function() Dap.continue({ before = get_args }) end, { desc = "Run with Args"})
vim.keymap.set("n", "<leader>dC", function() Dap.run_to_cursor() end, { desc = "Run to Cursor" })
vim.keymap.set("n", "<leader>dg", function() Dap.goto_() end, { desc = "Go to Line (No Execute)" })
vim.keymap.set("n", "<leader>di", function() Dap.step_into() end, { desc = "Step Into" })
vim.keymap.set("n", "<leader>dj", function() Dap.down() end, { desc = "Down" })
vim.keymap.set("n", "<leader>dk", function() Dap.up() end, { desc = "Up" })
vim.keymap.set("n", "<leader>dl", function() Dap.run_last() end, { desc = "Run Last" })
vim.keymap.set("n", "<leader>do", function() Dap.step_out() end, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dO", function() Dap.step_over() end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dP", function() Dap.pause() end, { desc = "Pause" })
vim.keymap.set("n", "<leader>dr", function() Dap.repl.toggle() end, { desc = "Toggle REPL" })
vim.keymap.set("n", "<leader>ds", function() Dap.session() end, { desc = "Session" })
vim.keymap.set("n", "<leader>dt", function() Dap.terminate() end, { desc = "Terminate" })
vim.keymap.set("n", "<leader>dw", function() DapUiWidget.hover() end, { desc = "Widgets" })
vim.keymap.set("n", "<leader>du", function() Dapui.toggle({}) end, { desc = "Dap UI" })
vim.keymap.set({ "n", "x" }, "<leader>de", function() Dapui.eval() end, { desc = "Eval", })
