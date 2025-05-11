-- set leader key explicitly (backslash is default)
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- delete without yanking
vim.keymap.set("n", "dd", "\"_dd")
vim.keymap.set("n", "d", "\"_d")
vim.keymap.set("v", "d", "\"_d")
vim.keymap.set("n", "x", "\"_x")
vim.keymap.set("n", "c", "\"_c")
vim.keymap.set("v", "c", "\"_c")

-- replace selected text without yanking
vim.keymap.set("v", "p", "\"_dP")
