local lazypath = vim.fn.stdpath("config") .. "/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "rebelot/kanagawa.nvim",
    priority = 1000
  },
  {
    "nvim-lualine/lualine.nvim",
    priority = 999,
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "typescript", "bash", "css",
          "jsdoc", "json", "sql", "yaml" },
        sync_install = false,
        auto_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" },             -- Required
      { "williamboman/mason.nvim" },           -- Optional
      { "williamboman/mason-lspconfig.nvim" }, -- Optional

      -- Autocompletion
      { "hrsh7th/nvim-cmp" },     -- Required
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "L3MON4D3/LuaSnip" },     -- Required
    }
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = '0.1.2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  "tpope/vim-sleuth",
  "preservim/nerdcommenter",
})
