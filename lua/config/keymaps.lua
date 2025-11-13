-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.cmd("imap <C-c> <Esc>")

vim.keymap.del("n", "<leader><tab><tab>")
vim.keymap.del("n", "<leader><tab>]")
vim.keymap.del("n", "<leader><tab>[")
vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab><S-tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
vim.keymap.set("n", "<C-n>", "<cmd>enew<cr>", { desc = "New empty buffer" })
vim.keymap.set("n", "<C-f>", function()
  local Nes = require("sidekick.nes")
  if Nes.have() and (Nes.jump() or Nes.apply()) then
    return true
  end
end, { desc = "plz AI Next" })
vim.keymap.set("s", "<C-f>", function()
  local Nes = require("sidekick.nes")
  if Nes.have() and (Nes.jump() or Nes.apply()) then
    return true
  end
end, { desc = "plz AI Next" })
vim.keymap.set("x", "<C-f>", function()
  local Nes = require("sidekick.nes")
  if Nes.have() and (Nes.jump() or Nes.apply()) then
    return true
  end
end, { desc = "plz AI Next" })
