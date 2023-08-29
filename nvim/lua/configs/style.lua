-- related to colors/hybrid.vim
vim.cmd.colorscheme "hybrid"
vim.o.background = "dark"
vim.g.hybrid_custom_term_colors = 1
vim.g.hybrid_reduced_contrast = 1
vim.cmd.AirlineTheme "distinguished"
-- Remove the background from float window
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
