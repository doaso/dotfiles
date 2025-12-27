vim.g.mapleader = " "
vim.keymap.set("n", "<leader>d", vim.cmd.Ex)
vim.keymap.set("n", "<C-/>", "<Plug>(comment_toggle_linewise_current)")
vim.keymap.set("v", "<C-/>", "<Plug>(comment_toggle_linewise_visual)")
