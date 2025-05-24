-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.updatetime = 50
-- enable mouse support
vim.o.mouse = "a"
-- line numbers
vim.o.number = true
vim.o.signcolumn = "yes"
-- spacing
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
-- searching
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true -- show search results as you type
vim.o.hlsearch = true  -- highlight search results
-- undos/swapfiles
vim.o.swapfile = false
-- silent vim (no beeps)
vim.o.visualbell = true
-- style things
vim.o.termguicolors = true
vim.o.background = "dark" -- related to colors/hybrid.vim
-- delete without yanking
vim.keymap.set("n", "dd", "\"_dd")
vim.keymap.set("n", "d", "\"_d")
vim.keymap.set("v", "d", "\"_d")
vim.keymap.set("n", "x", "\"_x")
vim.keymap.set("n", "c", "\"_c")
vim.keymap.set("v", "c", "\"_c")
-- replace selected text without yanking
vim.keymap.set("v", "p", "\"_dP")
-- copy/paste from/to os clipboard with <leader>
vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y", { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>p", "\"+p", { desc = "Paste after cursor from clipboard" })
