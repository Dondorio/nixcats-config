vim.g.mapleader = " "

vim.keymap.set("n", "<M-b>", "<cmd>bn<CR>", { noremap = true, desc = "Next buffer" })
vim.keymap.set("n", "<M-B>", "<cmd>bp<CR>", { noremap = true, desc = "Previous buffer" })
